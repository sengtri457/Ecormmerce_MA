class CartItem {
  final String id;
  final int productId;
  final String title;
  final String brand;
  final double price;
  final double originalPrice;
  final String color;
  final String size;
  int quantity;
  final String imageUrl;
  bool isSelected;

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.color,
    required this.size,
    required this.quantity,
    required this.imageUrl,
    this.isSelected = true,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String? ?? '',
      productId: json['productId'] is num
          ? (json['productId'] as num).toInt()
          : int.tryParse(json['productId']?.toString() ?? '0') ?? 0,
      title: json['title'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      color: json['color'] as String? ?? '',
      size: json['size'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      imageUrl: json['imageUrl'] as String? ?? '',
      isSelected: json['isSelected'] as bool? ?? true,
    );
  }
}

class ShippingAddress {
  final String name;
  final String street;
  final String city;
  final String country;
  final String phone;

  ShippingAddress({
    required this.name,
    required this.street,
    required this.city,
    required this.country,
    required this.phone,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      name: json['name'] as String? ?? '',
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }
}
