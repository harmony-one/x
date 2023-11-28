import rateLimit, { type Options as RLOptions, type RateLimitRequestHandler } from 'express-rate-limit'
import { type NextFunction, type Request, type Response } from 'express'
import { HttpStatusCode } from 'axios'
import { hexView, stringToBytes } from '../utils.js'
import { hash as sha256 } from 'fast-sha256'
import { BlockedDeviceIds, BlockedIps } from '../config/index.js'
import { deviceCheck } from '../services/device-check.js'
import NodeCache from 'node-cache'
const DeviceTokenCache = new NodeCache({ stdTTL: 0 })

export const deviceLimiter = (args?: Partial<RLOptions>): RateLimitRequestHandler => rateLimit({
  windowMs: 1000 * 60,
  limit: 10,
  keyGenerator: req => req.header('x-device-token') ?? '',
  ...args
})

// eslint-disable-next-line @typescript-eslint/explicit-function-return-type
export const ipLimiter = (args?: Partial<RLOptions>): RateLimitRequestHandler => rateLimit({
  windowMs: 1000 * 60,
  limit: 10,
  keyGenerator: req => req.clientIp ?? 'N/A',
  ...args
})

export const parseDeviceToken = (req: Request, res: Response, next: NextFunction): any => {
  const deviceToken = req.header('x-device-token')
  if (!deviceToken) {
    res.status(HttpStatusCode.Forbidden).json({ error: 'device unsupported', code: 100 })
    return
  }
  const deviceTokenHash = hexView(sha256(stringToBytes(deviceToken)))
  req.deviceToken = deviceToken
  req.deviceTokenHash = deviceTokenHash
  next()
}

export const checkIpBan = (req: Request, res: Response, next: NextFunction): any => {
  if (!req.clientIp) {
    console.error('[checkIpBan] Cannot find ip of request', req)
  }
  if (BlockedIps.includes(req.clientIp ?? 'N/A')) {
    res.status(HttpStatusCode.Forbidden).json({ error: 'ip banned', code: 102 })
  }
  next()
}

export const validateDeviceToken = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  if (!req.deviceToken || !req.deviceTokenHash) {
    res.status(HttpStatusCode.Forbidden).json({ error: 'device unsupported', code: 100 })
    return
  }
  if (BlockedDeviceIds.includes(req.deviceTokenHash)) {
    res.status(HttpStatusCode.Forbidden).json({ error: 'device banned', code: 101 })
    return
  }
  let validDevice = DeviceTokenCache.get<boolean>(req.deviceTokenHash)
  if (validDevice) {
    console.log(`[validateDeviceToken] skipped validation for cached deviceTokenHash ${req.deviceTokenHash}`)
    next()
    return
  }
  validDevice = await deviceCheck(req.deviceToken)
  if (!validDevice) {
    res.status(HttpStatusCode.Forbidden).json({ error: 'invalid device', code: 103 })
    return
  }
  DeviceTokenCache.set(req.deviceTokenHash, true)
  next()
}
