import 'package:flutter/material.dart';

/// Responsive layout helpers based on a reference phone width.
abstract final class AppLayout {
  static const referenceWidth = 390.0;
  static const maxContentWidth = 360.0;

  static double scaleOf(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width / referenceWidth).clamp(0.85, 1.2);
  }

  static double spacing(BuildContext context, double value) {
    return value * scaleOf(context);
  }

  static TextStyle text(BuildContext context, TextStyle style) {
    final fontSize = style.fontSize;
    if (fontSize == null) {
      return style;
    }

    return style.copyWith(fontSize: fontSize * scaleOf(context));
  }

  static double contentWidth(BuildContext context) {
    final available = MediaQuery.sizeOf(context).width - spacing(context, 32);
    return available.clamp(280.0, maxContentWidth * scaleOf(context));
  }
}
