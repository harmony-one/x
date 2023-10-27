import cbor from 'cbor'
import jsrsasign from 'jsrsasign'
import { parseAuthenticatorData } from '@simplewebauthn/server/helpers'
import { hash as sha256 } from 'fast-sha256'
import { chunkstr, hexView, stringToBytes } from '../utils.js'
import config from '../config/index.js'
import NodeCache from 'node-cache'

const PubKeyCache = new NodeCache()
// https://www.apple.com/certificateauthority/Apple_App_Attestation_Root_CA.pem
// eslint-disable-next-line @typescript-eslint/no-unused-vars
const AppleRootCAPEM = `-----BEGIN CERTIFICATE-----
MIICITCCAaegAwIBAgIQC/O+DvHN0uD7jG5yH2IXmDAKBggqhkjOPQQDAzBSMSYw
JAYDVQQDDB1BcHBsZSBBcHAgQXR0ZXN0YXRpb24gUm9vdCBDQTETMBEGA1UECgwK
QXBwbGUgSW5jLjETMBEGA1UECAwKQ2FsaWZvcm5pYTAeFw0yMDAzMTgxODMyNTNa
Fw00NTAzMTUwMDAwMDBaMFIxJjAkBgNVBAMMHUFwcGxlIEFwcCBBdHRlc3RhdGlv
biBSb290IENBMRMwEQYDVQQKDApBcHBsZSBJbmMuMRMwEQYDVQQIDApDYWxpZm9y
bmlhMHYwEAYHKoZIzj0CAQYFK4EEACIDYgAERTHhmLW07ATaFQIEVwTtT4dyctdh
NbJhFs/Ii2FdCgAHGbpphY3+d8qjuDngIN3WVhQUBHAoMeQ/cLiP1sOUtgjqK9au
Yen1mMEvRq9Sk3Jm5X8U62H+xTD3FE9TgS41o0IwQDAPBgNVHRMBAf8EBTADAQH/
MB0GA1UdDgQWBBSskRBTM72+aEH/pwyp5frq5eWKoTAOBgNVHQ8BAf8EBAMCAQYw
CgYIKoZIzj0EAwMDaAAwZQIwQgFGnByvsiVbpTKwSga0kP0e8EeDS4+sQmTvb7vn
53O5+FRXgeLhpJ06ysC5PrOyAjEAp5U4xDgEgllF7En3VcE3iexZZtKeYnpqtijV
oyFraWVIyd/dganmrduC1bmTBGwD
-----END CERTIFICATE-----`

// Based on: https://github.com/kjur/jsrsasign/issues/176#issuecomment-1073434816
// See also discussions: https://github.com/trasherdk/jsrsasign/issues/3
const verifyCertificateChain = (certificates: string[]): boolean => {
  let valid = true
  for (let i = 0; i < certificates.length; i++) {
    let issuerIndex = i + 1
    // If i == certificates.length - 1, self signed root ca
    if (i === certificates.length - 1) issuerIndex = i
    const issuerPubKey = jsrsasign.KEYUTIL.getKey(certificates[issuerIndex])
    const certificate = new jsrsasign.X509(certificates[i])
    valid = valid && certificate.verifySignature(issuerPubKey)
  }
  return valid
}

const buildPEM = (binaryCert: Buffer): string => {
  const b64Encoded = binaryCert.toString('base64')
  return '-----BEGIN CERTIFICATE-----\n' +
      chunkstr(b64Encoded, 64).join('\n') + '\n' +
      '-----END CERTIFICATE-----\n'
}

