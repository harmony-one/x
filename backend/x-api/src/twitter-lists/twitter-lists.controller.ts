import {Controller, Get, Query} from '@nestjs/common';
import {ApiTags} from "@nestjs/swagger";
import {TwitterListsService} from "./twitter-lists.service";

@ApiTags('twitter')
@Controller('twitter')
export class TwitterListsController {
  constructor(private readonly twitterService: TwitterListsService) {}

  @Get('/list')
  getListTweets() {
    return this.twitterService.getListTweets(dto)
  }
}
