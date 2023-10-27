import express from 'express'
import cookieParser from 'cookie-parser'
import morgan from 'morgan'
import apiRouter from './routes/index.js'
import fs from 'fs'
import http, { type Server as HttpServer } from 'http'
import https from 'https'
import config from './config/index.js'
import cors from 'cors'

const app = express()
let httpServer: HttpServer

const httpsOptions = {
  key: fs.readFileSync(config.https.key, { encoding: 'utf-8' }),
  cert: fs.readFileSync(config.https.cert, { encoding: 'utf-8' })
}

if (config.https.only) {
  const httpApp = express()
  const httpRouter = express.Router()
  httpApp.use('*', httpRouter)
  httpRouter.get('*', function (req, res) {
    const hostPort = (req.get('host') ?? '').split(':')
    const url = hostPort.length === 2 ? `https://${hostPort[0]}:${process.env.HTTPS_PORT}${req.originalUrl}` : `https://${hostPort[0]}${req.originalUrl}`
    res.redirect(url)
  })
  httpServer = http.createServer(httpApp)
} else {
  httpServer = http.createServer(app)
}
const httpsServer = https.createServer(httpsOptions, app)

app.use(morgan('common'))
app.use(cookieParser())
app.enable('trust proxy')

app.use(cors({
  preflightContinue: true,
  credentials: true,
  origin: function (origin?: string, callback?: (err: Error | null, origin?: string) => void): void {
    if (config.corsOrigins !== '') {
      if (config.corsOrigins === '*' || config.corsOrigins.includes(origin ?? '*')) {
        callback?.(null, origin ?? '*')
      } else {
        callback?.(new Error('Origin not allowed'))
      }
    } else {
      callback?.(new Error('CORS not set'))
    }
  }
}))

app.use(express.urlencoded({ extended: true }))
app.use(express.json())

app.options('*', async (_req, res) => {
  res.end()
})

app.use('/', apiRouter)

export {
  httpServer,
  httpsServer
}
