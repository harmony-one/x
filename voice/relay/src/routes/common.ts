import rateLimit, { type Options as RLOptions, type RateLimitRequestHandler } from 'express-rate-limit'
import { type NextFunction, type Request, type Response } from 'express'
import { HttpStatusCode } from 'axios'
import { hexView, stringToBytes } from '../utils.js'
import { hash as sha256 } from 'fast-sha256'
import { BlockedDeviceIds, BlockedIps } from '../config/index.js'

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

export const validateDeviceToken = (req: Request, res: Response, next: NextFunction): any => {
  if (!req.deviceToken || !req.deviceTokenHash) {
    res.status(HttpStatusCode.Forbidden).json({ error: 'device unsupported', code: 100 })
    return
  }
  if (BlockedDeviceIds.includes(req.deviceTokenHash)) {
    res.status(HttpStatusCode.Forbidden).json({ error: 'device banned', code: 101 })
    return
  }
  // TODO: validate the device token, https://developer.apple.com/documentation/devicecheck/accessing_and_modifying_per-device_data
  // Python example: https://blog.restlesslabs.com/john/ios-device-check
  next()
}
