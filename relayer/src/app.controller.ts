import {Body, Controller, Get, Post, Res} from '@nestjs/common';
import { AppService } from './app.service';
import {DeepgramService} from "./deepgram/deepgram.service";

@Controller()
export class AppController {
  constructor(private readonly deepgramService: DeepgramService) {}

  @Post('/decodeAudio')
  decodeAudio(@Body() data: any) {
    console.log('received data')
    return this.deepgramService.decodeAudio(data);
  }
}
