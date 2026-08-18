import 'package:flutter/material.dart';

/// Represents a single clickable or static step in a hierarchical navigation breadcrumb.
class BreadcrumbItem {
  /// The localized label to display in the breadcrumb trail.
  final String label;

  /// Optional route path to navigate to when tapped.
  final String? route;

  /// Optional custom callback when this breadcrumb item is clicked.
  final VoidCallback? onTap;

  const BreadcrumbItem({
    required this.label,
    this.route,
    this.onTap,
  });
}
