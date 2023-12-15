import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';
import { Type } from 'class-transformer';

export class GetListTweetsDto {
  @ApiProperty({ type: String, required: true })
  @IsString()
  name = ''
}
