# Flutter Catalog & E-Commerce Architecture Pattern Guide

> **Reference Template**: A clean, scalable, production-ready blueprint for Flutter apps displaying carousel banners, categorized product catalogs, local JSON data loading, and interactive detail screens.

---

## 1. System Architecture & Folder Layout

This project follows a clean **4-Layer Separation of Concerns**:

```
Data Layer (JSON / API)
        │
        ▼
Model Layer (Typed Dart Classes + fromJson)
        │
        ▼
Service Layer (Async Data Fetching & Decoding)
        │
        ▼
Presentation Layer (Reusable Widgets + Screens)
```

### Folder Structure

```
lib/
├── helpers/              # Reusable presentational widgets
│   ├── grocery_card.dart # Category / banner cards
│   └── product_card.dart # Item cards with price & action buttons
├── models/               # Data structures with serialization
│   ├── app_slider.dart   # Carousel slide model
│   ├── grocery.dart      # Category / department model
│   └── product.dart      # Product & grouped feature catalog model
├── screen/               # Application view controllers / pages
│   ├── home_screen.dart  # Main catalog feed & hero carousel
│   └── product_details_screen.dart # Interactive product viewer
├── services/             # Business logic & data loaders
│   └── home_service.dart # JSON asset loaders & future API handlers
└── main.dart             # Application root entry point
```

---

## 2. JSON Data Layer & Asset Setup

### A. Registering Asset Folders in `pubspec.yaml`

Always declare directory paths ending with a trailing slash `/` to include all files inside:

```YAML
flutter:
  uses-material-design: true
  assets:
    - assets/img/
    - assets/json/
```

### B. Two Primary JSON Schema Formats

#### 1. Flat List Schema (`assets/json/slider.json` or `groceries.json`)

Ideal for banners, category tags, or simple lists:

```JSON
[
  {
    "id": 1,
    "title": "Fresh Vegetables",
    "image": "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=1000&h=450&q=80"
  },
  {
    "id": 2,
    "title": "Fresh Fruits",
    "image": "https://images.unsplash.com/photo-1610832958506-aa56368176cf?auto=format&fit=crop&w=1000&h=450&q=80"
  }
]
```

#### 2. Grouped Catalog Schema (`assets/json/featur_product.json`)

Ideal when one network call or JSON file feeds multiple sections on a home page:

```JSON
{
  "exclusive_offers": [
    {
      "id": 1,
      "name": "Organic Bananas",
      "unit": "7pcs, Price",
      "price": 4.99,
      "image_url": "https://images.unsplash.com/photo-1603833665858-e61d17a86224?auto=format&fit=crop&w=500&h=500&q=80",
      "detail": "Organic bananas are rich in potassium and vitamin C.",
      "nutritions": "100gr",
      "review": 4.8
    }
  ],
  "best_sellings": [ ... ],
  "features": [ ... ]
}
```

---

## 3. Model Layer: Safe & Concise `fromJson` Pattern

### Safe Type Casting Rules:

1. **Numbers (`double`)**: Always parse as `num?` first, then call `.toDouble() ?? 0.0`. This prevents runtime crashes if JSON passes an integer (e.g. `5` instead of `5.0`).
2. **Strings**: Use `?? ''` to guarantee null-safety without forced unwrap `!`.
3. **Colors**: Parse hexadecimal color strings cleanly using `Color(int.parse(hexString))`.

