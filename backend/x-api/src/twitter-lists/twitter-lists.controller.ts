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

  @Delete('/:listId')
  deleteTwitterList(@Param('listId') listId) {
    return this.twitterListsService.deleteTwitterList(listId);
  }

  @Post('/:listId/enable')
  enableTwitterList(@Param('listId') listId) {
    return this.twitterListsService.enableTwitterList(listId);
  }

  @Post('/:listId/disable')
  disableTwitterList(@Param('listId') listId) {
    return this.twitterListsService.disableTwitterList(listId);
  }
}
