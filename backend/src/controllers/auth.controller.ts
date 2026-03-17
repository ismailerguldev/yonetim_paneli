import type { Request, Response } from "express";
import authService from "../services/auth.service.js";
import { success } from "zod";
import refreshTokenService from "../services/refreshToken.service.js";
import type { RequestUser } from "@/models/user.model.js";
// POST
export const register = async (req: Request, res: Response) => {
    const result = await authService.register(req.body);
    res.status(201).json({
        message: "Kullanıcı başarıyla kayıt edildi.",
        success: result
    });
};

// POST
export const login = async (req: Request, res: Response) => {
    const tokens = await authService.login(req.body)
    res.status(200).json({
        message: "Başarıyla giriş yaptınız.",
        success: true,
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken
    })
};

// POST
export const forgotPassword = async (req: Request, res: Response) => {
    const { email } = req.body;
    await authService.forgotPassword(email);
    res.status(200).json({ message: "E-posta sistemde kayıtlıysa doğrulama linki gönderilmiştir." })
};

export const resetPassword = async (req: Request, res: Response) => {
    const { newPassword, newPasswordCheck, code, email } = req.body
    const result = await authService.resetPassword(newPassword, newPasswordCheck, code, email);
    res.json({ status: result });
}

// POST
export const checkPhone = async (req: Request, res: Response) => {
    // Telefon numarasını kontrol et işlemleri
};

// PUT
export const updateProfile = async (req: Request, res: Response) => {
    // Profil güncelle işlemleri
};

// POST
export const changePassword = async (req: RequestUser, res: Response) => {
    const { currentPassword, newPassword } = req.body
    if (currentPassword && newPassword && req.user) {
        await authService.changePassword(currentPassword, newPassword, req.user.id)
    }
    res.status(200).json({
        success: true,
        message: "Şifre değiştirme başarılı."
    })
};

// GET
export const getMe = async (req: any, res: Response) => {
    const user = await authService.getUser(req.user.id);
    res.status(200).json({
        success: true,
        user: user
    })
};

// POST
export const logout = async (req: Request, res: Response) => {
    const refreshToken = req.body.refreshToken
    if (refreshToken) {
        await authService.logout(refreshToken)
    }
    res.status(200).json({ success: true, message: "Çıkış yapıldı" })
};

// POST
export const refreshToken = async (req: Request, res: Response) => {
    const currentRefreshToken = req.body.refreshToken
    const tokens = await refreshTokenService.refreshToken(currentRefreshToken)
    res.status(200).json({
        success: true,
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken
    })
};

// GET
export const getUsers = async (req: Request, res: Response) => {
    // Tüm kullanıcıları getir işlemleri
};
