import crypto from 'crypto'
import { SharedEncryptionIV, SharedEncryptionSecret } from './config/index.js'

export const hexView = (bytes: Buffer | Uint8Array): string => {
  return bytes && Array.from(bytes).map(x => x.toString(16).padStart(2, '0')).join('')
}

export const hexString = (bytes: Buffer | Uint8Array): string => {
  return '0x' + hexView(bytes)
}

export const stringToBytes = (str: string): Uint8Array => {
  return new TextEncoder().encode(str)
}

export function chunkstr (str: string, size: number): string[] {
  const numChunks = Math.ceil(str.length / size)
  const chunks = new Array(numChunks)

  for (let i = 0, o = 0; i < numChunks; ++i, o += size) {
    chunks[i] = str.substr(o, size)
  }

  return chunks
}

const aesKey = crypto
  .createHash('sha512')
  .update(SharedEncryptionSecret)
  .digest('hex')
  .substring(0, 32)
const aesIv = crypto
  .createHash('sha512')
  .update(SharedEncryptionIV)
  .digest('hex')
  .substring(0, 16)

export function encrypt (s: string): Buffer {
  const cipher = crypto.createCipheriv('aes-256-gcm', aesKey, aesIv)
  return Buffer.concat([cipher.update(s, 'utf8'), cipher.final()])
}
