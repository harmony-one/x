import {Injectable, Logger} from '@nestjs/common';
import {ConfigService} from "@nestjs/config";

@Injectable()
export class TwitterService {
  logger = new Logger(TwitterService.name)
  constructor(private readonly configService: ConfigService) {}

  public getTwitterFeed() {
    const twitterUsername = this.configService.get('twitter.username')
    this.logger.log(`Twitter username: ${twitterUsername}`)
    return 'test'
  }
}
