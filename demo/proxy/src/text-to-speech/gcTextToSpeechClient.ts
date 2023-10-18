import GcTextToSpeech, {
  type TextToSpeechClient,
} from '@google-cloud/text-to-speech';
import type { CredentialBody } from 'google-auth-library/build/src/auth/credentials';
import type { google } from '@google-cloud/text-to-speech/build/protos/protos';

export interface TextToSpeechParams {
  text: string;
  languageCode: string;
  ssmlGender?:
    | google.cloud.texttospeech.v1.SsmlVoiceGender
    | keyof typeof google.cloud.texttospeech.v1.SsmlVoiceGender
    | null;
  voiceName?: string | null;
}

export class GcTextToSpeechClient {
  private readonly _client: TextToSpeechClient;
  constructor(credentials: CredentialBody) {
    this._client = new GcTextToSpeech.TextToSpeechClient({ credentials });
  }

  async ssmlTextToSpeech({
    text,
    languageCode,
    ssmlGender,
    voiceName,
  }: TextToSpeechParams): Promise<string | Uint8Array | null | undefined> {
    const ssml = `<speak>${text}</speak>`;
    const [response] = await this._client.synthesizeSpeech({
      input: { ssml },
      voice: { languageCode, ssmlGender, name: voiceName },
      audioConfig: { audioEncoding: 'OGG_OPUS' },
    });

    return response.audioContent;
  }

  async textToSpeech({
    text,
    languageCode,
    voiceName,
  }: TextToSpeechParams): Promise<string | Uint8Array | null | undefined> {
    const [response] = await this._client.synthesizeSpeech({
      input: { text },
      voice: { languageCode, name: voiceName },
      audioConfig: { audioEncoding: 'OGG_OPUS' },
    });

    return response.audioContent;
  }

  async listVoices(): Promise<
    google.cloud.texttospeech.v1.IVoice[] | null | undefined
  > {
    const response = await this._client.listVoices();
    return response[0].voices;
  }
}
