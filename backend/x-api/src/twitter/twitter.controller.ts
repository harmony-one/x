import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Get, Logger,
  NotFoundException,
  Param,
  Post,
  Query, UseInterceptors,
  UsePipes,
  ValidationPipe
} from '@nestjs/common';
import {ApiParam, ApiTags} from "@nestjs/swagger";
import {TwitterService} from "./twitter.service";
import {GetTwitterListsDto, TwitterListsCreateDto, UpdateTwitterListDto} from "./dto/list.dto";
import {SkipThrottle} from "@nestjs/throttler";
import {CacheInterceptor} from "@nestjs/cache-manager";
import {CacheTTL} from "@nestjs/common/cache";


@ApiTags('twitter')
@Controller('twitter')
export class TwitterController {
  logger = new Logger(TwitterController.name)
  constructor(private readonly twitterService: TwitterService) {}

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
    const list = await this.twitterService.getListByName(name)

    if(list) {
      return await this.twitterService.getListTweets(list.listId)
    }
    throw new NotFoundException(`List with name "${name}" not found`)
  }

  @UseInterceptors(CacheInterceptor)
  @CacheTTL(2)
  @Get('/lists')
  getLists(@Query() dto: GetTwitterListsDto) {
    return this.twitterService.getTwitterLists(dto);
  }

  @Post('/list')
  async createTwitterList(@Body() dto: TwitterListsCreateDto) {
    const { listId } = dto

    const existedList = await this.twitterService.getTwitterList({ listId })
    if(existedList) {
      throw new BadRequestException(`List ${listId} already exists`)
    }

    await this.twitterService.createTwitterList(dto);

    this.twitterService.updateListTweets(listId).catch(e => {
      this.logger.error(`Update twitter list error: ${e.message}`)
    })

    return this.twitterService.getTwitterList({ listId })
  }

  @SkipThrottle()
  @UseInterceptors(CacheInterceptor)
  @CacheTTL(2)
  @Get('/:listId')
  @ApiParam({
    name: 'listId',
    required: true,
    description: 'Twitter List id',
    schema: { oneOf: [{ type: 'string' }] },
  })
  getTwitterList(@Param('listId') listId) {
    return this.twitterService.getTwitterList({ listId });
  }

  @Delete('/:listId')
  @ApiParam({
    name: 'listId',
    required: true,
    description: 'Twitter List id',
    schema: { oneOf: [{ type: 'string' }] },
  })
  async deleteTwitterList(@Param('listId') listId) {
    const list = await this.twitterService.getTwitterList({ listId })
    if(!list) {
      throw new NotFoundException(`List with id ${listId} not found`)
    }
    return await this.twitterService.deleteTwitterList(listId);
  }

  @Post('/:listId/update')
  @ApiParam({
    name: 'listId',
    required: true,
    description: 'Twitter List id',
    schema: { oneOf: [{ type: 'string' }] },
  })
  async updateTwitterList(
    @Param('listId') listId: string,
    @Query() dto: UpdateTwitterListDto
  ) {
    const list = await this.twitterService.getTwitterList({ listId })
    if(!list) {
      throw new NotFoundException(`List with id ${listId} not found`)
    }
    await this.twitterService.updateTwitterList(listId, dto);

    return this.twitterService.getTwitterList({ listId });
  }
}
