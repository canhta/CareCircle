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
    this.productDetails,
  });

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

  const UserSubscription({
    required this.id,
    required this.planId,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.autoRenew,
    required this.paymentMethod,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'],
      planId: json['subscriptionPlanId'],
      planName: json['subscriptionPlan']['name'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.name == json['status'].toLowerCase(),
      ),
      autoRenew: json['autoRenew'] ?? false,
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['paymentMethod'].toLowerCase(),
      ),
    );
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
  final dynamic purchaseDetails; // Will be PurchaseDetails when available

  const PurchaseResult({
    required this.success,
    this.error,
    this.purchaseDetails,
  });

  factory PurchaseResult.success(dynamic purchaseDetails) {
    return PurchaseResult(
      success: true,
      purchaseDetails: purchaseDetails,
    );
  }

  factory PurchaseResult.error(String error) {
    return PurchaseResult(
      success: false,
      error: error,
    );
  }
}
