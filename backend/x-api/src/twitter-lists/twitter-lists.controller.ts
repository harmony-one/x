import {Controller, Get, Post, NotFoundException, Param, Query, UsePipes, ValidationPipe, Body, Delete} from '@nestjs/common';
import {ApiParam, ApiTags} from "@nestjs/swagger";
import {TwitterListsService} from "./twitter-lists.service";
import { TwitterListsCreateDto } from './dto/stream-lists.create.dto';

@ApiTags('twitter-lists')
@Controller('twitter-lists')
export class TwitterListsController {
  constructor(private readonly twitterListsService: TwitterListsService) {}

  @Get('/')
  getLists() {
    return this.twitterListsService.getTwitterLists();
  }

  @Post('/')
  createTwitterList(@Body() twitterListDto: TwitterListsCreateDto) {
    return this.twitterListsService.createTwitterList(twitterListDto);
  }

  @Get('/:listId')
  @ApiParam({
    name: 'listId',
    required: true,
    description: 'Twitter List id',
    schema: { oneOf: [{ type: 'string' }] },
  })
  getTwitterList(@Param('listId') listId) {
    return this.twitterListsService.getTwitterList({ listId });
  }

  @Delete('/:listId')
  @ApiParam({
    name: 'listId',
    required: true,
    description: 'Twitter List id',
    schema: { oneOf: [{ type: 'string' }] },
  })
  async deleteTwitterList(@Param('listId') listId) {
    await this.twitterListsService.deleteTwitterList(listId);

    return true
  }

  @Post('/:listId/enable')
  @ApiParam({
    name: 'listId',
    required: true,
    description: 'Twitter List id',
    schema: { oneOf: [{ type: 'string' }] },
  })
  async enableTwitterList(@Param('listId') listId) {
    await this.twitterListsService.enableTwitterList(listId);

    return this.twitterListsService.getTwitterList({ listId });
  }

  @Post('/:listId/disable')
  @ApiParam({
    name: 'listId',
    required: true,
    description: 'Twitter List id',
    schema: { oneOf: [{ type: 'string' }] },
  })
  async disableTwitterList(@Param('listId') listId) {
    await this.twitterListsService.disableTwitterList(listId);

    return this.twitterListsService.getTwitterList({ listId });
  }
}
