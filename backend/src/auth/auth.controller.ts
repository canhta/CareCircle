import { Controller, Post, Body, HttpCode, HttpStatus } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto, LoginDto } from './dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  async register(@Body() registerDto: RegisterDto) {
    return await this.authService.register(registerDto);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(@Body() loginDto: LoginDto) {
    const user = await this.authService.validateUser(
      loginDto.email,
      loginDto.password,
    );
    if (!user) {
      throw new Error('Invalid credentials');
    }
    return await this.authService.login(user);
  }

  @Post('google')
  @HttpCode(HttpStatus.OK)
  async googleLogin(
    @Body()
    googleUser: {
      email: string;
      firstName: string;
      lastName: string;
      picture?: string;
      googleId: string;
    },
  ) {
    return await this.authService.googleLogin(googleUser);
  }

  @Post('apple')
  @HttpCode(HttpStatus.OK)
  async appleLogin(
    @Body()
    appleUser: {
      email: string;
      firstName?: string;
      lastName?: string;
      appleId: string;
    },
  ) {
    return await this.authService.appleLogin(appleUser);
  }
}
