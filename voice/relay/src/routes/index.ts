import { Router } from 'express'
import { RelaySetting } from '../config/index.js'

const router: Router = Router()

router.get('/mode', (req, res) => {
  res.json({ mode: RelaySetting.mode, openaiBaseUrl: RelaySetting.openaiBaseUrl })
})

router.get('/health', (req, res) => {
  res.send('OK')
})

export default router
