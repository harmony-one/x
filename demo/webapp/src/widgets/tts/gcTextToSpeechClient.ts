import axios, {AxiosInstance} from "axios";

interface Options {
  host: string,
}

export class GcTextToSpeechClient {
  private readonly _httpClient: AxiosInstance
  constructor (options: Options) {
    this._httpClient = axios.create({
      baseURL: options.host,
    })
  }

  async textToSpeech(params: {text: string, languageCode: string, voiceName: string}): Promise<ArrayBuffer> {
    const response = await this._httpClient.post('/text-to-speech/google', params, {responseType: 'arraybuffer'})
    return response.data
  }
}
