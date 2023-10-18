import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TextToSpeechController } from './text-to-speech.controller';
import { TextToSpeechService } from './text-to-speech.service';

@Module({
  imports: [ConfigModule],
  providers: [TextToSpeechService],
  controllers: [TextToSpeechController],
})
export class TextToSpeechModule {}
