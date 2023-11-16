import { Router } from 'express'
import config from '../config/index.js'
import {checkIpBan, ipLimiter} from './soft.js';
import {HttpStatusCode} from 'axios';

const router: Router = Router()

router.post('/', checkIpBan, ipLimiter(), (req, res) => {
  const { username = '' } = req.body

  if (!username) {
    res.status(HttpStatusCode.BadRequest).json({ error: 'The request should include the username.' })
    return
  }

  if (!config.whitelist.includes(username)) {
    res.status(HttpStatusCode.Forbidden).json({ error: 'The user with such a username is not present in the whitelist.' })
    return
  }

  res.json({ status: true })
})

export default router
