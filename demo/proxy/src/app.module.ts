import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { TextToSpeechModule } from './text-to-speech/text-to-speech.module';

@Module({
  imports: [ConfigModule.forRoot(), TextToSpeechModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
