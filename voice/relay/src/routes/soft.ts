import { Router, type Request, type Response, type NextFunction } from 'express'
import { HttpStatusCode } from 'axios'
import rateLimit, { type Options as RLOptions, type RateLimitRequestHandler } from 'express-rate-limit'
import { BlockedDeviceIds, BlockedIps, OpenAIDistributedKeys } from '../config/index.js'
import { encrypt, hexString, hexView, stringToBytes } from '../utils.js'
import { hash as sha256 } from 'fast-sha256'
const router: Router = Router()

const deviceLimiter = (args?: RLOptions): RateLimitRequestHandler => rateLimit({
  windowMs: 1000 * 60,
  limit: 10,
  keyGenerator: req => req.header('x-device-token') ?? '',
  ...args
})

// eslint-disable-next-line @typescript-eslint/explicit-function-return-type
const ipLimiter = (args?: RLOptions): RateLimitRequestHandler => rateLimit({
  windowMs: 1000 * 60,
  limit: 10,
  keyGenerator: req => req.clientIp ?? 'N/A',
  ...args
})

const parseDeviceToken = (req: Request, res: Response, next: NextFunction): any => {
  const deviceToken = req.header('x-device-token')
  if (!deviceToken) {
    res.status(HttpStatusCode.Forbidden).json({ error: 'device unsupported', code: 100 })
    return
  }
  const deviceTokenHash = hexView(sha256(stringToBytes(deviceToken)))
  if (BlockedDeviceIds.includes(deviceTokenHash)) {
    res.status(HttpStatusCode.Forbidden).json({ error: 'device banned', code: 101 })
    return
  }
  req.deviceToken = deviceToken
  req.deviceTokenHash = deviceTokenHash
  next()
}

const checkIpBan = (req: Request, res: Response, next: NextFunction): any => {
  if (!req.clientIp) {
    console.error('[checkIpBan] Cannot find ip of request', req)
  }
  if (BlockedIps.includes(req.clientIp ?? 'N/A')) {
    res.status(HttpStatusCode.Forbidden).json({ error: 'ip banned', code: 102 })
  }
  next()
}

router.get('/health', (req, res) => {
  res.send('OK')
})

router.get('/key', parseDeviceToken, checkIpBan, deviceLimiter(), ipLimiter(), (req, res) => {
  // TODO: validate the device token, https://developer.apple.com/documentation/devicecheck/accessing_and_modifying_per-device_data
  const numKeys = BigInt(OpenAIDistributedKeys.length)
  const keyIndex = Number(BigInt('0x' + req.deviceTokenHash) % numKeys)
  const key = OpenAIDistributedKeys[keyIndex]
  const encryptedKey = encrypt(key)
  const encoded = encryptedKey.toString('base64')

  console.log(`[deviceTokenHash=${req.deviceTokenHash}][ip=${req.clientIp}] Provided encryptedKey ${encoded}`)
  res.json({ key: encryptedKey.toString('base64') })
})

export default router
