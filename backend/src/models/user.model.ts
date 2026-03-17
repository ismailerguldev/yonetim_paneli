import type { Request } from "express";

export interface User {
    id: string;
    firstName: string;
    lastName: string;
    email: string;
    passwordHash: string;
    phone: string;
}
export interface RegisterUser {
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    phone: string;
}
export interface RequestUser extends Request {
    user?: {
        id: string,
    }
}