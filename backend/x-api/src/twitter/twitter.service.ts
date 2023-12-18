import {Injectable, Logger} from '@nestjs/common';
import {ConfigService} from "@nestjs/config";
import axios from 'axios'
import {UpdateTwitterListDto} from "./dto/list.dto";
import {CronExpression, SchedulerRegistry} from "@nestjs/schedule";
import { CronJob } from 'cron';
import {DataSource, Repository} from "typeorm";
import {ListTweetEntity, TwitterListsEntity} from "../entities";
import {InjectRepository} from "@nestjs/typeorm";

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

  defaultLists = [{
    name: 'harmony_h',
    listId: '1735634638217875938'
  }, {
    name: 'harmony_s',
    listId: '1735634855352832089'
  }, {
    name: 'harmony_x',
    listId: '1735636432515903874'
  }, {
    name: 'harmony_one',
    listId: '1735636547297333288'
  }, {
    name: 'harmony_ai',
    listId: '1735637676743647429'
  }]

  constructor(
    private dataSource: DataSource,
    private readonly configService: ConfigService,
    private schedulerRegistry: SchedulerRegistry,
    @InjectRepository(TwitterListsEntity)
    private twitterListsRep: Repository<TwitterListsEntity>,
  ) {
    this.bootstrap()
  }

  private async bootstrap() {
    // for(let twitterList of this.defaultLists) {
    //   const { listId, name } = twitterList
    //   const existedList = await this.getTwitterList({ listId })
    //   if(!existedList) {
    //     await this.createTwitterList(twitterList)
    //     this.logger.log(`Created default twitter list ${name} ${listId}`)
    //   }
    // }
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
        await this.updateListTweets(list.listId)
        this.logger.log(`Successfully updated list ${list.listId} ${list.name}`)
      } catch (e) {
        this.logger.error(`Cannot update twitter list data: ${list.listId} ${list.name}: ${(e as Error).message}`)
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

    for(let tweet of tweetsData.data) {
      await this.dataSource.manager.insert(ListTweetEntity, {
        listId,
        tweetId: tweet.id,
        text: tweet.text
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
    return this.getTwitterList({ name })
  }

  async getTwitterList(params?: { listId?: string, name?: string }) {
    return await this.twitterListsRep.findOneBy(params);
  }

  async getTwitterLists() {
    return await this.twitterListsRep.find();
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

  async createTwitterList(params: { listId: string, name: string }) {
    return await this.twitterListsRep.save(params);
  }

  async updateTwitterList(listId: string, params: UpdateTwitterListDto) {
    const twitterList = await this.twitterListsRep.findOneBy({ listId });
    return await this.twitterListsRep.update(twitterList, params);
  }

  async deleteTwitterList(listId: string) {
    return await this.twitterListsRep.delete({
      listId
    });
  }
}
