import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  Request,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { HealthDeviceService } from '../../application/services/health-device.service';
import { DeviceType } from '@prisma/client';
import { FirebaseUserPayload } from 'src/identity-access/presentation/guards/firebase-auth.guard';

@Controller('health-data/devices')
export class HealthDeviceController {
  constructor(private readonly healthDeviceService: HealthDeviceService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  async registerDevice(
    @Body()
    deviceDto: {
      deviceType: DeviceType;
      manufacturer: string;
      model: string;
      serialNumber?: string;
      batteryLevel?: number;
      firmware?: string;
      settings?: Record<string, any>;
    },
    @Request() req: { user: FirebaseUserPayload },
  ) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    return this.healthDeviceService.registerDevice({
      userId,
      ...deviceDto,
    });
  }

  @Get()
  async getDevices(
    @Request() req: { user: FirebaseUserPayload },
    @Query('deviceType') deviceType?: DeviceType,
    @Query('manufacturer') manufacturer?: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }

    return this.healthDeviceService.getDevices({
      userId,
      deviceType,
      manufacturer,
      limit: limit ? parseInt(limit) : undefined,
      offset: offset ? parseInt(offset) : undefined,
    });
  }

  @Get('me')
  async getMyDevices(@Request() req: { user: FirebaseUserPayload }) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    return this.healthDeviceService.getUserDevices(userId);
  }

  @Get('connected')
  async getConnectedDevices(@Request() req: { user: FirebaseUserPayload }) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    return this.healthDeviceService.getConnectedDevices(userId);
  }

  @Get('disconnected')
  async getDisconnectedDevices(@Request() req: { user: FirebaseUserPayload }) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    return this.healthDeviceService.getDisconnectedDevices(userId);
  }

  @Get('errors')
  async getDevicesWithErrors(@Request() req: { user: FirebaseUserPayload }) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    return this.healthDeviceService.getDevicesWithErrors(userId);
  }

  @Get('low-battery')
  async getLowBatteryDevices(@Request() req: { user: FirebaseUserPayload }) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    return this.healthDeviceService.getLowBatteryDevices(userId);
  }

  @Get('needing-sync')
  async getDevicesNeedingSync(
    @Request() req: { user: FirebaseUserPayload },
    @Query('hours') hours?: string,
  ) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    const hoursThreshold = hours ? parseInt(hours) : 24;

    return this.healthDeviceService.getDevicesNeedingSync(
      userId,
      hoursThreshold,
    );
  }

  @Get('status')
  async getDeviceStatus(@Request() req: { user: FirebaseUserPayload }) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    return this.healthDeviceService.getDeviceStatus(userId);
  }

  @Get('count')
  async getDeviceCount(@Request() req: { user: FirebaseUserPayload }) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    return this.healthDeviceService.getDeviceCount(userId);
  }

  @Get(':id')
  async getDevice(@Param('id') id: string) {
    return this.healthDeviceService.getDevice(id);
  }

  @Put(':id/connect')
  async connectDevice(@Param('id') id: string) {
    return this.healthDeviceService.connectDevice(id);
  }

  @Put(':id/disconnect')
  async disconnectDevice(@Param('id') id: string) {
    return this.healthDeviceService.disconnectDevice(id);
  }

  @Put(':id/pair')
  async startPairing(@Param('id') id: string) {
    return this.healthDeviceService.startPairing(id);
  }

  @Put(':id/error')
  async setDeviceError(@Param('id') id: string) {
    return this.healthDeviceService.setDeviceError(id);
  }

  @Put(':id/battery')
  async updateBatteryLevel(
    @Param('id') id: string,
    @Body() batteryDto: { level: number },
  ) {
    return this.healthDeviceService.updateBatteryLevel(id, batteryDto.level);
  }

  @Put(':id/settings')
  async updateSettings(
    @Param('id') id: string,
    @Body() settingsDto: { settings: Record<string, any> },
  ) {
    return this.healthDeviceService.updateSettings(id, settingsDto.settings);
  }

  @Put(':id/sync')
  async syncDevice(@Param('id') id: string) {
    return this.healthDeviceService.syncDevice(id);
  }

  @Delete(':id')
  async deleteDevice(@Param('id') id: string) {
    return this.healthDeviceService.deleteDevice(id);
  }
}
