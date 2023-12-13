import {Injectable, Logger} from '@nestjs/common';
import {ConfigService} from "@nestjs/config";
import axios from 'axios'
import {GetListTweetsDto} from "./dto/list.dto";

@Injectable()
export class TwitterService {
  logger = new Logger(TwitterService.name)
  constructor(private readonly configService: ConfigService) {}

  public async getListTweets(dto: GetListTweetsDto) {
    const listId = 'testId'

    const bearerToken = this.configService.get('twitter.bearerToken')
    const { data } = await axios.get(`https://api.twitter.com/2/lists/:${listId}/tweets`, {
      headers: {
        'Authorization': `Bearer ${bearerToken}`
      }
    })
    return data
  }
}
