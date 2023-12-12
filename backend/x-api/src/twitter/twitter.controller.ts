import {Controller, Get} from '@nestjs/common';
import {ApiTags} from "@nestjs/swagger";
import {TwitterService} from "./twitter.service";

@ApiTags('twitter')
@Controller('twitter')
export class TwitterController {
  constructor(private readonly twitterService: TwitterService) {}

  @Get('/feed')
  getFeed() {
    return this.twitterService.getTwitterFeed()
  }
}
