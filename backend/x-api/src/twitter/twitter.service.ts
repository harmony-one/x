import {Injectable, Logger} from '@nestjs/common';
import {ConfigService} from "@nestjs/config";
import axios from 'axios'

@Injectable()
export class TwitterService {
  logger = new Logger(TwitterService.name)
  constructor(private readonly configService: ConfigService) {}

  public async getTwitterFeed() {
    const twitterUsername = this.configService.get('twitter.username')
    this.logger.log(`Twitter username: ${twitterUsername}`)

    // const { data } = await axios.get('SomeRequestURL')

    return 'test'
  }
}
