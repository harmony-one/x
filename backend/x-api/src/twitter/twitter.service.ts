import {Injectable, Logger} from '@nestjs/common';
import {ConfigService} from "@nestjs/config";
import axios from 'axios'
import {GetListTweetsDto} from "./dto/list.dto";
import {Cron, CronExpression, SchedulerRegistry} from "@nestjs/schedule";
import { CronJob } from 'cron';
import {DataSource} from "typeorm";
import {ListTweetEntity} from "../entities";
import { TwitterListsService } from 'src/twitter-lists/twitter-lists.service';

export interface ListTweetsResponseItem {
  id: string
  text: string
}

export interface ListTweetsResponse {
  data: ListTweetsResponseItem[]
  meta: {
    result_count: number
  }
}

@Injectable()
export class TwitterService {
  logger = new Logger(TwitterService.name)

  // twitterLists = [{
  //   name: 'harmony_h',
  //   id: '1735634638217875938'
  // }, {
  //   name: 'harmony_s',
  //   id: '1735634855352832089'
  // }, {
  //   name: 'harmony_x',
  //   id: '1735636432515903874'
  // }, {
  //   name: 'harmony_one',
  //   id: '1735636547297333288'
  // }, {
  //   name: 'harmony_ai',
  //   id: '1735637676743647429'
  // }]

  getTwitterLists = async () => {
    return await this.twitterListsService.getTwitterLists();
  }

  constructor(
    private dataSource: DataSource,
    private readonly configService: ConfigService,
    private schedulerRegistry: SchedulerRegistry,
    private readonly twitterListsService: TwitterListsService,
  ) {
    this.bootstrap()
  }

  private bootstrap() {
    const refetchTweetsJob = new CronJob(CronExpression.EVERY_30_MINUTES, () => {
      this.refetchTweetLists()
    });
    this.schedulerRegistry.addCronJob('update_twitter_lists', refetchTweetsJob)
    this.refetchTweetLists()
  }

  // @Cron(CronExpression.EVERY_30_MINUTES, {
  //   name: 'update_twitter_lists',
  // })
  async refetchTweetLists() {
    const job = this.schedulerRegistry.getCronJob('update_twitter_lists');
    job.stop();

    const twitterLists = await this.getTwitterLists();

    this.logger.log(`Run scheduled tweeter list update: ${twitterLists.length} lists`)

    for(let list of twitterLists) {
      try {
        await this.updateListTweets(list.id)
        this.logger.log(`Successfully updated list ${list.id} ${list.name}`)
      } catch (e) {
        this.logger.error(`Cannot update twitter list data: ${list.id} ${list.name}: ${(e as Error).message}`)
      }
    }

    job.start()
  }

  private async updateListTweets(listId: string) {
    const tweetsData = await this.fetchTwitterList(listId)

    this.logger.log(`ListId ${listId}: inserting ${tweetsData.meta.result_count} tweets`)

    await this.dataSource.manager.delete(ListTweetEntity, {
      listId
    });

    for(let listTweet of tweetsData.data) {
      await this.dataSource.manager.insert(ListTweetEntity, {
        listId,
        tweetId: listTweet.id,
        text: listTweet.text
      });
    }
  }

  // https://twitter.com/i/lists/suggested
  private async fetchTwitterList(listId: string) {
    const bearerToken = this.configService.get('twitter.bearerToken')
    const { data } = await axios.get<ListTweetsResponse>(`https://api.twitter.com/2/lists/${listId}/tweets`, {
      headers: {
        'Authorization': `Bearer ${bearerToken}`,
      }
    })
    return data
  }

  public getListByName(name: string) {
    return this.twitterListsService.getTwitterList({ name })
  }

  public async getListTweets(listId: string) {
    return await this.dataSource.manager.find(ListTweetEntity, {
      where: {
        listId
      },
      take: 100,
      order: {
        createdAt: 'desc',
      },
    })
  }
}
