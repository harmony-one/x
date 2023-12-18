import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Get,
  NotFoundException,
  Param,
  Post,
  Query,
  UsePipes,
  ValidationPipe
} from '@nestjs/common';
import {ApiParam, ApiTags} from "@nestjs/swagger";
import {TwitterService} from "./twitter.service";
import {TwitterListsCreateDto, UpdateTwitterListDto} from "./dto/list.dto";

@ApiTags('twitter')
@Controller('twitter')
export class TwitterController {
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

  @Get('/lists')
  getLists() {
    return this.twitterService.getTwitterLists();
  }

  @Post('/list')
  async createTwitterList(@Body() dto: TwitterListsCreateDto) {
    const existedList = await this.twitterService.getTwitterList({ listId: dto.listId })
    if(existedList) {
      throw new BadRequestException(`List ${dto.listId} already exists`)
    }
    return this.twitterService.createTwitterList(dto);
  }

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
    await this.twitterService.deleteTwitterList(listId);

    return true
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
    await this.twitterService.updateTwitterList(listId, dto);

    return this.twitterService.getTwitterList({ listId });
  }
}
