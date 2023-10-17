import TTSPlugin from "../../../../resemble/src/widgets/tts/tts-plugin";
import {defaultElevenLabsVoiceID} from "../../../../resemble/src/widgets/tts/elevenlabs-defaults";
import {Voice} from "../../../../resemble/src/widgets/tts/types";
import {GcTextToSpeechClient} from "./gcTextToSpeechClient";

export interface GoogleCloudPluginOptions {
  projectId: string
  token: string
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

    if (!this.options?.token || !this.options?.projectId) {
      throw new Error('Setup google plugin')
    }

    const gcTextToSpeedClient = new GcTextToSpeechClient({
      projectId: this.options?.projectId,
      token: this.options?.token
    })

    return gcTextToSpeedClient.textToSpeech(options)
  }
}