import { z } from "zod";

export const registerSchema = z.object({
    firstName: z
        .string()
        .min(1, "İsim gerekli")
        .max(50, "İsim çok uzun")
        .transform((s) => s.trim()),
    lastName: z
        .string()
        .min(1, "Soyisim gerekli")
        .max(50, "Soyisim çok uzun")
        .transform((s) => s.trim()),
    email: z
        .email("Geçersiz e-posta adresi")
        .min(1, "E-posta gerekli")
        .transform((s) => s.trim().toLowerCase()),
    phone: z
        .string()
        .min(10, "Geçersiz telefon numarası")
        .max(16, "Geçersiz telefon numarası")
        .transform((s) => s.trim()),
    password: z
        .string()
        .min(8, "Şifre en az 8 karakter olmalı")
        .transform((s) => s.trim()),
    confirmPassword: z
        .string()
        .transform((s) => s.trim()),
}).refine((data) => data.password === data.confirmPassword, {
    message: "Şifreler eşleşmiyor",
})
export const loginSchema = z.object({
    email: z
        .email("Geçersiz e-posta adresi")
        .min(1, "E-posta gerekli")
        .transform((s) => s.trim().toLowerCase()),
    password: z
        .string()
        .min(8, "Şifre en az 8 karakter olmalı")
        .transform((s) => s.trim()),
    remember: z.boolean().optional(),
});
export const changePasswordSchema = z.object({
    currentPassword: z.string().min(8, "Şifre en az 8 karakter olmalı").transform((s) => s.trim()),
    newPassword: z.string().min(8, "Şifre en az 8 karakter olmalı").transform((s) => s.trim())
})

export type LoginForm = z.infer<typeof loginSchema>;
export type RegisterForm = z.infer<typeof registerSchema>;
export type ChangePasswordForm = z.infer<typeof changePasswordSchema>