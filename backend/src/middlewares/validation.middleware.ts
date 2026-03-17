import { z } from "zod";
import { ValidationError } from "../models/error.model.js";
import type { NextFunction, Request, Response } from "express";

export const validationMiddleware = (schema: z.ZodSchema) => {
    return (req: Request, res: Response, next: NextFunction) => {
        const result = schema.safeParse(req.body);        
        if (!result.success) {
            const errorString = z.prettifyError(result.error);
            throw new ValidationError(errorString);
        }
        req.body = result.data;
        next();
    }
};
