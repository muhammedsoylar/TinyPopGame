import 'package:flutter/material.dart';
import 'package:tiny_pop/core/app_colors.dart';
import 'package:tiny_pop/core/app_spacing.dart';
import 'package:tiny_pop/core/app_typography.dart';

class GameHud extends StatelessWidget {
  const GameHud({
    required this.score,
    required this.remainingSeconds,
    super.key,
  });

  final int score;
  final int remainingSeconds;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: AppSpacing.sm,
          left: AppSpacing.sm,
          child: _HudCard(
            accentColor: AppColors.hudScoreAccent,
            icon: Icons.star_rounded,
            label: 'Score',
            value: 'Score: $score',
          ),
        ),
        Positioned(
          top: AppSpacing.sm,
          right: AppSpacing.sm,
          child: _HudCard(
            accentColor: AppColors.hudTimeAccent,
            icon: Icons.timer_rounded,
            label: 'Time',
            value: 'Time: $remainingSeconds',
          ),
        ),
      ],
    );
  }
}

class _HudCard extends StatelessWidget {
  const _HudCard({
    required this.accentColor,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Color accentColor;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.hudCardBackground.withOpacity(0.94),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: accentColor.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.18),
            blurRadius: AppSpacing.sm,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSpacing.xl,
              height: AppSpacing.xl,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppSpacing.xs),
              ),
              child: Icon(icon, color: accentColor, size: AppSpacing.md),
            ),
            const SizedBox(width: AppSpacing.xs),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTypography.body.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                    letterSpacing: 0.6,
                  ),
                ),
                Text(value, style: AppTypography.hudValue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
