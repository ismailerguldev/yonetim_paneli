import AppError, { ConflictError, ForbiddenError, InternalError, UnauthorizedError } from "../models/error.model.js";
import type { RegisterUser, User } from "../models/user.model.js";
import authRepository from "../repositories/auth.repository.js";
import { v4 as uuid } from "uuid"
import bcrypt from "bcrypt";
import type { QueryError } from "mysql2";
import { createAccessToken } from "../utils/jwt.util.js";
import { createRefreshToken } from "../utils/refreshToken.util.js";
import crypto from "crypto"
import { getRefreshToken, insertNewRefreshToken, revokeAllRefreshTokens, revokeRefreshToken } from "../repositories/refreshToken.repository.js";
import { Resend } from "resend";
import { sendMail } from "../config/nodemailer.config.js";
const register = async (userData: RegisterUser) => {
    try {
        const user_id = uuid();
        const hashed_password = await bcrypt.hash(userData.password, 10);
        const user: User = {
            id: user_id,
            firstName: userData.firstName,
            lastName: userData.lastName,
            email: userData.email,
            phone: userData.phone,
            passwordHash: hashed_password,
        };
        return await authRepository.insertNewUser(user);
    } catch (error) {
        if ((error as QueryError).code === 'ER_DUP_ENTRY') {
            throw new ConflictError("Bu kullanıcı zaten kayıtlı.");
        }
        throw error
    }
}

const login = async (credentials: {
    email: string,
    password: string,
    remember: boolean
}) => {
    const result = await authRepository.getUserByEmail(credentials.email);
    if (!result) {
        throw new UnauthorizedError("E posta veya şifre yanlış.")
    }
    const isPasswordMatching = await bcrypt.compare(credentials.password, result.hashedPassword)
    if (!isPasswordMatching) {
        throw new UnauthorizedError("E posta veya şifre yanlış.")
    }
    const accessToken = createAccessToken({
        sub: result.user_id
    })
    const refreshToken = createRefreshToken(credentials.remember ? new Date(Date.now() + 30 * 24 * 60 * 60 * 1000) : new Date(Date.now() + 24 * 60 * 60 * 1000))
    await insertNewRefreshToken(
        refreshToken.tokenId,
        result.user_id,
        refreshToken.token,
        refreshToken.expires
    )
    return {
        accessToken, refreshToken: {
            token: refreshToken.token,
            expires: refreshToken.expires
        }
    }
}
const logout = async (refreshToken: string) => {
    const currentRefreshToken = await getRefreshToken(refreshToken)
    if (!currentRefreshToken || currentRefreshToken.is_revoked === 1 || currentRefreshToken.expires_at < new Date()) {
        return
    }
    const isRevokeSuccess = await revokeRefreshToken(currentRefreshToken.token_id)
    if (!isRevokeSuccess) throw new UnauthorizedError("Çıkış başarısız");
}
const changePassword = async (currentPassword: string, newPassword: string, userId: string) => {
    const passwordFromDB = await authRepository.getHashedPasswordByUserId(userId)
    if (!passwordFromDB) throw new UnauthorizedError("Kullanıcı bulunamadı")
    const isPasswordMatching = await bcrypt.compare(currentPassword, passwordFromDB)
    if (!isPasswordMatching) {
        throw new ForbiddenError("Şifreler uyuşmuyor")
    }
    console.log(isPasswordMatching, "password eşleşmesi", currentPassword, newPassword)
    console.log("user id", userId)
    const hashedNewPassword = await bcrypt.hash(newPassword, 10)
    await authRepository.changeUserPassword(userId, hashedNewPassword)
    return await revokeAllRefreshTokens(userId)
}
const forgotPassword = async (email: string) => {
    const existUser = await authRepository.getUserByEmail(email);
    if (!existUser) return;
    const random = crypto.randomInt(100000, 1000000).toString();
    const isSuccess = await authRepository.addToResetPassword(email, random)
    console.log(isSuccess)
    if (!isSuccess) throw new InternalError("Bir hata meydana geldi");
    await sendMail({ code: random, toMail: email })
}
const resetPassword = async (newPassword: string, newPasswordCheck: string, code: string, email: string) => {
    if (newPassword !== newPasswordCheck) throw new ForbiddenError("Şifreler uyuşmuyor.");
    const resetData = await authRepository.getCode(code, email);
    if (!resetData) throw new ForbiddenError("Kod hatalı!");
    if (resetData.expires_at.getTime() < Date.now()) throw new ForbiddenError("Kod geçersiz!");
    const newPasswordHash = await bcrypt.hash(newPasswordCheck, 10);
    return await authRepository.setNewPassword(newPasswordHash, resetData.email);
}
const getUser = async (id: string) => {
    const user = await authRepository.getUserById(id);
    if (!user) {
        throw new UnauthorizedError("Kullanıcı bulunamadı");
    }
    return user
}
export default {
    register,
    login,
    logout,
    changePassword,
    forgotPassword,
    resetPassword,
    getUser
}