import { Module } from '@nestjs/common';
import { TwitterListsService } from './twitter-lists.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TwitterListsEntity } from 'src/entities';
import { TwitterListsController } from './twitter-lists.controller';

@Module({
  imports: [
    TypeOrmModule.forFeature([TwitterListsEntity]),
  ],
  providers: [TwitterListsService],
  exports: [TwitterListsService],
  controllers: [TwitterListsController]
})
export class TwitterListsModule {}
