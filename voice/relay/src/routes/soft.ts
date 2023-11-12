import { Router, type Request, type Response, type NextFunction } from 'express'
import NodeCache from 'node-cache'
import OpenAIRelay from '../services/openai.js'
import { HttpStatusCode } from 'axios'
import rateLimit from 'express-rate-limit'

const router: Router = Router()


// eslint-disable-next-line @typescript-eslint/explicit-function-return-type
const limiter = (args?: any) => rateLimit({
    windowMs: 1000 * 60,
    max: 60,
    keyGenerator: req => req.fingerprint?.hash ?? '',
    ...args
})



router.get('/health', (req, res) => {
    res.send('OK')
})

router.get('/key', limiter(), (req,res) =>{
    
})

export default router