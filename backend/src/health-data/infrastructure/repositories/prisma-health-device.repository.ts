import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { HealthDevice } from '../../domain/entities/health-device.entity';
import {
  HealthDevice as PrismaHealthDevice,
  DeviceType,
  ConnectionStatus,
} from '@prisma/client';
import {
  HealthDeviceRepository,
  DeviceQuery,
} from '../../domain/repositories/health-device.repository';

@Injectable()
export class PrismaHealthDeviceRepository extends HealthDeviceRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async create(device: HealthDevice): Promise<HealthDevice> {
    const data = await this.prisma.healthDevice.create({
      data: {
        id: device.id,
        userId: device.userId,
        deviceType: device.deviceType,
        manufacturer: device.manufacturer,
        model: device.model,
        serialNumber: device.serialNumber,
        lastSyncTimestamp: device.lastSyncTimestamp,
        connectionStatus: device.connectionStatus,
        batteryLevel: device.batteryLevel,
        firmware: device.firmware,
        settings: device.settings,
        createdAt: device.createdAt,
        updatedAt: device.updatedAt,
      },
    });

    return this.mapToEntity(data);
  }

  async findById(id: string): Promise<HealthDevice | null> {
    const data = await this.prisma.healthDevice.findUnique({
      where: { id },
    });

    return data ? this.mapToEntity(data) : null;
  }

  async findMany(query: DeviceQuery): Promise<HealthDevice[]> {
    const where: {
      userId: string;
      deviceType?: DeviceType;
      connectionStatus?: ConnectionStatus;
      manufacturer?: string;
    } = {
      userId: query.userId,
    };

    if (query.deviceType) where.deviceType = query.deviceType;
    if (query.connectionStatus) where.connectionStatus = query.connectionStatus;
    if (query.manufacturer) where.manufacturer = query.manufacturer;

    const data = await this.prisma.healthDevice.findMany({
      where,
      orderBy: { createdAt: 'desc' },
      take: query.limit,
      skip: query.offset,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByUserId(userId: string): Promise<HealthDevice[]> {
    const data = await this.prisma.healthDevice.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async update(
    id: string,
    updates: Partial<HealthDevice>,
  ): Promise<HealthDevice> {
    const data = await this.prisma.healthDevice.update({
      where: { id },
      data: {
        ...(updates.connectionStatus && {
          connectionStatus: updates.connectionStatus,
        }),
        ...(updates.batteryLevel !== undefined && {
          batteryLevel: updates.batteryLevel,
        }),
        ...(updates.firmware && { firmware: updates.firmware }),
        ...(updates.settings && {
          settings: updates.settings,
        }),
        ...(updates.lastSyncTimestamp && {
          lastSyncTimestamp: updates.lastSyncTimestamp,
        }),
        updatedAt: new Date(),
      },
    });

    return this.mapToEntity(data);
  }

  async delete(id: string): Promise<void> {
    await this.prisma.healthDevice.delete({
      where: { id },
    });
  }

  async updateConnectionStatus(
    id: string,
    status: ConnectionStatus,
  ): Promise<HealthDevice> {
    const data = await this.prisma.healthDevice.update({
      where: { id },
      data: {
        connectionStatus: status,
        updatedAt: new Date(),
      },
    });

    return this.mapToEntity(data);
  }

  async getConnectedDevices(userId: string): Promise<HealthDevice[]> {
    const data = await this.prisma.healthDevice.findMany({
      where: {
        userId,
        connectionStatus: ConnectionStatus.CONNECTED,
      },
      orderBy: { lastSyncTimestamp: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async getDisconnectedDevices(userId: string): Promise<HealthDevice[]> {
    const data = await this.prisma.healthDevice.findMany({
      where: {
        userId,
        connectionStatus: ConnectionStatus.DISCONNECTED,
      },
      orderBy: { updatedAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async getDevicesWithErrors(userId: string): Promise<HealthDevice[]> {
    const data = await this.prisma.healthDevice.findMany({
      where: {
        userId,
        connectionStatus: ConnectionStatus.ERROR,
      },
      orderBy: { updatedAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async updateLastSync(id: string, timestamp: Date): Promise<HealthDevice> {
    const data = await this.prisma.healthDevice.update({
      where: { id },
      data: {
        lastSyncTimestamp: timestamp,
        updatedAt: new Date(),
      },
    });

    return this.mapToEntity(data);
  }

  async getDevicesNeedingSync(
    userId: string,
    hoursThreshold: number,
  ): Promise<HealthDevice[]> {
    const thresholdDate = new Date();
    thresholdDate.setHours(thresholdDate.getHours() - hoursThreshold);

    const data = await this.prisma.healthDevice.findMany({
      where: {
        userId,
        lastSyncTimestamp: {
          lt: thresholdDate,
        },
      },
      orderBy: { lastSyncTimestamp: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async updateBatteryLevel(id: string, level: number): Promise<HealthDevice> {
    const data = await this.prisma.healthDevice.update({
      where: { id },
      data: {
        batteryLevel: level,
        updatedAt: new Date(),
      },
    });

    return this.mapToEntity(data);
  }

  async getLowBatteryDevices(userId: string): Promise<HealthDevice[]> {
    const data = await this.prisma.healthDevice.findMany({
      where: {
        userId,
        batteryLevel: {
          lt: 30,
          not: null,
        },
      },
      orderBy: { batteryLevel: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async updateSettings(
    id: string,
    settings: Record<string, any>,
  ): Promise<HealthDevice> {
    const data = await this.prisma.healthDevice.update({
      where: { id },
      data: {
        settings,
        updatedAt: new Date(),
      },
    });

    return this.mapToEntity(data);
  }

  async findBySerialNumber(serialNumber: string): Promise<HealthDevice | null> {
    const data = await this.prisma.healthDevice.findFirst({
      where: { serialNumber },
    });

    return data ? this.mapToEntity(data) : null;
  }

  async findByType(
    userId: string,
    deviceType: DeviceType,
  ): Promise<HealthDevice[]> {
    const data = await this.prisma.healthDevice.findMany({
      where: {
        userId,
        deviceType: deviceType,
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByManufacturer(
    userId: string,
    manufacturer: string,
  ): Promise<HealthDevice[]> {
    const data = await this.prisma.healthDevice.findMany({
      where: {
        userId,
        manufacturer,
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async getDeviceCount(userId: string): Promise<number> {
    return this.prisma.healthDevice.count({
      where: { userId },
    });
  }

  async getConnectedDeviceCount(userId: string): Promise<number> {
    return this.prisma.healthDevice.count({
      where: {
        userId,
        connectionStatus: ConnectionStatus.CONNECTED,
      },
    });
  }

  private mapToEntity(data: PrismaHealthDevice): HealthDevice {
    return new HealthDevice(
      data.id,
      data.userId,
      data.deviceType,
      data.manufacturer,
      data.model,
      data.serialNumber,
      data.lastSyncTimestamp,
      data.connectionStatus,
      data.batteryLevel,
      data.firmware,
      data.settings as Record<string, any>,
      data.createdAt,
      data.updatedAt,
    );
  }
}
