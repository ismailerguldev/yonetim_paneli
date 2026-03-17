import { UnauthorizedError } from "../models/error.model.js"
import { getRefreshToken, getUserForRefToken, insertNewRefreshToken, revokeRefreshToken } from "../repositories/refreshToken.repository.js"
import { createAccessToken } from "../utils/jwt.util.js"
import { createRefreshToken } from "../utils/refreshToken.util.js"
const refreshToken = async (refreshToken: string) => {
    if (!refreshToken) throw new UnauthorizedError("Token geçersiz 1 ");
    const currentRefreshToken = await getRefreshToken(refreshToken)
    if (!currentRefreshToken || currentRefreshToken.is_revoked === 1 || currentRefreshToken.expires_at < new Date()) throw new UnauthorizedError("Token geçersiz");
    const isRevokeSuccess = await revokeRefreshToken(currentRefreshToken.token_id)
    if (!isRevokeSuccess) throw new UnauthorizedError("Token geçersiz 2");
    const newRefreshToken = createRefreshToken(new Date(Date.now() + currentRefreshToken.expires_at.getTime() - currentRefreshToken.created_at.getTime()))
    const inserted = await insertNewRefreshToken(newRefreshToken.tokenId, currentRefreshToken.user_id, newRefreshToken.token, newRefreshToken.expires)
    if (!inserted) throw new UnauthorizedError("Token geçersiz 3");
    const userData = await getUserForRefToken(currentRefreshToken.user_id)
    if (!userData) throw new UnauthorizedError("Kullanıcı bulunamadı.");
    const newAccessToken = createAccessToken({ sub: userData.user_id })
    return {
        refreshToken: {
            token: newRefreshToken.token,
            expires: newRefreshToken.expires,
        },
        accessToken: newAccessToken
    }
}
export default { refreshToken }