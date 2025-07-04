import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../logging_service.dart';

class InAppPurchaseService {
  static final InAppPurchaseService _instance =
      InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;
  InAppPurchaseService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final LoggingService _logger = LoggingService();
  late StreamSubscription<List<PurchaseDetails>> _purchaseUpdatedSubscription;

  // Product IDs for different subscription tiers
  static const String basicMonthlyId = 'basic_monthly';
  static const String premiumMonthlyId = 'premium_monthly';
  static const String basicYearlyId = 'basic_yearly';
  static const String premiumYearlyId = 'premium_yearly';

  static const List<String> _productIds = [
    basicMonthlyId,
    premiumMonthlyId,
    basicYearlyId,
    premiumYearlyId,
  ];

  // Available products
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  // Purchase status
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Purchase callbacks
  Function(PurchaseDetails)? onPurchaseSuccess;
  Function(PurchaseDetails)? onPurchaseError;
  Function(PurchaseDetails)? onPurchaseCancelled;

  /// Initialize the in-app purchase service
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Check if the service is available
      final bool isAvailable = await _inAppPurchase.isAvailable();
      if (!isAvailable) {
        _logger.warning('In-app purchases are not available');
        return false;
      }

      // Enable pending purchases on Android
      if (Platform.isAndroid) {
        // Platform-specific setup would go here
        _logger.info('Android platform setup');
      }

      // Listen to purchase updates
      _purchaseUpdatedSubscription = _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () => _logger.info('Purchase stream done'),
        onError: (error) => _logger.error('Purchase stream error', error),
      );

      // Load products
      await _loadProducts();

      _isInitialized = true;
      return true;
    } catch (e) {
      _logger.error('Error initializing in-app purchases', e);
      return false;
    }
  }

  /// Load available products from the store
  Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(_productIds.toSet());

      if (response.notFoundIDs.isNotEmpty) {
        _logger.warning('Products not found: ${response.notFoundIDs}');
      }

      _products = response.productDetails;
      _logger.info('Loaded ${_products.length} products');
    } catch (e) {
      _logger.error('Error loading products', e);
    }
  }

  /// Handle purchase updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          _logger.info('Purchase pending: ${purchaseDetails.productID}');
          break;
        case PurchaseStatus.purchased:
          _logger.info('Purchase successful: ${purchaseDetails.productID}');
          _handleSuccessfulPurchase(purchaseDetails);
          break;
        case PurchaseStatus.error:
          _logger.error('Purchase error: ${purchaseDetails.error}');
          onPurchaseError?.call(purchaseDetails);
          break;
        case PurchaseStatus.canceled:
          _logger.info('Purchase canceled: ${purchaseDetails.productID}');
          onPurchaseCancelled?.call(purchaseDetails);
          break;
        case PurchaseStatus.restored:
          _logger.info('Purchase restored: ${purchaseDetails.productID}');
          _handleSuccessfulPurchase(purchaseDetails);
          break;
      }

      // Complete the purchase
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  /// Handle successful purchase
  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) {
    // Verify the purchase on the server
    _verifyPurchase(purchaseDetails);
    onPurchaseSuccess?.call(purchaseDetails);
  }

  /// Purchase a product
  Future<bool> purchaseProduct(String productId) async {
    if (!_isInitialized) {
      _logger.warning('In-app purchase service not initialized');
      return false;
    }

    ProductDetails? product;
    try {
      product = _products.firstWhere((p) => p.id == productId);
    } catch (e) {
      _logger.warning('Product not found: $productId');
      return false;
    }

    try {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);
      final bool success =
          await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      return success;
    } catch (e) {
      _logger.error('Error purchasing product', e);
      return false;
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    if (!_isInitialized) {
      _logger.warning('In-app purchase service not initialized');
      return;
    }

    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      _logger.error('Error restoring purchases', e);
    }
  }

  /// Verify purchase on server
  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      // TODO: Implement server-side verification
      // Send the purchase details to your backend for verification
      _logger.info('Verifying purchase: ${purchaseDetails.productID}');

      // For now, we'll just log the verification data
      if (Platform.isIOS) {
        // iOS Receipt verification would go here
        _logger.debug('iOS Receipt verification needed');
      } else if (Platform.isAndroid) {
        // Android Purchase token verification would go here
        _logger.debug('Android Purchase token verification needed');
      }
    } catch (e) {
      _logger.error('Error verifying purchase', e);
    }
  }

  /// Get product by ID
  ProductDetails? getProduct(String productId) {
    try {
      return _products.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Get all products by type
  List<ProductDetails> getProductsByType(String type) {
    return _products.where((p) => p.id.contains(type)).toList();
  }

  /// Get monthly products
  List<ProductDetails> getMonthlyProducts() {
    return _products.where((p) => p.id.contains('monthly')).toList();
  }

  /// Get yearly products
  List<ProductDetails> getYearlyProducts() {
    return _products.where((p) => p.id.contains('yearly')).toList();
  }

  /// Check if user has active subscription
  Future<bool> hasActiveSubscription() async {
    // TODO: Implement subscription status check
    // This should check with your backend service
    return false;
  }

  /// Get subscription tier
  Future<String?> getSubscriptionTier() async {
    // TODO: Implement subscription tier check
    // This should check with your backend service
    return null;
  }

  /// Dispose the service
  void dispose() {
    _purchaseUpdatedSubscription.cancel();
    _isInitialized = false;
  }
}
