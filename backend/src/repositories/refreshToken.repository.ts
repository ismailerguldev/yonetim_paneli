import type { ResultSetHeader, RowDataPacket } from "mysql2";
import connection from "../config/mysql.config.js";
interface RefreshToken extends RowDataPacket {
    token: string
    user_id: string
    token_id: string
    expires_at: Date
    is_revoked: number
    created_at: Date
}
interface UserData extends RowDataPacket {
    user_id: string
}
export const insertNewRefreshToken = async (id: string, user_id: string, refreshToken: string, expires_at: Date) => {
    const query = "INSERT INTO refresh_tokens (id, user_id, token, expires_at) VALUES (UUID_TO_BIN(?), UUID_TO_BIN(?), ?, ?)";
    try {
        const [result] = await connection.execute<ResultSetHeader>(query, [id, user_id, refreshToken, expires_at])
        return result.affectedRows === 1
    } catch (error) {
        throw error
    }
}
export const getRefreshToken = async (curRefToken: string) => {
    const query = "SELECT BIN_TO_UUID(id) AS token_id, BIN_TO_UUID(user_id) AS user_id, token, expires_at, created_at, is_revoked FROM refresh_tokens WHERE token = ? LIMIT 1";
    try {
        const [result] = await connection.execute<RefreshToken[]>(query, [curRefToken])
        return result[0]
    } catch (error) {
        throw error
    }
}
export const revokeRefreshToken = async (tokenId: string) => {
    const query = "UPDATE refresh_tokens SET is_revoked = 1 WHERE id = UUID_TO_BIN(?) AND is_revoked = 0";
    try {
        const [result] = await connection.execute<ResultSetHeader>(query, [tokenId])
        return result?.affectedRows === 1
    } catch (error) {
        throw error
    }
}
export const revokeAllRefreshTokens = async (userId: string) => {
    const query = "UPDATE refresh_tokens SET is_revoked = 1 WHERE user_id = UUID_TO_BIN(?) AND is_revoked = 0";
    try {
        const [result] = await connection.execute<ResultSetHeader[]>(query, [userId])
        return true
    } catch (error) {
        throw error
    }
}
export const getUserForRefToken = async (userId: string) => {
    const query = "SELECT BIN_TO_UUID(id) AS user_id FROM users WHERE id = UUID_TO_BIN(?) AND is_active = 1 LIMIT 1";
    try {
        const [result] = await connection.execute<UserData[]>(query, [userId])
        return result[0]
    } catch (error) {
        throw error
    }
}