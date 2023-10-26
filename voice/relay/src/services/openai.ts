
export type OnUpdate = (data?: Buffer, error?: Error) => void

const OpenAI = {
  completion: (onUpdate: OnUpdate, onFinished: () => void) => {
    // TODO
    onUpdate(undefined, new Error('Not implemented'))
    onFinished()
  }
}

export default OpenAI
