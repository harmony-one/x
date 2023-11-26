import { Router } from 'express'
import { RelaySetting } from '../config/index.js'

const router: Router = Router()

router.get('/mode', (req, res) => {
  res.json({ mode: RelaySetting.mode, openaiBaseUrl: RelaySetting.openaiBaseUrl })
})

export default router
