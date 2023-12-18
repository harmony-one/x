import { Module } from '@nestjs/common';
import { TwitterListsService } from './twitter-lists.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TwitterListsEntity } from 'src/entities';

@Module({
  imports: [
    TypeOrmModule.forFeature([TwitterListsEntity]),
  ],
  providers: [TwitterListsService],
})
export class TwitterListsModule {}
