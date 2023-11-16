import { Router, type Request, type Response, type NextFunction } from 'express'
import NodeCache from 'node-cache'
import OpenAIRelay from '../services/openai.js'
import { HttpStatusCode } from 'axios'
import { validateAttestation } from '../services/app-attest.js'
// import config from '../config/index.js'
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
  const token = auth?.split('Token ')?.[1]
  if (!token || TokenCache.get<boolean>(token)) {
    res.status(HttpStatusCode.Unauthorized).json({ error: 'invalid token' })
    return
  }
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
    const token = Buffer.from(crypto.getRandomValues(new Uint8Array(16))).toString('hex')
    TokenCache.set(token, true)
    res.json({ token })
  } catch (ex: any) {
    console.error(ex)
    res.status(HttpStatusCode.InternalServerError).json({ error: 'error processing attestation' })
  }
})

// NOTE: see discussions here regarding throwing error in the middle of a stream response
// https://github.com/expressjs/express/issues/2700
router.post('/openai/completion', authenticated, async (req, res, next) => {
  try {
    if (!req.body.stream) {
      const completion = await OpenAIRelay.completion(req.body)
      res.json(completion)
    }
    await OpenAIRelay.completionStream(req.body, (data) => {
      res.write(`data:\n${JSON.stringify(data)}`)
    })
    res.write('data:\n[DONE]')
    res.end()
  } catch (ex) {
    next(ex)
  }
})

export default router
