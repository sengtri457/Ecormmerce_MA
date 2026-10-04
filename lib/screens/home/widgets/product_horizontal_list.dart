import 'package:flutter/material.dart';
import '../../../models/product.dart';
import '../../../widgets/product_card.dart';

/// Horizontally scrollable product feed with fixed item sizing for 60fps scrolling.
class ProductHorizontalList extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<Product> onProductTap;
  final double height;
  final double cardWidth;

  const ProductHorizontalList({
    super.key,
    required this.products,
    required this.onProductTap,
    this.height = 310,
    this.cardWidth = 175,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            width: cardWidth,
            child: ProductCard(
              product: product,
              onTap: () => onProductTap(product),
            ),
          );
        },
      ),
    );
  }
}
