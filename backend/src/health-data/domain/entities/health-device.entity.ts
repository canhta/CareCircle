import { DeviceType, ConnectionStatus } from '@prisma/client';

export class HealthDevice {
  constructor(
    public readonly id: string,
    public readonly userId: string,
    public readonly deviceType: DeviceType,
    public readonly manufacturer: string,
    public readonly model: string,
    public readonly serialNumber: string | null,
    public lastSyncTimestamp: Date,
    public connectionStatus: ConnectionStatus,
    public batteryLevel: number | null,
    public firmware: string | null,
    public settings: Record<string, any>,
    public readonly createdAt: Date,
    public updatedAt: Date,
  ) {}

  static create(data: {
    id: string;
    userId: string;
    deviceType: DeviceType;
    manufacturer: string;
    model: string;
    serialNumber?: string;
    batteryLevel?: number;
    firmware?: string;
    settings?: Record<string, any>;
  }): HealthDevice {
    return new HealthDevice(
      data.id,
      data.userId,
      data.deviceType,
      data.manufacturer,
      data.model,
      data.serialNumber || null,
      new Date(),
      ConnectionStatus.DISCONNECTED,
      data.batteryLevel || null,
      data.firmware || null,
      data.settings || {},
      new Date(),
      new Date(),
    );
  }

  connect(): void {
    this.connectionStatus = ConnectionStatus.CONNECTED;
    this.updatedAt = new Date();
  }

  disconnect(): void {
    this.connectionStatus = ConnectionStatus.DISCONNECTED;
    this.updatedAt = new Date();
  }

  startPairing(): void {
    this.connectionStatus = ConnectionStatus.SYNCING;
    this.updatedAt = new Date();
  }

  setError(): void {
    this.connectionStatus = ConnectionStatus.ERROR;
    this.updatedAt = new Date();
  }

  updateBatteryLevel(level: number): void {
    this.batteryLevel = level;
    this.updatedAt = new Date();
  }

  updateFirmware(version: string): void {
    this.firmware = version;
    this.updatedAt = new Date();
  }

  updateSettings(newSettings: Record<string, any>): void {
    this.settings = { ...this.settings, ...newSettings };
    this.updatedAt = new Date();
  }

  sync(): void {
    this.lastSyncTimestamp = new Date();
    this.updatedAt = new Date();
  }

  isConnected(): boolean {
    return this.connectionStatus === ConnectionStatus.CONNECTED;
  }

  isPairing(): boolean {
    return this.connectionStatus === ConnectionStatus.SYNCING;
  }

  hasError(): boolean {
    return this.connectionStatus === ConnectionStatus.ERROR;
  }

  needsBatteryReplacement(): boolean {
    return this.batteryLevel !== null && this.batteryLevel < 20;
  }

  isLowBattery(): boolean {
    return this.batteryLevel !== null && this.batteryLevel < 30;
  }

  getLastSyncAge(): number {
    const now = new Date();
    return now.getTime() - this.lastSyncTimestamp.getTime();
  }

  isRecentlySync(hoursThreshold: number = 24): boolean {
    const ageInHours = this.getLastSyncAge() / (1000 * 60 * 60);
    return ageInHours <= hoursThreshold;
  }

  getDisplayName(): string {
    return `${this.manufacturer} ${this.model}`;
  }

  getSupportedMetrics(): string[] {
    switch (this.deviceType) {
      case DeviceType.SMARTWATCH: {
        return ['heart_rate', 'steps', 'activity', 'sleep'];
      }
      case DeviceType.FITNESS_TRACKER: {
        return ['steps', 'activity', 'sleep', 'heart_rate'];
      }
      case DeviceType.BLOOD_PRESSURE_MONITOR: {
        return ['blood_pressure'];
      }
      case DeviceType.GLUCOSE_METER: {
        return ['blood_glucose'];
      }
      case DeviceType.PULSE_OXIMETER: {
        return ['blood_oxygen', 'heart_rate'];
      }
      case DeviceType.SCALE: {
        return ['weight'];
      }
      case DeviceType.THERMOMETER: {
        return ['body_temperature'];
      }
      default:
        return [];
    }
  }
}
