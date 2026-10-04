class UserAddress {
  final String id;
  final String label;
  final bool isDefault;
  final String street;
  final String city;
  final String country;

  UserAddress({
    required this.id,
    required this.label,
    required this.isDefault,
    required this.street,
    required this.city,
    required this.country,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'] as String,
      label: json['label'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
      street: json['street'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
    );
  }
}

class UserPaymentMethod {
  final String id;
  final String brand;
  final String last4;
  final bool isDefault;
  final String expiry;

  UserPaymentMethod({
    required this.id,
    required this.brand,
    required this.last4,
    required this.isDefault,
    required this.expiry,
  });

  factory UserPaymentMethod.fromJson(Map<String, dynamic> json) {
    return UserPaymentMethod(
      id: json['id'] as String,
      brand: json['brand'] as String,
      last4: json['last4'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
      expiry: json['expiry'] as String,
    );
  }
}

class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String avatarUrl;
  final String tier;
  final int ordersCount;
  final int wishlistCount;
  final List<UserAddress> addresses;
  final List<UserPaymentMethod> paymentMethods;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.tier,
    required this.ordersCount,
    required this.wishlistCount,
    required this.addresses,
    required this.paymentMethods,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    var rawAddresses = json['addresses'] as List? ?? [];
    var rawPayments = json['paymentMethods'] as List? ?? [];
    return UserProfile(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String,
      tier: json['tier'] as String? ?? 'Member',
      ordersCount: json['ordersCount'] as int? ?? 0,
      wishlistCount: json['wishlistCount'] as int? ?? 0,
      addresses: rawAddresses.map((a) => UserAddress.fromJson(a as Map<String, dynamic>)).toList(),
      paymentMethods: rawPayments.map((p) => UserPaymentMethod.fromJson(p as Map<String, dynamic>)).toList(),
    );
  }
}
