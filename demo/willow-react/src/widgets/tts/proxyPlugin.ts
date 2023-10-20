import axios from "axios";
import TTSPlugin from "./tts-plugin";
import { Voice } from "./types";

export interface proxyPluginOptions {
  proxyApi: string
}

const defaultLangCode = 'en-US'
const defaultVoiceId = 'en-US-Neural2-H'

export class ProxyPlugin extends TTSPlugin<proxyPluginOptions> {
  async getCurrentVoice(): Promise<Voice> {
    return {
      service: 'googleCloud',
      id: 'en-US-Neural2-H',
    };
  }

  async speakToBuffer(text: string, voice?: Voice): Promise<ArrayBuffer | null | undefined> {
    const options = { text, languageCode: defaultLangCode, voiceName: defaultVoiceId };

    if (!this.options?.proxyApi) {
      throw new Error('Setup proxy url')
    }

    const response = await axios.post(
      this.options.proxyApi,
      options,
      { responseType: 'arraybuffer' }
    )

    return response.data
  }
}