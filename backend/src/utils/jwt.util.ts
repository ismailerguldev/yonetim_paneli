import jwt from "jsonwebtoken";
export const createAccessToken = (userData: { sub: string, }) => {
    const accessToken = jwt.sign(userData, process.env.JWT_ACCESS_TOKEN_SECRET as string, {
        expiresIn: "30s"
    })
    return accessToken
}