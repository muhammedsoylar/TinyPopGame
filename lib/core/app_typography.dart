import 'package:flutter/material.dart';
import 'package:tiny_pop/core/app_colors.dart';

/// Shared typography scale for a cohesive children's-game look.
abstract final class AppTypography {
  static const display = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w900,
    height: 1.1,
    letterSpacing: 0.5,
    color: AppColors.titlePurple,
  );

  static const title = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.15,
    color: AppColors.titlePurple,
  );

  static const headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: AppColors.titlePurple,
  );

  static const bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.subtitleBrown,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.subtitleBrown,
  );

  static const hudValue = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    height: 1.1,
    color: AppColors.titlePurple,
  );

  static const buttonLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: 0.5,
    color: Colors.white,
  );

  static const button = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: 0.4,
    color: Colors.white,
  );
}
