import { ConflictError, UnauthorizedError } from "../models/error.model.js";
import type { RequestUser } from "../models/user.model.js";
import type { NextFunction, Request, Response } from "express";
import jwt, { type JwtPayload } from "jsonwebtoken"
interface AccessTokenPayload extends JwtPayload {
    sub: string,
}
export const authMiddleware = (req: RequestUser, res: Response, next: NextFunction) => {
    const header = req.headers.authorization
    if (!header || !header.startsWith("Bearer ")) throw new UnauthorizedError("Geçersiz token");
    const token = header.split(" ")[1]
    if (!token) {
        throw new UnauthorizedError("Geçersiz Token");
    }
    try {
        const decoded = jwt.verify(token, process.env.JWT_ACCESS_TOKEN_SECRET as string) as AccessTokenPayload
        req.user = {
            id: decoded.sub,
        }
        next()
    } catch (error) {
        throw new UnauthorizedError("Token geçersiz veya süresi dolmuş.")
    }
}