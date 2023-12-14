import {Injectable, Logger} from '@nestjs/common';
import {ConfigService} from "@nestjs/config";
import axios from 'axios'
import {Cron, CronExpression, SchedulerRegistry} from "@nestjs/schedule";
import { CronJob } from 'cron';
import {DataSource} from "typeorm";
import {ListTweetEntity} from "../entities";

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
export class TwitterListsService {
  logger = new Logger(TwitterListsService.name)
  constructor(
    private dataSource: DataSource,
    private readonly configService: ConfigService,
    private schedulerRegistry: SchedulerRegistry
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

    // https://twitter.com/i/lists/1597593475389984769
    const lists = [{
      name: 'Crypto',
      id: '1597593475389984769'
    }]

    this.logger.log(`Run scheduled tweeter list update: ${lists.length} lists`)

    for(let list of lists) {
      try {
        await this.updateListTweets(list.id)
        this.logger.log(`Successfully updated tweeter list ${list.id} ${list.name}`)
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

  public async getListTweets() {
    return await this.dataSource.manager.find(ListTweetEntity, {
      take: 100,
      order: {
        createdAt: 'desc',
      },
    })
  }
}
