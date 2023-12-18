import {Controller, Get, NotFoundException, Param, Query, UsePipes, ValidationPipe} from '@nestjs/common';
import {ApiParam, ApiTags} from "@nestjs/swagger";
import {TwitterService} from "./twitter.service";

@ApiTags('twitter')
@Controller('twitter')
export class TwitterController {
  constructor(private readonly twitterService: TwitterService) {}

  @Get('/lists')
  getLists() {
    return this.twitterService.getTwitterLists();
  }

  @Get('/list/:name')
  @ApiParam({
    name: 'name',
    required: true,
    description: 'Twitter list name',
    schema: { oneOf: [{ type: 'string' }] },
  })
  @UsePipes(new ValidationPipe({ transform: true }))
  async getListByName(@Param() params: { name: string }) {
    const { name } = params
    const list = this.twitterService.getListByName(name)
    if(list) {
      return await this.twitterService.getListTweets(list.id)
    }
    throw new NotFoundException(`List with name "${name}" not found`)
  }
}
