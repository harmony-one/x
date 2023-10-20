import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as path from 'path';
import * as fs from 'fs';
import {
  GcTextToSpeechClient,
  TextToSpeechParams,
} from './gcTextToSpeechClient';
import { textToSpeechAzure } from './azureTextToSpeechClient';

@Injectable()
export class TextToSpeechService {
  gcClient: GcTextToSpeechClient;

  constructor(private configService: ConfigService) {
    const credentialsPath = configService.get('GC_CREDENTIALS_PATH', '.gc-credentials.json');

    const content = fs.readFileSync(path.join(credentialsPath));
    const credentials = JSON.parse(content.toString());
    this.gcClient = new GcTextToSpeechClient(credentials);
  }

  async googleSyntesize(params: TextToSpeechParams) {
    const result = await this.gcClient.textToSpeech(params);
    return result;
  }

  async azureSyntesize(params: TextToSpeechParams) {
    return textToSpeechAzure(
      this.configService.get('AZURE_SPEECH_KEY'),
      this.configService.get('AZURE_SPEECH_REGION'),
      params.text
    )
  }
}
