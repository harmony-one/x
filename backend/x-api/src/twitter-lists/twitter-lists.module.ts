import { Module } from '@nestjs/common';
import { TwitterListsService } from './twitter-lists.service';
import { TwitterListsController } from './twitter-lists.controller';

@Module({
  providers: [TwitterListsService],
  controllers: [TwitterListsController]
})
export class TwitterListsModule {}
