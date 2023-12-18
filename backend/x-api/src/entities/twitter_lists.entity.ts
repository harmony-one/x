import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryGeneratedColumn,
  Unique,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsString } from 'class-validator';

@Entity({ name: 'twitter_lists' })
export class TwitterListsEntity {
  @ApiProperty()
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty()
  @IsString()
  @Column({
    type: 'varchar',
    default: '',
    unique: true
  })
  listId: string;

  @ApiProperty()
  @IsString()
  @Column({
    type: 'varchar',
    default: '',
  })
  name: string;

  @ApiProperty()
  @IsBoolean()
  @Column({
    type: 'boolean',
    default: true,
  })
  isActive: boolean;

  @ApiProperty()
  @CreateDateColumn({ name: 'createdAt' })
  createdAt: Date;
}
