import { ApiProperty } from '@nestjs/swagger';
import {IsBoolean, IsNotEmpty, IsString} from 'class-validator';
import { Type } from 'class-transformer';

export class TwitterListsCreateDto {
  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  listId: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  name: string;
}

export class GetListTweetsDto {
  @ApiProperty({ type: String, required: true })
  @IsString()
  name = ''
}

export class UpdateTwitterListDto {
  @ApiProperty()
  @IsBoolean()
  isActive: boolean;
}
