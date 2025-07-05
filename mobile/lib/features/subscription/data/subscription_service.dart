import 'package:carecircle/common/common.dart';
import 'package:carecircle/features/subscription/domain/subscription_models.dart';
import 'package:carecircle/features/subscription/domain/subscription_repository.dart';

/// Service implementation for subscription management
class SubscriptionService extends BaseRepository
    implements SubscriptionRepository {
  SubscriptionService({
    required super.apiClient,
    required super.logger,
  });

  @override
  Future<Result<List<SubscriptionPlan>>> getAvailablePlans() async {
    return await get<List<SubscriptionPlan>>(
      ApiEndpoints.subscriptionPlans,
      fromJson: (json) => (json as List)
          .map((plan) => SubscriptionPlan.fromJson(plan))
          .toList(),
    );
  }

  @override
  Future<Result<UserSubscription?>> getCurrentSubscription() async {
    return await get<UserSubscription?>(
      ApiEndpoints.userSubscription,
      fromJson: (json) => json != null ? UserSubscription.fromJson(json) : null,
    );
  }

  @override
  Future<Result<UserSubscription>> subscribeToPlan(String planId) async {
    return await post<UserSubscription>(
      ApiEndpoints.subscribeToplan,
      data: {'planId': planId},
      fromJson: (json) => UserSubscription.fromJson(json),
    );
  }

  @override
  Future<Result<void>> cancelSubscription() async {
    return await delete(
      ApiEndpoints.cancelSubscription,
    );
  }

  @override
  Future<Result<void>> updateAutoRenewal(bool autoRenew) async {
    return await put(
      ApiEndpoints.updateAutoRenewal,
      data: {'autoRenew': autoRenew},
    );
  }

  @override
  Future<Result<SubscriptionUsage>> getSubscriptionUsage() async {
    return await get<SubscriptionUsage>(
      ApiEndpoints.subscriptionUsage,
      fromJson: (json) => SubscriptionUsage.fromJson(json),
    );
  }

  @override
  Future<Result<List<PaymentHistory>>> getPaymentHistory({
    int page = 1,
    int limit = 20,
  }) async {
    final endpoint = ApiEndpoints.buildPaginatedUrl(
      ApiEndpoints.paymentHistory,
      page: page,
      limit: limit,
    );

    return await get<List<PaymentHistory>>(
      endpoint,
      fromJson: (json) => (json as List)
          .map((history) => PaymentHistory.fromJson(history))
          .toList(),
    );
  }

  @override
  Future<Result<void>> restorePurchases() async {
    return await post(
      ApiEndpoints.restorePurchases,
    );
  }

  @override
  Future<Result<bool>> verifyPurchase(String receiptData) async {
    return await post<bool>(
      ApiEndpoints.verifyPurchase,
      data: {'receiptData': receiptData},
      fromJson: (json) => json['verified'] as bool,
    );
  }

  @override
  Future<Result<List<String>>> getSubscriptionFeatures(String planId) async {
    final endpoint = ApiEndpoints.replacePathParams(
      ApiEndpoints.subscriptionFeatures,
      {'planId': planId},
    );

    return await get<List<String>>(
      endpoint,
      fromJson: (json) => List<String>.from(json['features'] as List),
    );
  }

  @override
  Future<Result<bool>> isFeatureAvailable(String featureId) async {
    final endpoint = ApiEndpoints.replacePathParams(
      ApiEndpoints.checkFeatureAvailability,
      {'featureId': featureId},
    );

    return await get<bool>(
      endpoint,
      fromJson: (json) => json['available'] as bool,
    );
  }

  @override
  Future<Result<Map<String, dynamic>>> getSubscriptionAnalytics() async {
    return await get<Map<String, dynamic>>(
      ApiEndpoints.subscriptionAnalytics,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }
}
