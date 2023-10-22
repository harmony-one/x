import TTSPlugin from "./tts-plugin";
import {Voice} from "./types";
import axios from "axios";

export interface GoogleCloudAPIPluginOptions {
  apiKey: string
}

interface GoogleCloudAPISynthesizeResponse {
  audioContent: string
}

function base64ToArrayBuffer(base64: string) {
  var binaryString = atob(base64);
  var bytes = new Uint8Array(binaryString.length);
  for (var i = 0; i < binaryString.length; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }
  return bytes.buffer;
}

const GoogleCloudAPIUrl = 'https://content-texttospeech.googleapis.com'
const defaultLangCode = 'en-US'
const defaultVoiceId = 'en-US-Neural2-H'

export class GoogleCloudAPIPlugin extends TTSPlugin<GoogleCloudAPIPluginOptions> {
  async getCurrentVoice(): Promise<Voice> {
    return {
      service: 'googleCloud',
      id: 'en-US-Neural2-H',
    };
  }

  async speakToBuffer(text: string, voice?: Voice): Promise<ArrayBuffer | null | undefined> {
    if (!this.options?.apiKey) {
      throw new Error('Setup apiKey')
    }

    const payload = {
      input: {
        text
      },
      audioConfig: {
        audioEncoding: 'OGG_OPUS'
      },
      voice: {
        languageCode: 'en'
      }
    }

    const data = await axios.post(
      `${GoogleCloudAPIUrl}/v1/text:synthesize?alt=json&key=${this.options.apiKey}`,
      payload,
    )
    const { audioContent } = data.data
    console.log('Gooole API data:',  data.data)
    return base64ToArrayBuffer(audioContent)
  }
}
