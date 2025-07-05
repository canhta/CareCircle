/// Domain models for subscription and payment features
library;

class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String period;
  final List<String> features;
  final bool isPopular;
  final bool isYearly;
  final Map<String, dynamic>? metadata;
  final dynamic productDetails; // Will be ProductDetails when available

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.period,
    required this.features,
    this.isPopular = false,
    this.isYearly = false,
    this.metadata,
    this.productDetails,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      period: json['period'] as String,
      features: List<String>.from(json['features'] as List<dynamic>),
      isPopular: json['isPopular'] as bool? ?? false,
      isYearly: json['isYearly'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
      productDetails: json['productDetails'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'period': period,
      'features': features,
      'isPopular': isPopular,
      'isYearly': isYearly,
      'metadata': metadata,
      'productDetails': productDetails,
    };
  }

  SubscriptionPlan copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? currency,
    String? period,
    List<String>? features,
    bool? isPopular,
    bool? isYearly,
    Map<String, dynamic>? metadata,
    dynamic productDetails,
  }) {
    return SubscriptionPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      period: period ?? this.period,
      features: features ?? this.features,
      isPopular: isPopular ?? this.isPopular,
      isYearly: isYearly ?? this.isYearly,
      metadata: metadata ?? this.metadata,
      productDetails: productDetails ?? this.productDetails,
    );
  }

  String get formattedPrice => '$currency ${price.toStringAsFixed(2)}';

  String get savingsText => isYearly ? 'Save 20%' : '';
}

class UserSubscription {
  final String id;
  final String planId;
  final String planName;
  final DateTime startDate;
  final DateTime endDate;
  final SubscriptionStatus status;
  final bool autoRenew;
  final PaymentMethod paymentMethod;
  final Map<String, dynamic>? metadata;

  const UserSubscription({
    required this.id,
    required this.planId,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.autoRenew,
    required this.paymentMethod,
    this.metadata,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'] as String,
      planId: json['subscriptionPlanId'] as String,
      planName: json['subscriptionPlan']['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      status: _parseSubscriptionStatus(json['status'] as String),
      autoRenew: json['autoRenew'] as bool? ?? false,
      paymentMethod: _parsePaymentMethod(json['paymentMethod'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planId': planId,
      'planName': planName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.name,
      'autoRenew': autoRenew,
      'paymentMethod': paymentMethod.name,
      'metadata': metadata,
    };
  }

  static SubscriptionStatus _parseSubscriptionStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return SubscriptionStatus.active;
      case 'expired':
        return SubscriptionStatus.expired;
      case 'cancelled':
        return SubscriptionStatus.cancelled;
      case 'pending':
        return SubscriptionStatus.pending;
      case 'suspended':
        return SubscriptionStatus.suspended;
      default:
        return SubscriptionStatus.pending;
    }
  }

  static PaymentMethod _parsePaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'credit_card':
        return PaymentMethod.creditCard;
      case 'apple_pay':
        return PaymentMethod.applePay;
      case 'google_pay':
        return PaymentMethod.googlePay;
      case 'momo':
        return PaymentMethod.momo;
      case 'zalopay':
        return PaymentMethod.zalopay;
      case 'bank_transfer':
        return PaymentMethod.bankTransfer;
      default:
        return PaymentMethod.creditCard;
    }
  }

  bool get isActive =>
      status == SubscriptionStatus.active && endDate.isAfter(DateTime.now());
  bool get isExpired => endDate.isBefore(DateTime.now());
  Duration get timeRemaining => endDate.difference(DateTime.now());

  String get timeRemainingText {
    if (isExpired) return 'Expired';

    final days = timeRemaining.inDays;
    if (days > 0) {
      return '$days days remaining';
    } else {
      final hours = timeRemaining.inHours;
      return '$hours hours remaining';
    }
  }
}

enum SubscriptionStatus {
  active,
  expired,
  cancelled,
  pending,
  suspended,
}

enum PaymentMethod {
  creditCard,
  applePay,
  googlePay,
  momo,
  zalopay,
  bankTransfer,
}

class PurchaseResult {
  final bool success;
  final String? error;
  final String? transactionId;
  final dynamic purchaseDetails; // Will be PurchaseDetails when available

  const PurchaseResult({
    required this.success,
    this.error,
    this.transactionId,
    this.purchaseDetails,
  });

  factory PurchaseResult.success(dynamic purchaseDetails,
      {String? transactionId}) {
    return PurchaseResult(
      success: true,
      purchaseDetails: purchaseDetails,
      transactionId: transactionId,
    );
  }

  factory PurchaseResult.error(String error) {
    return PurchaseResult(
      success: false,
      error: error,
    );
  }
}

class SubscriptionUsage {
  final String subscriptionId;
  final Map<String, dynamic> quotas;
  final Map<String, dynamic> usage;
  final DateTime periodStart;
  final DateTime periodEnd;

  const SubscriptionUsage({
    required this.subscriptionId,
    required this.quotas,
    required this.usage,
    required this.periodStart,
    required this.periodEnd,
  });

  factory SubscriptionUsage.fromJson(Map<String, dynamic> json) {
    return SubscriptionUsage(
      subscriptionId: json['subscriptionId'] as String,
      quotas: json['quotas'] as Map<String, dynamic>,
      usage: json['usage'] as Map<String, dynamic>,
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscriptionId': subscriptionId,
      'quotas': quotas,
      'usage': usage,
      'periodStart': periodStart.toIso8601String(),
      'periodEnd': periodEnd.toIso8601String(),
    };
  }

  double getUsagePercentage(String feature) {
    final quota = quotas[feature];
    final used = usage[feature];

    if (quota == null || used == null || quota == 0) return 0.0;

    return (used / quota).clamp(0.0, 1.0);
  }

  bool hasExceededQuota(String feature) {
    return getUsagePercentage(feature) >= 1.0;
  }
}

class PaymentHistory {
  final String id;
  final String subscriptionId;
  final double amount;
  final String currency;
  final DateTime paymentDate;
  final PaymentStatus status;
  final PaymentMethod method;
  final String? transactionId;
  final String? receiptUrl;

  const PaymentHistory({
    required this.id,
    required this.subscriptionId,
    required this.amount,
    required this.currency,
    required this.paymentDate,
    required this.status,
    required this.method,
    this.transactionId,
    this.receiptUrl,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      id: json['id'] as String,
      subscriptionId: json['subscriptionId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentDate: DateTime.parse(json['paymentDate'] as String),
      status: _parsePaymentStatus(json['status'] as String),
      method: UserSubscription._parsePaymentMethod(json['method'] as String),
      transactionId: json['transactionId'] as String?,
      receiptUrl: json['receiptUrl'] as String?,
    );
  }

  static PaymentStatus _parsePaymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return PaymentStatus.completed;
      case 'pending':
        return PaymentStatus.pending;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }

  String get formattedAmount => '$currency ${amount.toStringAsFixed(2)}';
}

enum PaymentStatus {
  completed,
  pending,
  failed,
  refunded,
}

/// Predefined subscription product IDs
class SubscriptionProductIds {
  static const String basicMonthlyId = 'basic_monthly';
  static const String premiumMonthlyId = 'premium_monthly';
  static const String basicYearlyId = 'basic_yearly';
  static const String premiumYearlyId = 'premium_yearly';

  static const List<String> allProductIds = [
    basicMonthlyId,
    premiumMonthlyId,
    basicYearlyId,
    premiumYearlyId,
  ];
}
