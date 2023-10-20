import TTSPlugin from "./tts-plugin";
import {Voice} from "./types";
import {GcTextToSpeechClient} from "./gcTextToSpeechClient";

export interface GoogleCloudPluginOptions {
  host: string
}

const defaultLangCode = 'en-US'
const defaultVoiceId = 'en-US-Neural2-H'

export class GoogleCloudPlugin extends TTSPlugin<GoogleCloudPluginOptions> {
  async getCurrentVoice(): Promise<Voice> {
    return {
      service: 'googleCloud',
      id: 'en-US-Neural2-H',
    };
  }

  async speakToBuffer(text: string, voice?: Voice): Promise<ArrayBuffer | null | undefined> {
    const options = {text, languageCode: defaultLangCode, voiceName: defaultVoiceId};

    if (!this.options?.host) {
      throw new Error('Setup proxy url')
    }

    const gcTextToSpeedClient = new GcTextToSpeechClient({
      host: this.options?.host,
    })

    return gcTextToSpeedClient.textToSpeech(options)
  }
}