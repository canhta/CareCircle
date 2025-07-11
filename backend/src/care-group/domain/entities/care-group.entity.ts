import { CareGroup as PrismaCareGroup } from '@prisma/client';

/**
 * Simplified Care Group Entity matching actual Prisma schema
 */
export class CareGroupEntity {
  constructor(
    public readonly id: string,
    public readonly name: string,
    public readonly description: string | null,
    public readonly createdBy: string,
    public readonly isActive: boolean,
    public readonly settings: Record<string, any>,
    public readonly inviteCode: string | null,
    public readonly inviteExpiration: Date | null,
    public readonly createdAt: Date,
    public readonly updatedAt: Date,
  ) {}

  static create(data: {
    name: string;
    description?: string;
    createdBy: string;
    settings?: Record<string, any>;
    inviteCode?: string;
    inviteExpiration?: Date;
  }) {
    return {
      name: data.name.trim(),
      description: data.description?.trim() || null,
      createdBy: data.createdBy,
      isActive: true,
      settings: data.settings || {},
      inviteCode: data.inviteCode || null,
      inviteExpiration: data.inviteExpiration || null,
    };
  }

  static fromPrisma(prisma: PrismaCareGroup): CareGroupEntity {
    return new CareGroupEntity(
      prisma.id,
      prisma.name,
      prisma.description,
      prisma.createdBy,
      prisma.isActive,
      prisma.settings as Record<string, any>,
      prisma.inviteCode,
      prisma.inviteExpiration,
      prisma.createdAt,
      prisma.updatedAt,
    );
  }

  toPrisma(): Omit<PrismaCareGroup, 'id' | 'createdAt' | 'updatedAt'> {
    return {
      name: this.name,
      description: this.description,
      createdBy: this.createdBy,
      isActive: this.isActive,
      settings: this.settings as any,
      inviteCode: this.inviteCode,
      inviteExpiration: this.inviteExpiration,
    };
  }

  update(data: {
    name?: string;
    description?: string;
    isActive?: boolean;
    settings?: Record<string, any>;
    inviteCode?: string;
    inviteExpiration?: Date;
  }): CareGroupEntity {
    return new CareGroupEntity(
      this.id,
      data.name?.trim() ?? this.name,
      data.description?.trim() ?? this.description,
      this.createdBy,
      data.isActive ?? this.isActive,
      data.settings ?? this.settings,
      data.inviteCode ?? this.inviteCode,
      data.inviteExpiration ?? this.inviteExpiration,
      this.createdAt,
      new Date(),
    );
  }

  isCreatedBy(userId: string): boolean {
    return this.createdBy === userId;
  }

  isActiveGroup(): boolean {
    return this.isActive;
  }

  canAcceptNewMembers(): boolean {
    return this.isActive;
  }

  getMaxAllowedMembers(): number {
    return 50; // Default limit
  }

  toJSON(): Record<string, any> {
    return {
      id: this.id,
      name: this.name,
      description: this.description,
      createdBy: this.createdBy,
      isActive: this.isActive,
      settings: this.settings,
      inviteCode: this.inviteCode,
      inviteExpiration: this.inviteExpiration?.toISOString() || null,
      createdAt: this.createdAt.toISOString(),
      updatedAt: this.updatedAt.toISOString(),
    };
  }
}
