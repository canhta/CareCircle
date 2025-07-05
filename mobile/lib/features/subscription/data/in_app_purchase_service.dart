import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:carecircle/common/common.dart';
import 'package:carecircle/features/subscription/domain/subscription_models.dart';
import 'package:carecircle/features/subscription/domain/subscription_repository.dart';

/// Service implementation for in-app purchases
class InAppPurchaseService implements InAppPurchaseRepository {
  final AppLogger _logger;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

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

  InAppPurchaseService({
    required AppLogger logger,
  }) : _logger = logger;

  @override
  Future<Result<bool>> initialize() async {
    if (_isInitialized) return Result.success(true);

    try {
      _logger.info('Initializing in-app purchases');

      // Check if the service is available
      final bool isAvailable = await _inAppPurchase.isAvailable();
      if (!isAvailable) {
        _logger.warning('In-app purchases are not available');
        return Result.failure(
          Exception('In-app purchases are not available on this device'),
        );
      }

      // Listen to purchase updates
      _purchaseUpdatedSubscription = _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdated,
        onError: _onPurchaseError,
        onDone: () {
          _logger.info('Purchase stream closed');
        },
      );

      // Get available products
      final result = await _loadProducts();
      if (result.isFailure) {
        return Result.failure(result.exception!);
      }

      _isInitialized = true;
      _logger.info('In-app purchases initialized successfully');
      return Result.success(true);
    } catch (e) {
      _logger.error('Failed to initialize in-app purchases', error: e);
      return Result.failure(
        Exception('Failed to initialize in-app purchases: $e'),
      );
    }
  }

  @override
  Future<Result<List<dynamic>>> getProducts() async {
    try {
      _logger.info('Fetching available products');

      if (!_isInitialized) {
        final initResult = await initialize();
        if (initResult.isFailure) {
          return Result.failure(initResult.exception!);
        }
      }

      return Result.success(_products);
    } catch (e) {
      _logger.error('Failed to fetch products', error: e);
      return Result.failure(Exception('Failed to fetch products: $e'));
    }
  }

  @override
  Future<Result<PurchaseResult>> purchaseProduct(String productId) async {
    try {
      _logger.info('Purchasing product: $productId');

      if (!_isInitialized) {
        final initResult = await initialize();
        if (initResult.isFailure) {
          return Result.failure(initResult.exception!);
        }
      }

      // Find the product
      final ProductDetails? product = _products.isNotEmpty
          ? _products.firstWhere(
              (p) => p.id == productId,
              orElse: () => throw Exception('Product not found: $productId'),
            )
          : null;

      if (product == null) {
        return Result.failure(Exception('Product not found: $productId'));
      }

      // Create purchase parameters
      final purchaseParam = PurchaseParam(productDetails: product);

      // Make the purchase
      final bool success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      if (success) {
        _logger.info('Purchase initiated successfully');
        return Result.success(PurchaseResult(
          success: true,
          transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
        ));
      } else {
        _logger.error('Failed to initiate purchase');
        return Result.failure(Exception('Failed to initiate purchase'));
      }
    } catch (e) {
      _logger.error('Error purchasing product', error: e);
      return Result.failure(Exception('Error purchasing product: $e'));
    }
  }

  @override
  Future<Result<void>> restorePurchases() async {
    try {
      _logger.info('Restoring purchases');

      if (!_isInitialized) {
        final initResult = await initialize();
        if (initResult.isFailure) {
          return Result.failure(initResult.exception!);
        }
      }

      await _inAppPurchase.restorePurchases();
      _logger.info('Purchases restored successfully');
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to restore purchases', error: e);
      return Result.failure(Exception('Failed to restore purchases: $e'));
    }
  }

  @override
  Future<Result<bool>> isPurchaseAvailable() async {
    try {
      final bool isAvailable = await _inAppPurchase.isAvailable();
      return Result.success(isAvailable);
    } catch (e) {
      _logger.error('Error checking purchase availability', error: e);
      return Result.failure(
          Exception('Error checking purchase availability: $e'));
    }
  }

  @override
  Future<Result<void>> dispose() async {
    try {
      _logger.info('Disposing in-app purchase service');

      if (_isInitialized) {
        await _purchaseUpdatedSubscription.cancel();
      }
      _isInitialized = false;
      _products.clear();

      _logger.info('In-app purchase service disposed');
      return Result.success(null);
    } catch (e) {
      _logger.error('Error disposing in-app purchase service', error: e);
      return Result.failure(Exception('Error disposing service: $e'));
    }
  }

  // Private helper methods

  Future<Result<void>> _loadProducts() async {
    try {
      _logger.info('Loading products from store');

      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(_productIds.toSet());

      if (response.notFoundIDs.isNotEmpty) {
        _logger.warning('Some products not found: ${response.notFoundIDs}');
      }

      if (response.error != null) {
        _logger.error('Error loading products: ${response.error}');
        return Result.failure(
            Exception('Error loading products: ${response.error}'));
      }

      _products = response.productDetails;
      _logger.info('Loaded ${_products.length} products');
      return Result.success(null);
    } catch (e) {
      _logger.error('Error loading products', error: e);
      return Result.failure(Exception('Error loading products: $e'));
    }
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    _logger.info('Purchase updated: ${purchaseDetailsList.length} purchases');

    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      _logger.info('Processing purchase: ${purchaseDetails.productID}');

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          _logger.info('Purchase pending: ${purchaseDetails.productID}');
          break;
        case PurchaseStatus.purchased:
          _logger.info('Purchase completed: ${purchaseDetails.productID}');
          onPurchaseSuccess?.call(purchaseDetails);
          break;
        case PurchaseStatus.error:
          _logger.error('Purchase error: ${purchaseDetails.error}');
          onPurchaseError?.call(purchaseDetails);
          break;
        case PurchaseStatus.canceled:
          _logger.info('Purchase cancelled: ${purchaseDetails.productID}');
          onPurchaseCancelled?.call(purchaseDetails);
          break;
        case PurchaseStatus.restored:
          _logger.info('Purchase restored: ${purchaseDetails.productID}');
          onPurchaseSuccess?.call(purchaseDetails);
          break;
      }

      // Complete the purchase if successful
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        _completePurchase(purchaseDetails);
      }
    }
  }

  void _onPurchaseError(dynamic error) {
    _logger.error('Purchase stream error', error: error);
  }

  Future<void> _completePurchase(PurchaseDetails purchaseDetails) async {
    try {
      _logger.info('Completing purchase: ${purchaseDetails.productID}');

      // TODO: Verify purchase with backend server
      // await _verifyPurchaseWithServer(purchaseDetails);

      // Complete the purchase
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
        _logger.info('Purchase completed: ${purchaseDetails.productID}');
      }
    } catch (e) {
      _logger.error('Error completing purchase', error: e);
    }
  }

  /// Get product by ID
  ProductDetails? getProductById(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      _logger.warning('Product not found: $productId');
      return null;
    }
  }

  /// Get products by type
  List<ProductDetails> getProductsByType(String type) {
    return _products.where((product) => product.id.contains(type)).toList();
  }

  /// Get monthly products
  List<ProductDetails> getMonthlyProducts() {
    return getProductsByType('monthly');
  }

  /// Get yearly products
  List<ProductDetails> getYearlyProducts() {
    return getProductsByType('yearly');
  }
}
