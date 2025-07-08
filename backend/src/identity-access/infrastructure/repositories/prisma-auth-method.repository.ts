import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { AuthMethodRepository } from '../../domain/repositories/auth-method.repository';
import { AuthMethod } from '../../domain/entities/user.entity';
import { AuthMethodType } from '@prisma/client';

@Injectable()
export class PrismaAuthMethodRepository implements AuthMethodRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findByUserId(userId: string): Promise<AuthMethod[]> {
    const authMethods = await this.prisma.authMethod.findMany({
      where: { userId },
    });

    return authMethods.map(
      (method) =>
        new AuthMethod(
          method.id,
          method.userId,
          method.type,
          method.identifier,
          method.isVerified,
          method.lastUsed,
          method.createdAt,
        ),
    );
  }

  async findByUserIdAndType(
    userId: string,
    type: AuthMethodType,
  ): Promise<AuthMethod | null> {
    const method = await this.prisma.authMethod.findFirst({
      where: { userId, type },
    });

    if (!method) return null;

    return new AuthMethod(
      method.id,
      method.userId,
      method.type,
      method.identifier,
      method.isVerified,
      method.lastUsed,
      method.createdAt,
    );
  }

  async findByIdentifier(
    type: AuthMethodType,
    identifier: string,
  ): Promise<AuthMethod | null> {
    const method = await this.prisma.authMethod.findFirst({
      where: { type, identifier },
    });

    if (!method) return null;

    return new AuthMethod(
      method.id,
      method.userId,
      method.type,
      method.identifier,
      method.isVerified,
      method.lastUsed,
      method.createdAt,
    );
  }

  async create(authMethod: AuthMethod): Promise<AuthMethod> {
    const created = await this.prisma.authMethod.create({
      data: {
        id: authMethod.id,
        userId: authMethod.userId,
        type: authMethod.type,
        identifier: authMethod.identifier,
        isVerified: authMethod.isVerified,
        lastUsed: authMethod.lastUsed,
      },
    });

    return new AuthMethod(
      created.id,
      created.userId,
      created.type,
      created.identifier,
      created.isVerified,
      created.lastUsed,
      created.createdAt,
    );
  }

  async update(id: string, updates: Partial<AuthMethod>): Promise<AuthMethod> {
    const updated = await this.prisma.authMethod.update({
      where: { id },
      data: {
        isVerified: updates.isVerified,
        lastUsed: updates.lastUsed,
      },
    });

    return new AuthMethod(
      updated.id,
      updated.userId,
      updated.type,
      updated.identifier,
      updated.isVerified,
      updated.lastUsed,
      updated.createdAt,
    );
  }

  async delete(id: string): Promise<void> {
    await this.prisma.authMethod.delete({
      where: { id },
    });
  }

  async deleteByUserId(userId: string): Promise<void> {
    await this.prisma.authMethod.deleteMany({
      where: { userId },
    });
  }
}
