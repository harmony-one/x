import { Router, type Request, type Response, type NextFunction } from 'express'
import NodeCache from 'node-cache'
import OpenAIRelay from '../services/openai.js'
import { HttpStatusCode } from 'axios'
import { validateAttestation } from '../services/app-attest.js'
import { hexView, now, stringToBytes } from '../utils.js'
import { hash as sha256 } from 'fast-sha256'
import config, { BannedTokens } from '../config/index.js'
import { ES } from '../services/es.js'
import { checkIpBan, deviceLimiter, ipLimiter, parseDeviceToken, validateDeviceToken } from './common.js'
import { log } from './log.js'
const ChallengeCache = new NodeCache({ stdTTL: 30 })
const TokenCache = new NodeCache({ stdTTL: 60 * 30 })

const router: Router = Router()

router.get('/health', (req, res) => {
  res.send('OK')
})

router.get('/challenge', (req, res) => {
  const challenge = Buffer.from(crypto.getRandomValues(new Uint8Array(16))).toString('hex')
  ChallengeCache.set(challenge, true)
  res.json({ challenge })
})

async function authenticated (req: Request, res: Response, next: NextFunction): Promise<void> {
  // TODO: if request contains attestation instead of token, allow to proceed as well
  const auth = req.header('authorization')
  const token = auth?.split('Bearer ')?.[1]
  if (!token) {
    res.status(HttpStatusCode.Unauthorized).json({ error: 'no token' })
    return
  }
  const attestationHash = TokenCache.get<string>(token)
  console.log(`[${req.clientIp}] received token for attestation hash: ${attestationHash}`)
  if (!attestationHash || BannedTokens.includes(attestationHash)) {
    console.log(`[${req.clientIp}] denied request for banned attestation hash ${attestationHash}`)
    res.status(HttpStatusCode.Unauthorized).json({ error: 'banned attestation' })
    return
  }
  req.attestationHash = attestationHash
  req.token = token
  next()
}

// respond a short-lived token
router.post('/attestation', async (req, res) => {
  const { inputKeyId, challenge, attestation } = req.body
  if (!inputKeyId || !challenge || !attestation) {
    res.status(HttpStatusCode.BadRequest).json({ error: 'missing body parameters', inputKeyId, challenge, attestation })
    return
  }
  try {
    const isValid = await validateAttestation(inputKeyId, challenge, attestation)
    if (!isValid) {
      res.status(HttpStatusCode.Forbidden).json({ error: 'attestation validation failed' })
      return
    }
    const nonce = Math.floor(Date.now() / (1000 * 1800)) * (1000 * 1800)
    // const token = Buffer.from(crypto.getRandomValues(new Uint8Array(16))).toString('hex')
    const attestationHash = hexView(sha256(stringToBytes(`${inputKeyId};${challenge};${attestation};${config.tokenSeed}`)))
    const token = hexView(sha256(new Uint8Array(
      Buffer.concat([Buffer.from(attestationHash, 'hex'), stringToBytes(nonce.toString())])
    )))
    TokenCache.set(token, attestationHash)
    res.json({ token })
  } catch (ex: any) {
    console.error(ex)
    res.status(HttpStatusCode.InternalServerError).json({ error: 'error processing attestation' })
  }
})

// NOTE: see discussions here regarding throwing error in the middle of a stream response
// https://github.com/expressjs/express/issues/2700
router.post('/openai/chat/completions', authenticated, async (req, res, next) => {
  let responseSize = 0
  let responseTokens = 0
  let firstResponseTime = 0n
  let totalResponseTime = 0n
  const startTime = now()
  try {
    if (!req.body.stream) {
      const completion = await OpenAIRelay.completion(req.body)
      firstResponseTime = now() - startTime
      responseTokens = Number(completion.usage?.completion_tokens)
      responseSize = JSON.stringify(completion).length
      res.json(completion)
    }
    await OpenAIRelay.completionStream(req.body, (data) => {
      const dataStr = JSON.stringify(data)
      responseSize += dataStr.length
      responseTokens += 1
      if (!firstResponseTime) {
        firstResponseTime = now() - startTime
      }
      res.write(`data:\n${dataStr}\n\n`)
    })
    totalResponseTime = now() - startTime
    res.write('data:\n[DONE]')
    res.end()
  } catch (ex) {
    if (!firstResponseTime) {
      firstResponseTime = now()
    }
    totalResponseTime = now() - startTime
    next(ex)
  } finally {
    ES.add({
      vendor: 'openai',
      attestationHash: req.attestationHash ?? '',
      requestSize: Number(req.headers['content-length']),
      responseSize,
      responseTokens,
      firstResponseTime: firstResponseTime.toString(),
      totalResponseTime: totalResponseTime.toString(),
      endpoint: 'chat/completions'
    }).catch(e => { console.error(e) })
  }
})

router.post('/log', parseDeviceToken, validateDeviceToken, checkIpBan, deviceLimiter({ limit: 60 }), ipLimiter({ limit: 60 }), async (req, res) => {
  try {
    await log(req, res, 'hard')
  } catch (ex: any) {
    console.error(ex)
    res.status(HttpStatusCode.InternalServerError).json({ error: 'internal error' })
  }
})

export default router
