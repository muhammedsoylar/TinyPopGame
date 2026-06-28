import 'package:flutter/material.dart';
import 'package:tiny_pop/core/app_colors.dart';
import 'package:tiny_pop/core/app_spacing.dart';
import 'package:tiny_pop/core/app_typography.dart';

class GameOverPanel extends StatefulWidget {
  const GameOverPanel({
    required this.score,
    required this.bestScore,
    required this.isNewRecord,
    required this.onPlayAgain,
    super.key,
  });

  final int score;
  final int bestScore;
  final bool isNewRecord;
  final VoidCallback onPlayAgain;

  @override
  State<GameOverPanel> createState() => _GameOverPanelState();
}

class _GameOverPanelState extends State<GameOverPanel> with TickerProviderStateMixin {
  static const _starCount = 3;
  static const _starStagger = Duration(milliseconds: 120);

  late final List<AnimationController> _starControllers;
  late final List<Animation<double>> _starScales;

  @override
  void initState() {
    super.initState();
    _starControllers = List.generate(_starCount, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 520),
      );
    });

    _starScales = _starControllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    _playStarAnimations();
  }

  int _earnedStars(int score) {
    if (score >= 30) {
      return 3;
    }
    if (score >= 15) {
      return 2;
    }
    if (score >= 1) {
      return 1;
    }
    return 0;
  }

  Future<void> _playStarAnimations() async {
    final earned = _earnedStars(widget.score);
    for (var i = 0; i < earned; i++) {
      await Future<void>.delayed(_starStagger);
      if (!mounted) {
        return;
      }
      _starControllers[i].forward(from: 0);
    }
  }

  @override
  void dispose() {
    for (final controller in _starControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final earned = _earnedStars(widget.score);

    return Material(
      elevation: AppSpacing.sm,
      borderRadius: BorderRadius.circular(AppSpacing.md),
      color: AppColors.hudCardBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Game Over',
              style: AppTypography.display.copyWith(fontSize: 44),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_starCount, (index) {
                final isFilled = index < earned;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs / 2),
                  child: ScaleTransition(
                    scale: isFilled
                        ? _starScales[index]
                        : const AlwaysStoppedAnimation(1),
                    child: Icon(
                      isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: AppSpacing.xxl,
                      color: isFilled ? AppColors.starFilled : AppColors.starEmpty,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Final Score: ${widget.score}',
              style: AppTypography.headline,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Best Score: ${widget.bestScore}',
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.titlePurple,
              ),
            ),
            if (widget.isNewRecord) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                'New Record!',
                style: AppTypography.headline.copyWith(
                  color: AppColors.hudScoreAccent,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.playButtonOrange,
                      AppColors.playAgainGreen,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.playButtonOrange.withOpacity(0.35),
                      blurRadius: AppSpacing.sm,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onPlayAgain,
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Center(
                        child: Text(
                          'Play Again',
                          style: AppTypography.buttonLarge,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
