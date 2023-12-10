import config from '../config/index.js'
import { Client } from '@elastic/elasticsearch'
import { type WriteResponseBase } from '@elastic/elasticsearch/lib/api/types.js'

let client: Client | null = null

export const Index = config.es.index ?? 'bot-token-usage'
export const ClientUsageIndex = config.es.clientUsageIndex ?? 'bot-client-usage'

export interface TokenUsageLogData {
  vendor: string
  endpoint: string
  requestSize: number
  responseSize: number
  responseTokens: number
  attestationHash: string
  totalResponseTime: string // from bigint
  firstResponseTime: string // from bigint
}

export interface ClientUsageLogData {
  vendor: string
  endpoint: string
  relayMode: string
  deviceTokenHash: string
  requestTokens: number
  responseTokens: number
  requestNumMessages: number
  requestNumUserMessages: number
  requestMessage?: string
  responseMessage?: string

  cancelled: boolean
  completed: boolean
  error: string

  sstFinalizationTime: string // from bigint
  requestPreparationTime: string // from bigint
  firstResponseTime: string // from bigint
  ttsPreparationTime: string // from bigint
  firstUtteranceTime: string // from bigint

  totalTtsTime: string // from bigint
  totalClickToSpeechTime: string // from bigint
  totalResponseTime: string // from bigint

}

export const ES = {
  init: (): Client | null => {
    if (!config.es.url) {
      console.log('Skipped initializing ES')
      return null
    }
    client = new Client({
      node: config.es.url,
      auth: { username: config.es.username, password: config.es.password },
      tls: { rejectUnauthorized: false }
    })
    return client
  },
  add: async ({ index = Index, ...props }: TokenUsageLogData & { index?: string }): Promise<undefined | WriteResponseBase> => {
    if (!client) {
      return
    }
    console.log('[ES][add]', props)
    // return
    return await client.index({
      index,
      document: {
        time: Date.now(),
        ...props
      }
    })
  },
  addClientReportedData: async ({ index = ClientUsageIndex, ...props }: ClientUsageLogData & { index?: string }): Promise<undefined | WriteResponseBase> => {
    if (!client) {
      return
    }
    console.log('[ES][addClientReportedData]', props)
    // return
    return await client.index({
      index,
      document: {
        time: Date.now(),
        ...props
      }
    })
  },
  client: (): Client | null => client
}
