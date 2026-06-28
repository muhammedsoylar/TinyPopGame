import 'package:flutter/material.dart';
import 'package:tiny_pop/core/app_colors.dart';
import 'package:tiny_pop/core/app_layout.dart';
import 'package:tiny_pop/core/app_spacing.dart';
import 'package:tiny_pop/core/app_typography.dart';
import 'package:tiny_pop/widgets/sound_toggle_button.dart';

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
    final inset = AppLayout.spacing(context, AppSpacing.sm);

    return Stack(
      children: [
        Positioned(
          top: inset,
          left: 0,
          right: 0,
          child: const Center(
            child: SoundToggleButton(),
          ),
        ),
        Positioned(
          top: inset,
          left: inset,
          child: _HudCard(
            accentColor: AppColors.hudScoreAccent,
            icon: Icons.star_rounded,
            label: 'Score',
            value: 'Score: $score',
          ),
        ),
        Positioned(
          top: inset,
          right: inset,
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
    final radius = AppLayout.spacing(context, AppSpacing.sm);
    final iconSize = AppLayout.spacing(context, AppSpacing.xl);
    final iconGlyphSize = AppLayout.spacing(context, AppSpacing.md);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.hudCardBackground.withOpacity(0.94),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: accentColor.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.18),
            blurRadius: AppLayout.spacing(context, AppSpacing.sm),
            offset: Offset(0, AppLayout.spacing(context, AppSpacing.xs / 2)),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppLayout.spacing(context, AppSpacing.sm),
          vertical: AppLayout.spacing(context, AppSpacing.xs),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppLayout.spacing(context, AppSpacing.xs)),
              ),
              child: Icon(icon, color: accentColor, size: iconGlyphSize),
            ),
            SizedBox(width: AppLayout.spacing(context, AppSpacing.xs)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppLayout.text(
                    context,
                    AppTypography.caption.copyWith(color: accentColor),
                  ),
                ),
                Text(
                  value,
                  style: AppLayout.text(context, AppTypography.hudValue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
