import 'package:flutter/material.dart';
import '../models/department_content.dart';

/// Repository that manages curated department data, hero slides, promo drops, and lookbooks.
class DepartmentRepository {
  static final DepartmentRepository _instance = DepartmentRepository._internal();
  factory DepartmentRepository() => _instance;
  DepartmentRepository._internal();

  static const List<Map<String, String>> departments = [
    {'id': 'home', 'name': 'HOME'},
    {'id': 'women', 'name': 'WOMEN'},
    {'id': 'men', 'name': 'MEN'},
    {'id': 'kids', 'name': 'KIDS'},
    {'id': 'accessory', 'name': 'ACCESSORY'},
  ];

  final Map<String, DepartmentContent> _departmentsData = {
    'women': const DepartmentContent(
      departmentId: 'women',
      departmentName: 'WOMEN',
      slides: [
        HeroBannerSlide(
          isRedSplit: true,
          tag: 'LIMITED TIME DROP',
          title: '30% - 70%\nOFF',
          subtitle: 'SALE ENDS SOON\nEXTRA 30% OFF',
          image: 'assets/images/BannerWomen.avif',
          isAsset: true,
          fallback: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80',
          cta: 'SHOP WOMEN SALE',
          category: 'Women Sale',
        ),
        HeroBannerSlide(
          isRedSplit: false,
          tag: 'AUTUMN / WINTER 2026',
          title: 'WOMEN RUNWAY EDIT',
          subtitle: 'Double-faced virgin wool blazers & fluid pleated silk',
          image: 'assets/images/products/product1.avif',
          isAsset: true,
          fallback: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=1000&auto=format&fit=crop&q=80',
          cta: 'EXPLORE EDIT',
          category: 'Women Collection',
        ),
        HeroBannerSlide(
          isRedSplit: false,
          tag: 'LEATHER & ACCESSORIES',
          title: 'ATELIER ÉPURE',
          subtitle: 'Minimalist full-grain calfskin shoulder bags & totes',
          image: 'assets/images/products/image1.jpg',
          isAsset: true,
          fallback: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=1000&auto=format&fit=crop&q=80',
          cta: 'DISCOVER BAGS',
          category: 'Women Bags',
        ),
      ],
      promoBox: PromoBoxConfig(
        title: 'WOMEN\nSALE 50%',
        subtitle: 'On selected tailoring, silk dresses & knitwear',
        color: Color(0xFFD32F2F),
        image: 'assets/images/products/product1.avif',
        isAsset: true,
        fallback: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600&auto=format&fit=crop&q=80',
      ),
      lookbook: LookbookConfig(
        tag: 'WOMEN RUNWAY 2026',
        title: 'THE CONTEMPORARY FEMININE',
        image: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=1000&auto=format&fit=crop&q=80',
        categoryTitle: 'Women Runway Lookbook',
      ),
    ),
    'men': const DepartmentContent(
      departmentId: 'men',
      departmentName: 'MEN',
      slides: [
        HeroBannerSlide(
          isRedSplit: true,
          tag: 'MEN ARCHIVAL DROP',
          title: '30% - 70%\nOFF',
          subtitle: 'STREETWEAR & TAILORING\nEXTRA 30% OFF',
          image: 'assets/images/bannerMen.gif',
          isAsset: true,
          fallback: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800&auto=format&fit=crop&q=80',
          cta: 'SHOP MEN SALE',
          category: 'Men Sale',
        ),
        HeroBannerSlide(
          isRedSplit: false,
          tag: 'STREETWEAR 2026',
          title: 'HEAVYWEIGHT BOX CUTS',
          subtitle: '280gsm graphic tees, raw selvedge denim & washed hoodies',
          image: 'assets/images/products/image1.jpg',
          isAsset: true,
          fallback: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=1000&auto=format&fit=crop&q=80',
          cta: 'SHOP TEES',
          category: 'Men Streetwear',
        ),
        HeroBannerSlide(
          isRedSplit: false,
          tag: 'ELEVATED SUITING',
          title: 'CONTEMPORARY MEN',
          subtitle: 'Relaxed unstructured blazers & wide straight trousers',
          image: 'assets/images/bannerMen.gif',
          isAsset: true,
          fallback: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=1000&auto=format&fit=crop&q=80',
          cta: 'DISCOVER SUITING',
          category: 'Men Tailoring',
        ),
      ],
      promoBox: PromoBoxConfig(
        title: 'MEN\nSALE 50%',
        subtitle: 'On radical graphic tees, denim & loopback hoodies',
        color: Color(0xFFE53935),
        image: 'assets/images/products/image1.jpg',
        isAsset: true,
        fallback: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop&q=80',
      ),
      lookbook: LookbookConfig(
        tag: 'STREETWEAR RUNWAY 2026',
        title: 'THE NEW GENERATION',
        image: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=1000&auto=format&fit=crop&q=80',
        categoryTitle: 'Men Runway Lookbook',
      ),
    ),
    'kids': const DepartmentContent(
      departmentId: 'kids',
      departmentName: 'KIDS',
      slides: [
        HeroBannerSlide(
          isRedSplit: true,
          tag: 'JUNIOR DROP',
          title: 'UP TO 50%\nOFF',
          subtitle: 'MINI STREETWEAR ESSENTIALS\nEXTRA 20% OFF',
          image: 'https://images.unsplash.com/photo-1519457431-44ccd64a579b?w=800&auto=format&fit=crop&q=80',
          isAsset: false,
          fallback: 'https://images.unsplash.com/photo-1519457431-44ccd64a579b?w=800&auto=format&fit=crop&q=80',
          cta: 'SHOP KIDS SALE',
          category: 'Kids Sale',
        ),
        HeroBannerSlide(
          isRedSplit: false,
          tag: 'MA MINI CAPSULE',
          title: 'ORGANIC COTTON BASICS',
          subtitle: 'Ultra-soft fleece hoodies, boxy tees & comfortable sets',
          image: 'https://images.unsplash.com/photo-1503919545889-aef636e10ad4?w=1000&auto=format&fit=crop&q=80',
          isAsset: false,
          fallback: 'https://images.unsplash.com/photo-1503919545889-aef636e10ad4?w=1000&auto=format&fit=crop&q=80',
          cta: 'EXPLORE KIDS',
          category: 'Kids Collection',
        ),
      ],
      promoBox: PromoBoxConfig(
        title: 'KIDS\nDROP 40%',
        subtitle: 'On organic cotton sweat sets & durable outerwear',
        color: Color(0xFFC62828),
        image: 'https://images.unsplash.com/photo-1519457431-44ccd64a579b?w=600&auto=format&fit=crop&q=80',
        isAsset: false,
        fallback: '',
      ),
      lookbook: LookbookConfig(
        tag: 'KIDS ARCHIVE 2026',
        title: 'PLAYFUL & TIMELESS',
        image: 'https://images.unsplash.com/photo-1519457431-44ccd64a579b?w=1000&auto=format&fit=crop&q=80',
        categoryTitle: 'Kids Lookbook',
      ),
    ),
    'home': const DepartmentContent(
      departmentId: 'home',
      departmentName: 'HOME',
      slides: [
        HeroBannerSlide(
          isRedSplit: true,
          tag: 'LIMITED TIME DROP',
          title: '30% - 70%\nOFF',
          subtitle: 'SALE ENDS SOON\nEXTRA 30% OFF',
          image: 'assets/images/BannerWomen.avif',
          isAsset: true,
          fallback: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80',
          cta: 'SHOP SALE',
          category: 'Sale Drop',
        ),
        HeroBannerSlide(
          isRedSplit: false,
          tag: 'AUTUMN / WINTER 2026',
          title: 'RUNWAY CAPSULE',
          subtitle: 'Double-faced virgin wool blazers & fluid pleated silk',
          image: 'assets/images/bannerMen.gif',
          isAsset: true,
          fallback: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=1000&auto=format&fit=crop&q=80',
          cta: 'EXPLORE EDIT',
          category: 'Featured Collection',
        ),
        HeroBannerSlide(
          isRedSplit: false,
          tag: 'ATELIER LEATHER',
          title: 'TIMELESS OBJECTS',
          subtitle: 'Full-grain calfskin shoulder bags, sculpted jewelry & eyewear',
          image: 'assets/images/products/image1.jpg',
          isAsset: true,
          fallback: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=1000&auto=format&fit=crop&q=80',
          cta: 'DISCOVER ACCESSORIES',
          category: 'Accessories Collection',
        ),
      ],
      promoBox: PromoBoxConfig(
        title: 'EXCLUSIVE\nDROP 50%',
        subtitle: 'On curated tailoring, graphic streetwear & leather accessories',
        color: Color(0xFFD32F2F),
        image: 'assets/images/products/product1.avif',
        isAsset: true,
        fallback: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600&auto=format&fit=crop&q=80',
      ),
      lookbook: LookbookConfig(
        tag: 'MA ATELIER 2026',
        title: 'CONTEMPORARY MINIMALISM',
        image: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=1000&auto=format&fit=crop&q=80',
        categoryTitle: 'Editorial Lookbook',
      ),
    ),
    'accessory': const DepartmentContent(
      departmentId: 'accessory',
      departmentName: 'ACCESSORY',
      slides: [
        HeroBannerSlide(
          isRedSplit: true,
          tag: 'ATELIER DETAILS',
          title: 'UP TO 50%\nOFF',
          subtitle: 'LEATHER & HARDWARE\nEXTRA 20% OFF',
          image: 'assets/images/products/image1.jpg',
          isAsset: true,
          fallback: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800&auto=format&fit=crop&q=80',
          cta: 'SHOP ACCESSORIES',
          category: 'Accessories Sale',
        ),
        HeroBannerSlide(
          isRedSplit: false,
          tag: 'LEATHER & ACCESSORIES',
          title: 'TIMELESS OBJECTS',
          subtitle: 'Full-grain calfskin belts, sculpted jewelry & minimalist eyewear',
          image: 'assets/images/products/image3.jpg',
          isAsset: true,
          fallback: 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=1000&auto=format&fit=crop&q=80',
          cta: 'DISCOVER ACCESSORIES',
          category: 'Accessories Collection',
        ),
      ],
      promoBox: PromoBoxConfig(
        title: 'ACCESSORY\nDROP 40%',
        subtitle: 'On handcrafted leather wallets, silk scarves & jewelry',
        color: Color(0xFF6B4423),
        image: 'assets/images/products/image1.jpg',
        isAsset: true,
        fallback: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=600&auto=format&fit=crop&q=80',
      ),
      lookbook: LookbookConfig(
        tag: 'ACCESSOIRES ARCHIVE 2026',
        title: 'SCULPTURAL REFINEMENT',
        image: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=1000&auto=format&fit=crop&q=80',
        categoryTitle: 'Accessories Lookbook',
      ),
    ),
  };

  /// Returns the content configuration for the given department ID.
  DepartmentContent getContent(String departmentId) {
    final id = departmentId.toLowerCase();
    if (id == 'beauty' || id == 'accessories') {
      return _departmentsData['accessory']!;
    }
    return _departmentsData[id] ?? _departmentsData['home'] ?? _departmentsData['women']!;
  }
}
