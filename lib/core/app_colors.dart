import 'package:flutter/material.dart';

abstract final class AppColors {
  static const gameBackground = Color(0xFFFFF8EC);

  /// Option A — minimal pastel gradients (slightly softened for gift/confetti contrast).
  static const menuGradient = [
    Color(0xFFFFF6E8),
    Color(0xFFFFECF4),
    Color(0xFFEAF3FF),
  ];

  static const gameGradient = [
    Color(0xFFFFF8EC),
    Color(0xFFFFEFF8),
    Color(0xFFEDF5FF),
  ];

  /// Bokeh decor palette at 15–25% opacity in [BackgroundLayer].
  static const menuBubble = [
    Color(0xFFFF6B6B),
    Color(0xFFFFD93D),
    Color(0xFF6BCB77),
    Color(0xFF4D96FF),
    Color(0xFFB983FF),
  ];

  static const titlePurple = Color(0xFF4A148C);
  static const subtitleBrown = Color(0xFF6D4C41);
  static const playButtonOrange = Color(0xFFFF7043);
  static const playAgainGreen = Color(0xFF43A047);

  static const hudCardBackground = Color(0xFFFFFFFF);
  static const hudScoreAccent = Color(0xFFFF7043);
  static const hudTimeAccent = Color(0xFF42A5F5);

  static const starFilled = Color(0xFFFFC107);
  static const starEmpty = Color(0xFFE0E0E0);

  static const overlayScrim = Color(0x61000000);

  static const backgroundCloud = Color(0xFFFFFFFF);
  static const backgroundBokehOpacity = 0.2;
  static const backgroundCloudOpacity = 0.05;
}
