import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto, UpdateUserDto } from './dto';

@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  async create(@Body() createUserDto: CreateUserDto) {
    return await this.userService.createUser(createUserDto);
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    return await this.userService.findUserById(id);
  }

  @Get(':id/profile')
  async getProfile(@Param('id') id: string) {
    return await this.userService.getUserProfile(id);
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return await this.userService.updateUser(id, updateUserDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async remove(@Param('id') id: string) {
    await this.userService.deleteUser(id);
  }

  @Patch(':id/verify-email')
  async verifyEmail(@Param('id') id: string) {
    return await this.userService.verifyEmail(id);
  }

  @Patch(':id/deactivate')
  async deactivate(@Param('id') id: string) {
    return await this.userService.deactivateUser(id);
  }
}
