import { Injectable } from '@nestjs/common';
import {ConfigService} from "@nestjs/config";
import {Deepgram} from "@deepgram/sdk";
import {LiveTranscription} from "@deepgram/sdk/dist/transcription/liveTranscription";

@Injectable()
export class DeepgramService {
  private deepgramLive: LiveTranscription
  constructor(private readonly configService: ConfigService) {
    this.bootstrap()
  }

  bootstrap() {
    const apiKey = this.configService.get('deepgram.apiKey')
    const deepgram = new Deepgram(apiKey);
    const deepgramLive = deepgram.transcription.live({
      smart_format: true,
      interim_results: false,
      language: "en-US",
      model: "nova",
    });

    this.deepgramLive = deepgramLive

    deepgramLive.addListener("close", () => {
      console.log("Connection closed.");
    });

    deepgramLive.addListener("transcriptReceived", (message) => {
      const data = JSON.parse(message);
      console.log('transcriptReceived', data)

      // Write the entire response to the console
      console.dir(data.channel, { depth: null });

      // Write only the transcript to the console
      //console.dir(data.channel.alternatives[0].transcript, { depth: null });
    });
  }

  public decodeAudio(data: any) {
    if (this.deepgramLive.getReadyState() == 1) {
      this.deepgramLive.send(data);
    }
    return 'OK'
  }
}
