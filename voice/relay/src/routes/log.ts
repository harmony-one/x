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
    requestNumMessages,
    requestNumUserMessages,
    requestMessage,
    responseMessage,
    cancelled,
    completed,
    error,

    sstFinalizationTime,
    requestPreparationTime,
    firstResponseTime,
    ttsPreparationTime,
    firstUtteranceTime,

    totalTtsTime,
    totalClickToSpeechTime,
    totalResponseTime

  } = req.body
  if (!vendor || !endpoint) {
    return res.status(HttpStatusCode.BadRequest).json({ error: 'missing mandatory fields', endpoint, vendor })
  }

  totalResponseTime = totalResponseTime ?? '0'
  firstResponseTime = firstResponseTime ?? '0'

  if (!isBigInt(totalResponseTime) || !isBigInt(firstResponseTime)) {
    return res.status(HttpStatusCode.BadRequest).json({ error: 'bad response times', endpoint, vendor })
  }

  sstFinalizationTime = sstFinalizationTime ?? '0'
  requestPreparationTime = requestPreparationTime ?? '0'
  ttsPreparationTime = ttsPreparationTime ?? '0'
  firstUtteranceTime = firstUtteranceTime ?? '0'
  totalTtsTime = totalTtsTime ?? '0'
  totalClickToSpeechTime = totalClickToSpeechTime ?? '0'

  if (!isBigInt(sstFinalizationTime) || !isBigInt(requestPreparationTime) || !isBigInt(ttsPreparationTime) || !isBigInt(firstUtteranceTime) || !isBigInt(totalClickToSpeechTime) || !isBigInt(totalTtsTime)) {
    return res.status(HttpStatusCode.BadRequest).json({ error: 'bad client component times', endpoint, vendor })
  }

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
    requestNumMessages,
    requestNumUserMessages,
    requestMessage,
    responseMessage,
    cancelled,
    relayMode,
    completed,
    error,

    sstFinalizationTime,
    requestPreparationTime,
    firstResponseTime,
    ttsPreparationTime,
    firstUtteranceTime,

    totalTtsTime,
    totalClickToSpeechTime,
    totalResponseTime

  })
  res.json({ success: true })
}
