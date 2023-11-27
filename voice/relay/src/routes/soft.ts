import { Router } from 'express'
import { OpenAIDistributedKeys } from '../config/index.js'
import { encrypt } from '../utils.js'
import { log } from './log.js'
import { parseDeviceToken, validateDeviceToken, checkIpBan, deviceLimiter, ipLimiter } from './common.js'
import { HttpStatusCode } from 'axios'
const router: Router = Router()

router.get('/health', (req, res) => {
  res.send('OK')
})

router.get('/key', parseDeviceToken, validateDeviceToken, checkIpBan, deviceLimiter(), ipLimiter(), (req, res) => {
  const numKeys = BigInt(OpenAIDistributedKeys.length)
  const keyIndex = Number(BigInt('0x' + (req.deviceTokenHash ?? '')) % numKeys)
  const key = OpenAIDistributedKeys[keyIndex]
  const encryptedKey = encrypt(key)
  const encoded = encryptedKey.toString('base64')

  console.log(`[deviceTokenHash=${req.deviceTokenHash}][ip=${req.clientIp}] Provided encryptedKey ${encoded}`)
  res.json({ key: encryptedKey.toString('base64') })
})

router.post('/log', parseDeviceToken, validateDeviceToken, checkIpBan, deviceLimiter({ limit: 60 }), ipLimiter({ limit: 60 }), async (req, res) => {
  try {
    await log(req, res, 'soft')
  } catch (ex: any) {
    console.error(ex)
    res.status(HttpStatusCode.InternalServerError).json({ error: 'internal error' })
  }
})

export default router
