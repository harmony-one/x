import { IsNotEmpty, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

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