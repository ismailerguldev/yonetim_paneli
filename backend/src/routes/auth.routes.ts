import { Router } from "express";
import {
    register,
    login,
    forgotPassword,
    checkPhone,
    updateProfile,
    changePassword,
    getMe,
    logout,
    refreshToken,
    getUsers,
    resetPassword,
} from "../controllers/auth.controller.js";
import { validationMiddleware } from "../middlewares/validation.middleware.js";
import { changePasswordSchema, loginSchema, registerSchema } from "../validation/form.validation.js";
import { authMiddleware } from "../middlewares/auth.middleware.js";

const route = Router();

route.post("/register", validationMiddleware(registerSchema), register);
route.post("/login", validationMiddleware(loginSchema), login);
route.post("/forgot-password", forgotPassword);
route.post("/reset-password", resetPassword);
route.post("/check-phone", checkPhone);
route.put("/update-profile", updateProfile);
route.post("/change-password", authMiddleware, validationMiddleware(changePasswordSchema), changePassword);
route.get("/me", authMiddleware, getMe);
route.post("/logout", logout);
route.post("/refresh", refreshToken);
route.get("/users", getUsers);

export default route;