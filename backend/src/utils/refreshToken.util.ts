import crypto from "crypto"
import { v4 as uuid } from "uuid"
export const createRefreshToken = (expires: Date) => {
    return {
        tokenId: uuid(),
        token: crypto.randomBytes(64).toString('hex'),
        expires: expires
    }
}
