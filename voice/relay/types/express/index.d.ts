declare global {
  namespace Express {
    interface Request {
      deviceToken?: string
      deviceTokenHash?: string
      attestationHash?: string
      token?: string
    }
  }
}

export {}
