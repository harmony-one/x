import { Module } from '@nestjs/common';
import { TwitterService } from './twitter.service';
import { TwitterController } from './twitter.controller';
import { TwitterListsModule } from 'src/twitter-lists/twitter-lists.module';

@Module({
  imports: [TwitterListsModule],
  providers: [TwitterService],
  controllers: [TwitterController]
})
export class TwitterModule {}