// See https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3576643
// NOTE: a small part is copied from gist linked by discussions in https://developer.apple.com/forums/thread/687626
// See also PHP implementation: https://gist.github.com/gbalduzzi/0f2f14c3511da9e7811ad6f3a0175d06
// Related issues and partial implementations: https://developer.apple.com/forums/thread/662477
// const inputKeyId = get keyId from the app - this is a base64 of the sha256sum of the public key in uncompressed point format
// const attestation = get attestation from the app
export const validateAttestation = async (inputKeyId: string, challenge: string, attestation: string): Promise<boolean> => {
  const keyId = Buffer.from(inputKeyId, 'base64')
  // decoded CBOR format:
  // {
  //   fmt: 'apple-appattest',
  //   attStmt: {
  //     x5c: [
  //       <Buffer 30 82 02 cc ... >,
  //       <Buffer 30 82 02 36 ... >
  //     ],
  //     receipt: <Buffer 30 80 06 09 ... >
  //   },
  //   authData: <Buffer 21 c9 9e 00 ... >
  // }
  const attestationObject = (await cbor.decodeAll(Buffer.from(attestation, 'base64')))[0]
  const parsedAuthData = parseAuthenticatorData(attestationObject.authData)
  // authData.

  const credCertBuffer = Buffer.from(attestationObject.attStmt.x5c[0] ?? '')
  const receipt = Buffer.from(attestationObject.attStmt.receipt ?? '')

  // TODO: this is only partially done. Not using Apple’s App Attest root certificate yet
  if (credCertBuffer.length === 0) {
    console.error('Missing attestation credential cert')
    return false
  }
  if (receipt.length === 0) {
    console.error(`Missing receipt: ${receipt}`)
    return false
  }
  const credCert = new jsrsasign.X509()
  credCert.readCertHex(credCertBuffer.toString('hex'))
  // credCert.

  console.log(`CERT:\n${credCertBuffer.toString('hex')}\n\n`)

  // step 1: Verify that the x5c array contains the intermediate and leaf certificates for App Attest, starting from the credential certificate in the first data buffer in the array (credcert). Verify the validity of the certificates using Apple’s App Attest root certificate.

  const pemChain = attestationObject.attStmt.x5c.map((b: any) => buildPEM(Buffer.from(b)))
  const chainVerified = verifyCertificateChain([...pemChain, AppleRootCAPEM])
  if (!chainVerified) {
    console.error(`invalid cert chain of ${pemChain.length} certs`)
    for (const pem of pemChain) {
      console.error('cert:')
      console.error(pem)
      console.error('\n')
    }
    return false
  }

  // step 2: Create clientDataHash as the SHA256 hash of the one-time challenge your server sends to your app before performing the attestation, and append that hash to the end of the authenticator data (authData from the decoded object).
  const clientDataHash = Buffer.from(sha256(stringToBytes(challenge)))

  // step 3: Generate a new SHA256 hash of the composite item to create nonce.
  const appendedAuthData = Buffer.concat([Buffer.from(attestationObject.authData), clientDataHash])
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const nonce = Buffer.from(sha256(new Uint8Array(appendedAuthData)))
  const nonceStr = hexView(nonce)
  // step 4: Obtain the value of the credCert extension with OID 1.2.840.113635.100.8.2, which is a DER-encoded ASN.1 sequence. Decode the sequence and extract the single octet string that it contains. Verify that the string equals nonce.
  // DER and ASN.1 reference: https://letsencrypt.org/docs/a-warm-welcome-to-asn1-and-der/
  // TODO: not sure if this is implemented correctly. Waiting for jsrsasign library author to respond: https://github.com/kjur/jsrsasign/issues/364
  const extInfo = credCert.getExtInfo('1.2.840.113635.100.8.2')
  if (!extInfo) {
    console.error('Cannot find extension 1.2.840.113635.100.8.2')
    return false
  }

  // See usage at https://kjur.github.io/jsrsasign/api/symbols/ASN1HEX.html and jsrsasign source code in x509-1.1.js and asn1hex-1.1.js on how they used ASN1HEX.getV internally
  const expectedNonceStr = jsrsasign.ASN1HEX.getV(credCert.hex, extInfo.vidx)

  if (expectedNonceStr !== nonceStr) {
    console.error(`nonce mismatch: expectedNonce=${expectedNonceStr}; nonce=${nonceStr}`)
    return false
  }

  // const extension = parsedAuthData.
  // step 5: Create the SHA256 hash of the public key in credCert, and verify that it matches the key identifier from your app.

  const credCertPubKeyPoints = (credCert.getPublicKey() as jsrsasign.KJUR.crypto.ECDSA).getPublicKeyXYHex()
  const credCertPubKey = Buffer.concat([
    Buffer.from([0x04]),
    Buffer.from(credCertPubKeyPoints.x, 'hex'),
    Buffer.from(credCertPubKeyPoints.y, 'hex')
  ])
  const credCertPubKeyHash = hexView(sha256(credCertPubKey))
  const keyIdStr = hexView(keyId)
  if (credCertPubKeyHash !== keyIdStr) {
    console.error(`Invalid attestation credential cert public key hash: ${credCertPubKeyHash} !== ${keyIdStr}`)
    return false
  }
  const hexRpIdHash = hexView(parsedAuthData.rpIdHash)
  const appIdHash = hexView(sha256(stringToBytes(`${config.teamId}.${config.packageName}`)))

  // step 6: Compute the SHA256 hash of your app’s App ID, and verify that it’s the same as the authenticator data’s RP ID hash.
  if (hexRpIdHash !== appIdHash) {
    console.error(`rpIdHash !== appIdHash: ${hexRpIdHash} | ${appIdHash}`)
    return false
  }

  // step 7: Verify that the authenticator data’s counter field equals 0.
  if (parsedAuthData.counter !== 0) {
    console.error(`counter !== 0: ${parsedAuthData.counter}`)
    return false
  }
  // step 8: Verify that the authenticator data’s aaguid field is either appattestdevelop if operating in the development environment, or appattest followed by seven 0x00 bytes if operating in the production environment.
  if (!parsedAuthData.aaguid) {
    console.error('missing aaguid')
    return false
  }
  const aaguidStr = Buffer.from(parsedAuthData.aaguid).toString()
  if (config.debug) {
    if (aaguidStr !== 'appattestdevelop' && aaguidStr !== 'appattest\x00\x00\x00\x00\x00\x00\x00') {
      console.error(`bad aaguid: ${aaguidStr}; expected to be appattestdevelop or appattest\x00\x00\x00\x00\x00\x00\x00`)
      return false
    }
  } else {
    if (aaguidStr !== 'appattest\x00\x00\x00\x00\x00\x00\x00') {
      console.error(`bad aaguid: ${aaguidStr}; expected to be appattest\x00\x00\x00\x00\x00\x00\x00`)
      return false
    }
  }
  // step 9: Verify that the authenticator data’s credentialId field is the same as the key identifier.
  if (!parsedAuthData.credentialID || hexView(parsedAuthData.credentialID) !== keyIdStr) {
    console.error(`bad credentialID: ${aaguidStr}; expected to be keyId: ${keyIdStr}`)
    return false
  }
  // See https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3579385
  // TODO: verify the public key is not used by another user / device
  PubKeyCache.set(credCertPubKeyHash, { credCertPubKey, receipt })
  return true
}
