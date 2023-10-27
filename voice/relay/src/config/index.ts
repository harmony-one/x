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
  packageName: process.env.PACKAGE_NAME ?? '',
  openai: { key: process.env.OPENAI_KEY ?? '' },
  deepgram: { key: process.env.DEEPGRAM_KEY ?? '' },
  playht: { key: process.env.PLAYHT_KEY ?? '' },
}

export default config
