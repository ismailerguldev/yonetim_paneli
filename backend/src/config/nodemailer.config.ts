import nodemailer, { type SendMailOptions } from "nodemailer";
const transporter = nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 465,
    secure: true,
    auth: {
        user: process.env.NODEMAILER_MAIL as string,
        pass: process.env.NODEMAILER_PASS as string
    }
})
export const sendMail = async (data: { toMail: string, code: string }) => {
    const mailOptions: SendMailOptions = {
        from: process.env.NODEMAILER_MAIL as string,
        to: data.toMail,
        subject: "Yönetim Paneli Parola Sıfırlama Kodu",
        html: `<div style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7ff; padding: 40px; text-align: center;">
    <div style="max-width: 500px; margin: 0 auto; background-color: #ffffff; border-radius: 12px; padding: 30px; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
        <h2 style="color: #333; margin-bottom: 10px;">Parola Sıfırlama</h2>
        <p style="color: #666; font-size: 16px; line-height: 1.5;">Yönetim paneline giriş yapabilmek için geçici onay kodunuz aşağıdadır. Lütfen bu kodu kimseyle paylaşmayın.</p>
        
        <div style="margin: 30px 0;">
            <span style="display: inline-block; background-color: #4f46e5; color: #ffffff; font-size: 32px; font-weight: bold; letter-spacing: 8px; padding: 15px 30px; border-radius: 8px; border: 1px solid #3730a3;">
                ${data.code}
            </span>
        </div>

        <p style="color: #999; font-size: 12px; margin-top: 30px;">
            Eğer bu talebi siz yapmadıysanız, bu e-postayı güvenle göz ardı edebilirsiniz. <br>
            Bu kod 15 dakika boyunca geçerlidir.
        </p>
    </div>
</div>`
    }
    try {
        const info = await transporter.sendMail(mailOptions);
        return info
    } catch (e) {
        throw e
    }
}