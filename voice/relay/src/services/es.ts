import config from '../config/index.js'
import { Client } from '@elastic/elasticsearch'
import { type WriteResponseBase } from '@elastic/elasticsearch/lib/api/types.js'

let client: Client | null = null

export const Index = config.es.index ?? 'bot-logs'

export interface TokenUsageLogData {
  vendor: string
  endpoint: string
  requestSize: number
  responseSize: number
  responseTokens: number
  token: string
  totalResponseTime: string // from bigint
  firstResponseTime: string
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
    console.log('[ES]', props)
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
