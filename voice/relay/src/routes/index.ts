import { Router, type Request, type Response, type NextFunction } from 'express'
import NodeCache from 'node-cache'
import OpenAI from '../services/openai.js'
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
  const isValid = validateAttestation(inputKeyId, challenge, attestation)
  if (!isValid) {
    res.status(HttpStatusCode.Forbidden).json({ error: 'attestation validation failed' })
    return
  }
  const token = Buffer.from(crypto.getRandomValues(new Uint8Array(16))).toString('hex')
  TokenCache.set(token, true)
  res.json({ token })
})

router.post('/openai', authenticated, async (req, res) => {
  // TODO
  let completed = false
  OpenAI.completion((data, error) => {
    if (error) {
      res.send('error:\n' + JSON.stringify({ error: error.toString() }))
      completed = true
    }
    if (!completed) {
      res.write(data)
    }
  }, () => {
    res.end()
  })
})

export default router
