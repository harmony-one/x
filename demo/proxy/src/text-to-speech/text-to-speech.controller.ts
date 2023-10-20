import { Controller, Post, Get, StreamableFile, Body } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Readable } from 'stream';
import { IsNotEmpty, IsIn } from 'class-validator';
import { TextToSpeechService } from './text-to-speech.service';

class SynthesizeParams {
  @IsNotEmpty()
  text: string;

  @IsIn(['en-US'])
  languageCode: string;

  @IsIn(['en-US-Neural2-H'])
  voiceName: string;
}

@Controller('text-to-speech')
export class TextToSpeechController {
  constructor(
    private configService: ConfigService,
    private ttsService: TextToSpeechService,
  ) { }

  @Post('google')
  async synthesize(@Body() params: SynthesizeParams) {
    const result = await this.ttsService.googleSyntesize(params);

    if (typeof result === 'string') {
      throw new Error('internal error');
    }

    return new StreamableFile(result);
  }

  @Post('azure')
  async azureSynthesize(@Body() params: SynthesizeParams) {
    const result = await this.ttsService.azureSyntesize(params);

    if (typeof result === 'string') {
      throw new Error('internal error');
    }

    return new StreamableFile(result);
  }
}
