import { Module } from '@nestjs/common';
import { TwitterService } from './twitter.service';
import { TwitterController } from './twitter.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {TwitterListsEntity} from "../entities";
import {ThrottlerModule} from "@nestjs/throttler";
import {CacheModule} from "@nestjs/cache-manager";
import {APP_INTERCEPTOR} from "@nestjs/core";
import {CacheInterceptor} from "@nestjs/cache-manager";

@Module({
  imports: [
    CacheModule.register({
      ttl: 20, // seconds
      max: 100, // maximum number of items in cache
    }),
    ThrottlerModule.forRoot([{
      ttl: 60000,
      limit: 20,
    }]),
  TypeOrmModule.forFeature([TwitterListsEntity])
  ],
  providers: [
    {
      provide: APP_INTERCEPTOR,
      useClass: CacheInterceptor,
    },
    TwitterService
  ],
  controllers: [TwitterController]
})
export class TwitterModule {}
