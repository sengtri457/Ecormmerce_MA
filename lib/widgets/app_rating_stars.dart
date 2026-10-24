import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';
import '../helpers/app_typography.dart';

class AppRatingStars extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double starSize;
  final double starSpacing;
  final Color color;
  final Color unratedColor;
  final bool isInteractive;
  final bool isCompact;
  final bool showLabel;
  final ValueChanged<double>? onRatingChanged;
  final TextStyle? textStyle;

  const AppRatingStars({
    super.key,
    required this.rating,
    this.reviewCount,
    this.starSize = 14.0,
    this.starSpacing = 2.0,
    this.color = const Color(0xFFE5A93C),
    this.unratedColor = const Color(0xFFD1D5DB),
    this.isInteractive = false,
    this.isCompact = false,
    this.showLabel = true,
    this.onRatingChanged,
    this.textStyle,
  });

  const AppRatingStars.compact({
    super.key,
    required this.rating,
    this.reviewCount,
    this.starSize = 13.0,
    this.starSpacing = 3.0,
    this.color = const Color(0xFFE5A93C),
    this.unratedColor = const Color(0xFFD1D5DB),
    this.showLabel = true,
    this.textStyle,
  }) : isInteractive = false,
       isCompact = true,
       onRatingChanged = null;

  const AppRatingStars.interactive({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.starSize = 28.0,
    this.starSpacing = 6.0,
    this.color = const Color(0xFFE5A93C),
    this.unratedColor = const Color(0xFFD1D5DB),
    this.showLabel = false,
    this.textStyle,
  }) : reviewCount = null,
       isInteractive = true,
       isCompact = false;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactView(context);
    }
    return _buildFullStarView(context);
  }

  Widget _buildCompactView(BuildContext context) {
    final formattedRating = rating.toStringAsFixed(1);
    final effectiveTextStyle =
        textStyle ??
        AppTypography.bodySmall.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.star_rounded, size: starSize, color: color),
        SizedBox(width: starSpacing),
        Text(formattedRating, style: effectiveTextStyle),
        if (showLabel && reviewCount != null) ...[
          const SizedBox(width: 2),
          Text(
            '($reviewCount)',
            style: effectiveTextStyle.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              fontSize: (effectiveTextStyle.fontSize ?? 11) - 1,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFullStarView(BuildContext context) {
    final effectiveTextStyle =
        textStyle ??
        AppTypography.headingSmall.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        );

    final stars = List.generate(5, (index) {
      final starNumber = index + 1;
      IconData iconData;
      Color iconColor;

      if (rating >= starNumber) {
        iconData = Icons.star_rounded;
        iconColor = color;
      } else if (rating >= starNumber - 0.5) {
        iconData = Icons.star_half_rounded;
        iconColor = color;
      } else {
        iconData = Icons.star_rounded;
        iconColor = unratedColor;
      }

      final starIcon = Icon(iconData, size: starSize, color: iconColor);

      if (!isInteractive) {
        return Padding(
          padding: EdgeInsets.only(right: index < 4 ? starSpacing : 0),
          child: starIcon,
        );
      }

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onRatingChanged?.call(starNumber.toDouble()),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: starSpacing / 2),
          child: starIcon,
        ),
      );
    });

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(mainAxisSize: MainAxisSize.min, children: stars),
        if (showLabel) ...[
          const SizedBox(width: 6),
          Text(rating.toStringAsFixed(1), style: effectiveTextStyle),
          if (reviewCount != null) ...[
            const SizedBox(width: 4),
            Text(
              '($reviewCount reviews)',
              style: effectiveTextStyle.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                fontSize: (effectiveTextStyle.fontSize ?? 13) - 1,
              ),
            ),
          ],
        ],
      ],
    );
  }
}
