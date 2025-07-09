import { HealthDevice } from '../entities/health-device.entity';
import { DeviceType, ConnectionStatus } from '@prisma/client';

export interface DeviceQuery {
  userId: string;
  deviceType?: DeviceType;
  connectionStatus?: ConnectionStatus;
  manufacturer?: string;
  limit?: number;
  offset?: number;
}

export abstract class HealthDeviceRepository {
  abstract create(device: HealthDevice): Promise<HealthDevice>;
  abstract findById(id: string): Promise<HealthDevice | null>;
  abstract findMany(query: DeviceQuery): Promise<HealthDevice[]>;
  abstract findByUserId(userId: string): Promise<HealthDevice[]>;
  abstract update(
    id: string,
    updates: Partial<HealthDevice>,
  ): Promise<HealthDevice>;
  abstract delete(id: string): Promise<void>;

  // Connection operations
  abstract updateConnectionStatus(
    id: string,
    status: ConnectionStatus,
  ): Promise<HealthDevice>;
  abstract getConnectedDevices(userId: string): Promise<HealthDevice[]>;
  abstract getDisconnectedDevices(userId: string): Promise<HealthDevice[]>;
  abstract getDevicesWithErrors(userId: string): Promise<HealthDevice[]>;

  // Sync operations
  abstract updateLastSync(id: string, timestamp: Date): Promise<HealthDevice>;
  abstract getDevicesNeedingSync(
    userId: string,
    hoursThreshold: number,
  ): Promise<HealthDevice[]>;

  // Battery operations
  abstract updateBatteryLevel(id: string, level: number): Promise<HealthDevice>;
  abstract getLowBatteryDevices(userId: string): Promise<HealthDevice[]>;

  // Settings operations
  abstract updateSettings(
    id: string,
    settings: Record<string, any>,
  ): Promise<HealthDevice>;

  // Query operations
  abstract findBySerialNumber(
    serialNumber: string,
  ): Promise<HealthDevice | null>;
  abstract findByType(
    userId: string,
    deviceType: DeviceType,
  ): Promise<HealthDevice[]>;
  abstract findByManufacturer(
    userId: string,
    manufacturer: string,
  ): Promise<HealthDevice[]>;

  // Count operations
  abstract getDeviceCount(userId: string): Promise<number>;
  abstract getConnectedDeviceCount(userId: string): Promise<number>;
}
