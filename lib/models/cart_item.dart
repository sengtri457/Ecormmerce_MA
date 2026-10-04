class CartItem {
  final String id;
  final String productId;
  final String title;
  final String brand;
  final double price;
  final double originalPrice;
  final String color;
  final String size;
  int quantity;
  final String imageUrl;

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
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      title: json['title'] as String,
      brand: json['brand'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      color: json['color'] as String,
      size: json['size'] as String,
      quantity: json['quantity'] as int? ?? 1,
      imageUrl: json['imageUrl'] as String,
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
      name: json['name'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      phone: json['phone'] as String,
    );
  }
}
