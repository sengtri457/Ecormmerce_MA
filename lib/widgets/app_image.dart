import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';

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

  String get _cleanPath =>
      imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;

  bool get isAsset => _cleanPath.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    Widget image;
    final path = _cleanPath;

    if (path.isEmpty) {
      image = _buildPlaceholder();
    } else if (isAsset) {
      image = Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          if (fallbackUrl != null && fallbackUrl!.isNotEmpty) {
            final cleanFallback = fallbackUrl!.startsWith('/')
                ? fallbackUrl!.substring(1)
                : fallbackUrl!;
            if (cleanFallback.startsWith('assets/')) {
              return Image.asset(
                cleanFallback,
                width: width,
                height: height,
                fit: fit,
                errorBuilder: (_, _, _) => errorWidget ?? _buildPlaceholder(),
              );
            }
            return _buildNetworkImage(fallbackUrl!);
          }
          return errorWidget ?? _buildPlaceholder();
        },
      );
    } else {
      image = _buildNetworkImage(path);
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
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
