import * as dotenv from 'dotenv'
dotenv.config()

const DEBUG = process.env.DEBUG === 'true' || process.env.DEBUG === '1'
const config = {
  debug: DEBUG,
  verbose: process.env.VERBOSE === 'true' || process.env.VERBOSE === '1',
  https: {
    only: process.env.HTTPS_ONLY === 'true' || process.env.HTTPS_ONLY === '1',
    key: DEBUG ? './certs/test.key' : './certs/privkey.pem',
    cert: DEBUG ? './certs/test.cert' : './certs/fullchain.pem'
  },
  corsOrigins: process.env.CORS ?? '',
  teamId: process.env.TEAM_ID ?? '',
  tokenSeed: process.env.TOKEN_SEED ?? '',
  allowDevelopAttestation: process.env.ALLOW_DEVELOP_ATTESTATION === 'true' || process.env.ALLOW_DEVELOP_ATTESTATION === '1',
  packageName: process.env.PACKAGE_NAME ?? '',
  openai: { key: process.env.OPENAI_KEY ?? '' },
  deepgram: { key: process.env.DEEPGRAM_KEY ?? '' },
  playht: { key: process.env.PLAYHT_KEY ?? '' },
  whitelist: (process.env.WHITELIST ?? '')
    .split(',')
    .map((item) => item.toString().toLowerCase()),
  es: {
    url: process.env.ES_URL ?? '',
    username: process.env.ES_USERNAME ?? '',
    password: process.env.ES_PASSWORD ?? '',
    index: process.env.ES_INDEX
  }
}

export const OpenAIDistributedKeys: string[] = JSON.parse(process.env.OPENAI_DISTRIBUTED_KEYS ?? '[]')
export const BlockedDeviceIds: string[] = JSON.parse(process.env.BLOCKED_DEVICE_IDS ?? '[]')
export const BlockedIps: string[] = JSON.parse(process.env.BLOCKED_IPS ?? '[]')

export const SharedEncryptionSecret: string = process.env.SHARED_ENCRYPTION_SECRET ?? ''
export const SharedEncryptionIV: string = process.env.SHARED_ENCRYPTION_IV ?? ''
export const BannedTokens: string[] = JSON.parse(process.env.BANNED_TOKENS ?? '[]').map((e: string) => e.toLowerCase())

export default config
