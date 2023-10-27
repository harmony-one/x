#!/usr/bin/env ts-node-esm
import { httpsServer, httpServer } from '../src/app.js'
import { type AddressInfo } from 'net'

console.log('Starting web server...')

httpsServer.listen(process.env.HTTPS_PORT ?? 8443, () => {
  const { port, address } = httpsServer.address() as AddressInfo
  console.log(`HTTPS server listening on port ${port} at ${address}`)
})

httpServer.listen(process.env.PORT ?? 3000, () => {
  const { port, address } = httpServer.address() as AddressInfo
  console.log(`HTTP server listening on port ${port} at ${address}`)
})
