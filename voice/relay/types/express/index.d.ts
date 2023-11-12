declare global {
  namespace Express {
    interface Request {
      deviceToken: string
      deviceTokenHash: string
    }
  }
}

export {}
