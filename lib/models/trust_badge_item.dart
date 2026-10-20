import 'package:flutter/widgets.dart';

/// Represents a customer trust badge with an icon, title, and descriptive subtitle.
class TrustBadgeItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const TrustBadgeItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
