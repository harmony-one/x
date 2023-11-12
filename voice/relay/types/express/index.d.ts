declare global {
  namespace Express {
    interface Request {
      deviceToken: string
    }
  }
}

export {}
