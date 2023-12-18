import { Module } from '@nestjs/common';
import { TwitterService } from './twitter.service';
import { TwitterController } from './twitter.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {TwitterListsEntity} from "../entities";

@Module({
  imports: [TypeOrmModule.forFeature([TwitterListsEntity])],
  providers: [TwitterService],
  controllers: [TwitterController]
})
export class TwitterModule {}
