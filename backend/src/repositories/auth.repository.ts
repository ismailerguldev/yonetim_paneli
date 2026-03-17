import connection from "../config/mysql.config.js";
import { ConflictError } from "../models/error.model.js";
import type { User } from "../models/user.model.js";
import type { ResultSetHeader, RowDataPacket, QueryError } from "mysql2";

interface GetUserByEmail extends RowDataPacket {
    user_id: string,
    hashedPassword: string,
}
interface GetUserById extends RowDataPacket {
    firstName: string
    lastName: string
    email: string
    phone: string
}
interface GetHashedPasswordByUserId extends RowDataPacket {
    hashedPassword: string
}
interface GetCurrentToken extends RowDataPacket {
    expires_at: Date
    email: string
}
const findExistUser = async (email: string): Promise<boolean> => {
    const query = "SELECT 1 FROM users WHERE email = ? LIMIT 1";
    const [rows] = await connection.execute<RowDataPacket[]>(query, [email]);
    return rows.length > 0
}
const insertNewUser = async (userData: User) => {
    const query = "INSERT INTO users (id, first_name, last_name, email, password_hash  , phone) VALUES (UUID_TO_BIN(?),?,?,?,?,?)";
    try {
        const [result] = await connection.execute<ResultSetHeader>(query,
            [userData.id, userData.firstName, userData.lastName, userData.email, userData.passwordHash, userData.phone]);
        return result.affectedRows === 1;
    } catch (error) {
        throw error
    }

}
const getUserByEmail = async (email: string) => {
    const query = "SELECT BIN_TO_UUID(id) AS user_id, password_hash as hashedPassword FROM users WHERE email = ? LIMIT 1";
    try {
        const [rows] = await connection.execute<GetUserByEmail[]>(query, [email]);
        return rows.length > 0 ? rows[0] : null
    } catch (error) {
        throw error
    }
}
const getHashedPasswordByUserId = async (userId: string) => {
    const query = "SELECT password_hash AS hashedPassword FROM users WHERE id = UUID_TO_BIN(?) LIMIT 1";
    try {
        const [result] = await connection.execute<GetHashedPasswordByUserId[]>(query, [userId])
        return result.length > 0 ? result[0]?.hashedPassword : null
    } catch (error) {
        throw error
    }
}
const changeUserPassword = async (userId: string, passwordHash: string) => {
    const query = "UPDATE users SET password_hash = ? WHERE id = UUID_TO_BIN(?) AND is_active = 1";
    try {
        const [result] = await connection.execute<ResultSetHeader[]>(query, [passwordHash, userId])
        return result[0]?.affectedRows === 1
    } catch (err) {
        throw err
    }
}
const addToResetPassword = async (email: string, code: string) => {
    const query = "REPLACE INTO password_resets (email,code) VALUES (?,?)"
    try {
        const [result] = await connection.execute<ResultSetHeader>(query, [
            email, code
        ])
        return result.affectedRows > 0;
    } catch (error) {
        throw error
    }
}
const getCode = async (code: string, email: string) => {
    const query = "SELECT expires_at, email FROM password_resets WHERE code = ? AND email = ?"
    try {
        const [result] = await connection.execute<GetCurrentToken[]>(query, [code, email]);
        return result.length > 0 ? result[0] : null
    } catch (error) {
        throw error
    }
}
const setNewPassword = async (newPassword: string, email: string) => {
    const query = "UPDATE users SET password_hash = ? WHERE email = ?"
    const query2 = "DELETE FROM password_resets WHERE email = ?"
    try {
        const [result] = await connection.execute<ResultSetHeader>(query, [newPassword, email])
        await connection.execute<ResultSetHeader>(query2, [email])
        return result?.affectedRows === 1
    } catch (error) {
        throw error
    }
}
const getUserById = async (id: string) => {
    const query = "SELECT first_name as firstName, last_name as lastName, email, phone FROM users WHERE id = UUID_TO_BIN(?) AND is_active = 1";
    try {
        const [result] = await connection.execute<GetUserById[]>(query, [id]);
        if (result.length > 0 && result[0]) {
            return {
                firstName: result[0].firstName,
                lastName: result[0].lastName,
                email: result[0].email,
                phone: result[0].phone
            }
        }
    } catch (error) {
        throw error
    }
}
export default {
    findExistUser,
    insertNewUser,
    getUserByEmail,
    getHashedPasswordByUserId,
    changeUserPassword,
    addToResetPassword,
    getCode,
    setNewPassword,
    getUserById
}