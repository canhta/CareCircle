import '../../../common/common.dart';
import 'subscription_models.dart';

/// Repository interface for subscription operations
abstract class SubscriptionRepository {
  /// Get available subscription plans
  Future<Result<List<SubscriptionPlan>>> getAvailablePlans();

  /// Get current user subscription
  Future<Result<UserSubscription?>> getCurrentSubscription();

  /// Subscribe to a plan
  Future<Result<UserSubscription>> subscribeToPlan(String planId);

  /// Cancel current subscription
  Future<Result<void>> cancelSubscription();

  /// Update auto-renewal setting
  Future<Result<void>> updateAutoRenewal(bool autoRenew);

  /// Get subscription usage
  Future<Result<SubscriptionUsage>> getSubscriptionUsage();

  /// Get payment history
  Future<Result<List<PaymentHistory>>> getPaymentHistory({
    int page = 1,
    int limit = 20,
  });

  /// Restore purchases (for mobile)
  Future<Result<void>> restorePurchases();

  /// Verify purchase receipt
  Future<Result<bool>> verifyPurchase(String receiptData);

  /// Get subscription features
  Future<Result<List<String>>> getSubscriptionFeatures(String planId);

  /// Check if feature is available
  Future<Result<bool>> isFeatureAvailable(String featureId);

  /// Get subscription analytics
  Future<Result<Map<String, dynamic>>> getSubscriptionAnalytics();
}

/// Repository interface for in-app purchases
abstract class InAppPurchaseRepository {
  /// Initialize in-app purchases
  Future<Result<bool>> initialize();

  /// Get available products
  Future<Result<List<dynamic>>> getProducts();

  /// Purchase a product
  Future<Result<PurchaseResult>> purchaseProduct(String productId);

  /// Restore purchases
  Future<Result<void>> restorePurchases();

  /// Check if purchases are available
  Future<Result<bool>> isPurchaseAvailable();

  /// Dispose resources
  Future<Result<void>> dispose();
}
