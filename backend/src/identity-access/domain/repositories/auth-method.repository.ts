import { AuthMethod } from '../entities/user.entity';
import { AuthMethodType } from '@prisma/client';

export abstract class AuthMethodRepository {
  abstract findByUserId(userId: string): Promise<AuthMethod[]>;
  abstract findByUserIdAndType(
    userId: string,
    type: AuthMethodType,
  ): Promise<AuthMethod | null>;
  abstract findByIdentifier(
    type: AuthMethodType,
    identifier: string,
  ): Promise<AuthMethod | null>;
  abstract create(authMethod: AuthMethod): Promise<AuthMethod>;
  abstract update(
    id: string,
    updates: Partial<AuthMethod>,
  ): Promise<AuthMethod>;
  abstract delete(id: string): Promise<void>;
  abstract deleteByUserId(userId: string): Promise<void>;
}
