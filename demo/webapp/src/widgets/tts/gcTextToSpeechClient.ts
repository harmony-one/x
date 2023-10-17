import axios, {AxiosInstance} from "axios";

interface Options {
  token: string,
  projectId: string
}

function base64ToArrayBuffer(base64: string): ArrayBuffer {
  const binaryString = window.atob(base64);
  const length = binaryString.length;
  const buffer = new ArrayBuffer(length);
  const uint8Array = new Uint8Array(buffer);
  for (let i = 0; i < length; i++) {
    uint8Array[i] = binaryString.charCodeAt(i);
  }
  return buffer;
}


export class GcTextToSpeechClient {
  private readonly _httpClient: AxiosInstance
  constructor (options: Options) {
    this._httpClient = axios.create({
      baseURL: 'https://texttospeech.googleapis.com',
      headers: {
        Authorization: `Bearer ${options.token}`,
        'Content-Type': 'application/json; charset=utf-8',
        'x-goog-user-project': options.projectId
      }
    })
  }

  async textToSpeech({text, languageCode, voiceName}: {text: string, languageCode: string, voiceName: string}): Promise<ArrayBuffer> {
    const response = await this._httpClient.post('/v1/text:synthesize/', {
      "input": {
        "text": text
      },
      "voice": {
        "languageCode": languageCode,
        "name": voiceName,
      },
      "audioConfig" : {
        "audioEncoding":"MP3"
      }
    })

    return base64ToArrayBuffer(response.data.audioContent)
  }
}
