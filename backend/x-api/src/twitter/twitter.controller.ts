import {Controller, Get, Query} from '@nestjs/common';
import {ApiTags} from "@nestjs/swagger";
import {TwitterService} from "./twitter.service";
import {GetListTweetsDto} from "./dto/list.dto";

@ApiTags('twitter')
@Controller('twitter')
export class TwitterController {
  constructor(private readonly twitterService: TwitterService) {}

  @Get('/list')
  getListTweets(@Query() dto: GetListTweetsDto) {
    return this.twitterService.getListTweets(dto)
  }
}
