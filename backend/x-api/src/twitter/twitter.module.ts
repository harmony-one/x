import { Module } from '@nestjs/common';
import { TwitterService } from './twitter.service';
import { TwitterController } from './twitter.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {TwitterListsEntity} from "../entities";
import {ThrottlerModule} from "@nestjs/throttler";

@Module({
  imports: [
    ThrottlerModule.forRoot([{
      ttl: 60000,
      limit: 20,
    }]),
  TypeOrmModule.forFeature([TwitterListsEntity])
  ],
  providers: [TwitterService],
  controllers: [TwitterController]
})
export class TwitterModule {}