```Dart
// lib/models/product.dart
class Product {
  final int id;
  final String name;
  final String unit;
  final double price;
  final String imageUrl;
  final String detail;
  final String nutritions;
  final double review;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.unit,
    required this.price,
    required this.imageUrl,
    this.detail = '',
    this.nutritions = '100gr',
    this.review = 5.0,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      unit: json['unit'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] ?? '',
      detail: json['detail'] ?? '',
      nutritions: json['nutritions'] ?? '100gr',
      review: (json['review'] as num?)?.toDouble() ?? 5.0,
      isFavorite: json['is_favorite'] ?? false,
    );
  }
}

class FeatureProduct {
  final String exclusiveOffersTitle;
  final String bestSellingsTitle;
  final String featuresTitle;
  final List<Product> exclusiveOffers;
  final List<Product> bestSellings;
  final List<Product> features;

  FeatureProduct({
    this.exclusiveOffersTitle = 'EXCLUSIVE OFFERS',
    this.bestSellingsTitle = 'BEST SELLING',
    this.featuresTitle = 'EXPLORE CATEGORIES',
    this.exclusiveOffers = const [],
    this.bestSellings = const [],
    this.features = const [],
  });

  String get newArrivalsTitle => exclusiveOffersTitle;
  String get trendingTitle => bestSellingsTitle;
  String get categoriesTitle => featuresTitle;

  factory FeatureProduct.fromJson(Map<String, dynamic> json) {
    return FeatureProduct(
      exclusiveOffersTitle: json['exclusive_offers_title'] as String? ??
          json['new_arrivals_title'] as String? ??
          'EXCLUSIVE OFFERS',
      bestSellingsTitle: json['best_sellings_title'] as String? ??
          json['trending_title'] as String? ??
          'BEST SELLING',
      featuresTitle: json['features_title'] as String? ??
          json['categories_title'] as String? ??
          'EXPLORE CATEGORIES',
      exclusiveOffers: (json['exclusive_offers'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map((e) => Product.fromJson(e))
          .toList(),
      bestSellings: (json['best_sellings'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map((e) => Product.fromJson(e))
          .toList(),
      features: (json['features'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }
}
```

---

## 4. Service Layer Pattern: Centralized Async Fetching

Avoid putting `rootBundle.loadString` directly in UI widgets. Keep it in a dedicated service class so switching from local JSON to HTTP API takes **one line change**.

```Dart
// lib/services/home_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:my_first/models/app_slider.dart';
import 'package:my_first/models/grocery.dart';
import 'package:my_first/models/product.dart';

class HomeService {
  // 1. Load flat list
  Future<List<AppSlider>> getAllSlides() async {
    final result = await rootBundle.loadString('assets/json/slider.json');
    final List decode = jsonDecode(result);
    return decode.map((e) => AppSlider.fromJson(e)).toList();
  }

  // 2. Load nested catalog map
  Future<FeatureProduct> getFeatureProducts() async {
    final result = await rootBundle.loadString('assets/json/featur_product.json');
    final decode = jsonDecode(result);
    return FeatureProduct.fromJson(decode);
  }

  // 3. Load categories
  Future<List<Grocery>> getGroceries() async {
    final result = await rootBundle.loadString('assets/json/groceries.json');
    final List decode = jsonDecode(result);
    return decode.map((e) => Grocery.fromJson(e)).toList();
  }
}
```

> \[!TIP]
> **API Migration**: When you want to fetch live data from a backend server, replace `rootBundle.loadString('...')` with `http.get(Uri.parse('https://api.example.com/...')).then((res) => res.body)`. None of your screens or widgets need to change!

---

## 5. UI Presentation Patterns

### A. Reusable Horizontal Section Builder (No Duplicate Code)

Instead of copy-pasting horizontal list code three times for Exclusive Offers, Best Selling, and Features, create a single private builder method:

```Dart
Widget _buildSection({
  required String title,
  required List<Product> products,
}) {
  if (products.isEmpty) return const SizedBox.shrink();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 24),
      // Section Header Row
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'See all',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF53B175)),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      // Horizontal Scroll List
      SizedBox(
        height: 245,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          itemBuilder: (context, index) => ProductCard(
            product: products[index],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(product: products[index]),
                ),
              );
            },
          ),
        ),
      ),
    ],
  );
}
```

### B. Standardized Card Component (`ProductCard`)

Key architectural rules used in `ProductCard`:

1. **Fixed Image Height (`SizedBox(height: 95)`)**: Never use unbounded flexible widgets for images in fixed-size cards. A fixed box guarantees every card aligns symmetrically.
2. **`const Spacer()`**: Pushes the bottom price and `+` button to the bottom edge regardless of whether the title takes 1 or 2 lines.
3. **Event Delegation**: The green `+` button triggers `onPressed`, avoiding duplicate action listeners.

