import { type Request, type Response } from 'express'
import { HttpStatusCode } from 'axios'
import { ES } from '../services/es.js'
import { isBigInt } from '../utils.js'

export async function log (req: Request, res: Response, relayMode: string): Promise<any> {
  let {
    vendor,
    endpoint,
    requestTokens,
    responseTokens,
    totalResponseTime,
    firstResponseTime,
    requestNumMessages,
    requestNumUserMessages,
    requestMessage,
    responseMessage,
    cancelled,
    completed,
    sttEndTime,
    appSendTime,
    ttsInitTime,
    ttsFirstTime,
    clickToSpeechTotalTime,
    error
  } = req.body
  if (!vendor || !endpoint) {
    return res.status(HttpStatusCode.BadRequest).json({ error: 'missing mandatory fields', endpoint, vendor })
  }
  totalResponseTime = totalResponseTime ?? '0'
  firstResponseTime = firstResponseTime ?? '0'
  if (!isBigInt(totalResponseTime) || !isBigInt(firstResponseTime)) {
    return res.status(HttpStatusCode.BadRequest).json({ error: 'bad times', endpoint, vendor })
  }

  if (!isBigInt(sttEndTime) || !isBigInt(appSendTime) || !isBigInt(ttsInitTime) || !isBigInt(ttsFirstTime) || !isBigInt(clickToSpeechTotalTime)) {
    return res.status(HttpStatusCode.BadRequest).json({ error: 'bad stt times', endpoint, vendor })
  }

  sttEndTime = sttEndTime ?? '0'
  appSendTime = appSendTime ?? '0'
  ttsInitTime = ttsInitTime ?? '0'
  ttsFirstTime = ttsFirstTime ?? '0'
  clickToSpeechTotalTime = clickToSpeechTotalTime ?? '0'

  requestTokens = Number(requestTokens ?? '0')
  responseTokens = Number(responseTokens ?? '0')
  requestNumMessages = Number(requestNumMessages ?? '0')
  requestNumUserMessages = Number(requestNumUserMessages ?? '0')
  requestMessage = String(requestMessage ?? '')
  responseMessage = String(responseMessage ?? '')
  cancelled = (cancelled === true || cancelled === 'true' || cancelled === '1')
  completed = (completed === true || completed === 'true' || completed === '1')
  error = String(error ?? '')

  await ES.addClientReportedData({
    deviceTokenHash: req.deviceTokenHash ?? 'N/A',
    vendor,
    endpoint,
    requestTokens,
    responseTokens,
    totalResponseTime,
    firstResponseTime,
    requestNumMessages,
    requestNumUserMessages,
    requestMessage,
    responseMessage,
    cancelled,
    relayMode,
    completed,
    sttEndTime,
    appSendTime,
    ttsInitTime,
    ttsFirstTime,
    clickToSpeechTotalTime,
    error
  })
  res.json({ success: true })
}
