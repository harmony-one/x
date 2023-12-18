import { Injectable, Logger } from '@nestjs/common';
import { TwitterListsEntity } from "../entities";
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

@Injectable()
export class TwitterListsService {
  logger = new Logger(TwitterListsService.name)

  constructor(
    @InjectRepository(TwitterListsEntity)
    private twitterListsRep: Repository<TwitterListsEntity>,
  ) {

  }

  async getTwitterLists() {
    return await this.twitterListsRep.find();
  }

  async getTwitterList(params?: { listId?: string, name?: string }) {
    return await this.twitterListsRep.findOneBy(params);
  }

  async createTwitterList(params: { listId: string, name: string }) {
    return await this.twitterListsRep.save(params);
  }

  async enableTwitterList(listId: string) {
    const twitterList = await this.twitterListsRep.findOneBy({ listId });

    return await this.twitterListsRep.update(twitterList, { isActive: true });
  }

  async disableTwitterList(listId: string) {
    const twitterList = await this.twitterListsRep.findOneBy({ listId });

    return await this.twitterListsRep.update(twitterList, { isActive: false });
  }

  async deleteTwitterList(listId: string) {
    const twitterList = await this.twitterListsRep.findOneBy({ listId });

    return await this.twitterListsRep.delete(twitterList);
  }
}
