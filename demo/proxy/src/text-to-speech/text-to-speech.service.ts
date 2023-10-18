import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as path from 'path';
import * as fs from 'fs';
import {
  GcTextToSpeechClient,
  TextToSpeechParams,
} from './gcTextToSpeechClient';

@Injectable()
export class TextToSpeechService {
  gcClient: GcTextToSpeechClient;

  constructor(private configService: ConfigService) {
    const credentialsPath = configService.get('GC_CREDENTIALS_PATH');

    const content = fs.readFileSync(path.join(credentialsPath));
    const credentials = JSON.parse(content.toString());
    this.gcClient = new GcTextToSpeechClient(credentials);
  }

  async googleSyntesize(text: string) {
    const params: TextToSpeechParams = {
      text,
      languageCode: 'en-US',
      voiceName: 'en-US-Neural2-H',
    };
    const result = await this.gcClient.textToSpeech(params);
    return result;
  }
}
