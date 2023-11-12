import express, { type Response, type Request, type NextFunction } from 'express'
import cookieParser from 'cookie-parser'
import morgan from 'morgan'
import createError from 'http-errors'
// import apiRouter from './routes/hard.js'
import softRateLimitedApiRouter from './routes/soft.js'
import fs from 'fs'
import http, { type Server as HttpServer } from 'http'
import https from 'https'
import config from './config/index.js'
import cors from 'cors'
import compression from 'compression'
import requestIp from 'request-ip'

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
app.use(compression())
app.use(requestIp.mw())

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

app.use('/soft', softRateLimitedApiRouter)

// catch 404 and forward to error handler
app.use(function (req, res, next) {
  next(createError(404))
})

// error handler
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  // set locals, only providing error in development
  res.locals.message = err.message
  res.locals.error = config.debug ? err : ''

  // render the error page
  res.status(500)
  res.json({ error: res.locals.error, message: err.message, stack: config.debug ? err.stack : undefined })
})

export {
  httpServer,
  httpsServer
}
