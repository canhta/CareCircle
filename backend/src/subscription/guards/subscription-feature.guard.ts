import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  SetMetadata,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { SubscriptionService } from '../subscription.service';

export const RequireSubscriptionFeature = (...features: string[]) =>
  SetMetadata('requiredFeatures', features);

@Injectable()
export class SubscriptionFeatureGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly subscriptionService: SubscriptionService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    // Get the required features from the route metadata
    const requiredFeatures = this.reflector.get<string[]>(
      'requiredFeatures',
      context.getHandler(),
    );

    // If no features are required, allow access
    if (!requiredFeatures || requiredFeatures.length === 0) {
      return true;
    }

    // Get the user from the request
    const request = context.switchToHttp().getRequest();
    const userId = request.user?.id;

    // If no user ID is available, deny access
    if (!userId) {
      throw new ForbiddenException('Authentication required for this feature');
    }

    // Check if the user has access to all required features
    for (const feature of requiredFeatures) {
      const hasAccess = await this.subscriptionService.hasFeatureAccess(
        userId,
        feature,
      );

      if (!hasAccess) {
        throw new ForbiddenException(
          `Your subscription does not include access to this feature: ${feature}`,
        );
      }
    }

    return true;
  }
}
