import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';

/// A production-ready, memory-optimized image widget that intelligently
/// handles both local assets and network URLs with graceful fallbacks.
class AppImage extends StatelessWidget {
  final String imagePath;
  final String? fallbackUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    required this.imagePath,
    this.fallbackUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  bool get isAsset => imagePath.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (imagePath.isEmpty) {
      image = _buildPlaceholder();
    } else if (isAsset) {
      image = Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          if (fallbackUrl != null && fallbackUrl!.isNotEmpty) {
            return _buildNetworkImage(fallbackUrl!);
          }
          return errorWidget ?? _buildPlaceholder();
        },
      );
    } else {
      image = _buildNetworkImage(imagePath);
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }

  Widget _buildNetworkImage(String url) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? _buildPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceSubtle,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: AppColors.placeholder.withValues(alpha: 0.5),
          size: 24,
        ),
      ),
    );
  }
}