```Dart
// lib/helpers/product_card.dart
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onPressed;

  const ProductCard({
    super.key,
    required this.product,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed image bounds with error fallback
          SizedBox(
            height: 95,
            width: double.infinity,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                Icons.shopping_basket_outlined,
                size: 50,
                color: Color(0xFF53B175),
              ),
            ),
          ),
          const Spacer(),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            product.unit,
            style: const TextStyle(fontSize: 13, color: Color(0xFF7C7C7C)),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: onPressed, // Navigates to detail page
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF53B175),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

### C. Clean Carousel Slider

Use `viewportFraction: 1.0` wrapped in horizontal padding and `ClipRRect` to ensure clean margins without awkward image peek overflowing:

```Dart
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: CarouselSlider(
      options: CarouselOptions(
        height: 125,
        viewportFraction: 1.0,
        autoPlay: true,
      ),
      items: _sliders.map((slider) {
        return Image.network(
          slider.image,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, _, _) => Container(color: const Color(0xFFE2E2E2)),
        );
      }).toList(),
    ),
  ),
)
```

---

## 6. Product Details Screen: State & Navigation Patterns

### A. Strongly Typed Screen Navigation

Never hardcode fake fallback objects in screen state. Pass the typed model instance directly:

```Dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductDetailsScreen(product: selectedProduct),
  ),
);
```

### B. Clean State Management in Details Screen

```Dart
class ProductDetailsScreen extends StatefulWidget {
  final Product product; // Required typed parameter

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late bool _isFavorite;
  int _quantity = 1;
  bool _isDetailExpanded = true;
  double _rating = 5.0;

  @override
  void initState() {
    super.initState();
    // Initialize mutable local state from passed product
    _isFavorite = widget.product.isFavorite;
    _rating = widget.product.review;
  }

  // 1. Quantity constraints (cannot go below 1)
  void _increase() => setState(() => _quantity++);
  void _decrease() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  // 2. Favorite toggle
  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      widget.product.isFavorite = _isFavorite;
    });
  }

  // 3. Dynamic total price calculation
  double get _totalPrice => widget.product.price * _quantity;
}
```

### C. Sticky Bottom Button Pattern

Wrap the scrolling content inside `Expanded(child: SingleChildScrollView(...))` and place the button directly below `Expanded` inside a vertical `Column`:

```Dart
Column(
  children: [
    Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopImage(),
            _buildProductInfo(),
            _buildQuantityRow(),
            _buildAccordion(),
            _buildRatingBar(),
          ],
        ),
      ),
    ),
    // Pinned to bottom, always visible
    Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _addToCart,
        child: const Text('Add To Basket'),
      ),
    ),
  ],
)
```

---

## 7. How to Adapt This Architecture to Other Projects

Follow this checklist to apply this exact pattern to any new Flutter project:

| Step                 | Action                                 | Example (Food Delivery App)        | Example (Electronics Store)     |
| -------------------- | -------------------------------------- | ---------------------------------- | ------------------------------- |
| **1. Create JSON**   | Put mock data in `assets/json/`        | `meals.json`, `restaurants.json`   | `gadgets.json`, `brands.json`   |
| **2. Define Model**  | Create properties and `fromJson`       | `Meal` (calories, preparationTime) | `Gadget` (warranty, specs)      |
| **3. Build Service** | Write loader in `services/`            | `FoodService.getTopMeals()`        | `ProductService.getDeals()`     |
| **4. Build Card**    | Create standardized Card widget        | `MealCard` (fixed image + badge)   | `GadgetCard` (image + discount) |
| **5. Build Screen**  | Assemble Sections with `_buildSection` | Trending Dishes, Nearby Chefs      | New Arrivals, Best Sellers      |
| **6. Detail Screen** | Receive item and wire up counter       | Ingredients, Order Customization   | Technical Specs, Buy Now        |

---

## 8. Summary of Best Practices Used

1. **Defensive Image Loading**: Every network image provides an `errorBuilder` to prevent ugly broken image crashes.
2. **Fixed Container Constraints**: Image containers use fixed `SizedBox(height: ...)` and `BoxFit.contain` to preserve aspect ratios.
3. **No Redundant Files**: Avoid duplicate folders like `screen` and `screens` — stick to singular `screen/` or `screens/` consistently.
4. **Single-line Wildcards**: In modern Dart (3.7+), use `(_, _, _)` instead of multi-underscores `(_, __, ___)`.
5. **No Hardcoded Data in Screens**: Keep UI dumb and data-driven — all text, pricing, and URLs flow from the models.
