import OpenAI from 'openai'
import { type ChatCompletionCreateParamsBase, type ChatCompletionChunk, type ChatCompletion } from 'openai/src/resources/chat/completions.js'
import config from '../config/index.js'

const openai = new OpenAI({ apiKey: config.openai.key })

export type OnCompletionUpdate = (data?: ChatCompletionChunk) => void

const OpenAIRelay = {
  completionStream: async (body: ChatCompletionCreateParamsBase, onUpdate: OnCompletionUpdate): Promise<void> => {
    const stream = await openai.chat.completions.create({
      ...body,
      stream: true
    })
    for await (const part of stream) {
      onUpdate(part)
    }
  },
  completion: async (body: ChatCompletionCreateParamsBase): Promise<ChatCompletion> => {
    return await openai.chat.completions.create(body) as ChatCompletion
  }
}

export default OpenAIRelay
