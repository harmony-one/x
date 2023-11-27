import axios from 'axios'
import jwt from 'jsonwebtoken'
import fs from 'fs'
import { AppleKeySettings } from '../config/index.js'
import { v4 as uuid } from 'uuid'
import { hexView, stringToBytes } from '../utils.js'
import { hash as sha256 } from 'fast-sha256'
const base = axios.create({ timeout: 10000 })

const applePrivateKey = fs.readFileSync(AppleKeySettings.path, { encoding: 'utf-8' })

const jwtHeader = { kid: AppleKeySettings.kid, alg: 'ES256' }

const makeJwtPayload = (): Record<string, any> => {
  return {
    iss: AppleKeySettings.iss,
    iat: Math.floor(Date.now() / 1000)
  }
}

export interface CheckBit {
  bit0: boolean
  bit1: boolean
}

export async function deviceCheck (token: string, checkBits?: CheckBit, updateBits?: CheckBit): Promise<boolean> {
  const jwtToken = jwt.sign(makeJwtPayload(), applePrivateKey, { algorithm: 'ES256', header: jwtHeader })
  const body = {
    device_token: token,
    transaction_id: uuid(),
    timestamp: Date.now()
  }
  const deviceTokenHash = hexView(sha256(stringToBytes(token)))
  try {
    const { data: r } = await base.post('https://api.development.devicecheck.apple.com/v1/validate_device_token', body, { headers: { Authorization: `Bearer ${jwtToken}` } })
    console.log(`[deviceCheck] succeeded for token hash ${deviceTokenHash}`, r)
    return true
    // const { bit0, bit1, last_update_time: lastUpdateTime } = r
  } catch (ex) {
    console.error(`[deviceCheck] failed for token hash ${deviceTokenHash}`, ex)
    return false
  }
  // TODO: we will make use of the two bits later, e.g. when we give free credits to devices
}
