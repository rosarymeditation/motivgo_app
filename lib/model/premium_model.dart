class PremiumModel {
   bool isPremium;
   String? premiumPackageId;
   String? premiumStoreProductId;
   String? premiumEntitlementId;
   DateTime? subscriptionExpiresAt;

  PremiumModel({
    required this.isPremium,
    this.premiumPackageId,
    this.premiumStoreProductId,
    this.premiumEntitlementId,
    this.subscriptionExpiresAt,
  });

  factory PremiumModel.fromJson(Map<String, dynamic> json) {
    return PremiumModel(
      isPremium: json['isPremium'] ?? false,
      premiumPackageId: json['premiumPackageId'],
      premiumStoreProductId: json['premiumStoreProductId'],
      premiumEntitlementId: json['premiumEntitlementId'],
      subscriptionExpiresAt: json['subscriptionExpiresAt'] != null
          ? DateTime.parse(json['subscriptionExpiresAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isPremium': isPremium,
      'premiumPackageId': premiumPackageId,
      'premiumStoreProductId': premiumStoreProductId,
      'premiumEntitlementId': premiumEntitlementId,
      'subscriptionExpiresAt':
          subscriptionExpiresAt?.toIso8601String(), // nullable-safe
    };
  }
}
