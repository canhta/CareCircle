import { Injectable, Inject } from '@nestjs/common';
import { HealthDevice } from '../../domain/entities/health-device.entity';
import { DeviceType, ConnectionStatus } from '@prisma/client';
import {
  HealthDeviceRepository,
  DeviceQuery,
} from '../../domain/repositories/health-device.repository';

@Injectable()
export class HealthDeviceService {
  constructor(
    @Inject('HealthDeviceRepository')
    private readonly healthDeviceRepository: HealthDeviceRepository,
  ) {}

  async registerDevice(data: {
    userId: string;
    deviceType: DeviceType;
    manufacturer: string;
    model: string;
    serialNumber?: string;
    batteryLevel?: number;
    firmware?: string;
    settings?: Record<string, any>;
  }): Promise<HealthDevice> {
    const device = HealthDevice.create({
      id: this.generateId(),
      ...data,
    });

    return this.healthDeviceRepository.create(device);
  }

  async getDevice(id: string): Promise<HealthDevice | null> {
    return this.healthDeviceRepository.findById(id);
  }

  async getUserDevices(userId: string): Promise<HealthDevice[]> {
    return this.healthDeviceRepository.findByUserId(userId);
  }

  async getDevices(query: DeviceQuery): Promise<HealthDevice[]> {
    return this.healthDeviceRepository.findMany(query);
  }

  async connectDevice(id: string): Promise<HealthDevice> {
    const device = await this.healthDeviceRepository.findById(id);
    if (!device) {
      throw new Error('Device not found');
    }

    return this.healthDeviceRepository.updateConnectionStatus(
      id,
      ConnectionStatus.CONNECTED,
    );
  }

  async disconnectDevice(id: string): Promise<HealthDevice> {
    const device = await this.healthDeviceRepository.findById(id);
    if (!device) {
      throw new Error('Device not found');
    }

    return this.healthDeviceRepository.updateConnectionStatus(
      id,
      ConnectionStatus.DISCONNECTED,
    );
  }

  async startPairing(id: string): Promise<HealthDevice> {
    const device = await this.healthDeviceRepository.findById(id);
    if (!device) {
      throw new Error('Device not found');
    }

    return this.healthDeviceRepository.updateConnectionStatus(
      id,
      ConnectionStatus.SYNCING,
    );
  }

  async setDeviceError(id: string): Promise<HealthDevice> {
    const device = await this.healthDeviceRepository.findById(id);
    if (!device) {
      throw new Error('Device not found');
    }

    return this.healthDeviceRepository.updateConnectionStatus(
      id,
      ConnectionStatus.ERROR,
    );
  }

  async updateBatteryLevel(id: string, level: number): Promise<HealthDevice> {
    return this.healthDeviceRepository.updateBatteryLevel(id, level);
  }

  async updateSettings(
    id: string,
    settings: Record<string, any>,
  ): Promise<HealthDevice> {
    return this.healthDeviceRepository.updateSettings(id, settings);
  }

  async syncDevice(id: string): Promise<HealthDevice> {
    return this.healthDeviceRepository.updateLastSync(id, new Date());
  }

  async getConnectedDevices(userId: string): Promise<HealthDevice[]> {
    return this.healthDeviceRepository.getConnectedDevices(userId);
  }

  async getDisconnectedDevices(userId: string): Promise<HealthDevice[]> {
    return this.healthDeviceRepository.getDisconnectedDevices(userId);
  }

  async getDevicesWithErrors(userId: string): Promise<HealthDevice[]> {
    return this.healthDeviceRepository.getDevicesWithErrors(userId);
  }

  async getLowBatteryDevices(userId: string): Promise<HealthDevice[]> {
    return this.healthDeviceRepository.getLowBatteryDevices(userId);
  }

  async getDevicesNeedingSync(
    userId: string,
    hoursThreshold: number = 24,
  ): Promise<HealthDevice[]> {
    return this.healthDeviceRepository.getDevicesNeedingSync(
      userId,
      hoursThreshold,
    );
  }

  async deleteDevice(id: string): Promise<void> {
    return this.healthDeviceRepository.delete(id);
  }

  async getDeviceCount(userId: string): Promise<number> {
    return this.healthDeviceRepository.getDeviceCount(userId);
  }

  async getConnectedDeviceCount(userId: string): Promise<number> {
    return this.healthDeviceRepository.getConnectedDeviceCount(userId);
  }

  async getDeviceStatus(userId: string): Promise<{
    total: number;
    connected: number;
    disconnected: number;
    errors: number;
    lowBattery: number;
    needingSync: number;
  }> {
    const [
      total,
      connected,
      _connectedDevices,
      disconnectedDevices,
      errorDevices,
      lowBatteryDevices,
      needingSyncDevices,
    ] = await Promise.all([
      this.getDeviceCount(userId),
      this.getConnectedDeviceCount(userId),
      this.getConnectedDevices(userId),
      this.getDisconnectedDevices(userId),
      this.getDevicesWithErrors(userId),
      this.getLowBatteryDevices(userId),
      this.getDevicesNeedingSync(userId),
    ]);

    return {
      total,
      connected,
      disconnected: disconnectedDevices.length,
      errors: errorDevices.length,
      lowBattery: lowBatteryDevices.length,
      needingSync: needingSyncDevices.length,
    };
  }

  private generateId(): string {
    return `hd_${Date.now()}_${Math.random().toString(36).substring(2, 11)}`;
  }
}
