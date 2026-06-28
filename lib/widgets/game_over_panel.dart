import 'package:flutter/material.dart';
import 'package:tiny_pop/core/app_colors.dart';
import 'package:tiny_pop/core/app_layout.dart';
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
    final panelRadius = AppLayout.spacing(context, AppSpacing.md);
    final starSize = AppLayout.spacing(context, AppSpacing.xxl);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppLayout.contentWidth(context),
          ),
          child: Material(
            elevation: AppLayout.spacing(context, AppSpacing.sm),
            borderRadius: BorderRadius.circular(panelRadius),
            color: AppColors.hudCardBackground,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppLayout.spacing(context, AppSpacing.lg),
                vertical: AppLayout.spacing(context, AppSpacing.md),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Game Over',
                    style: AppLayout.text(context, AppTypography.title),
                  ),
                  SizedBox(height: AppLayout.spacing(context, AppSpacing.sm)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_starCount, (index) {
                      final isFilled = index < earned;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppLayout.spacing(context, AppSpacing.xs / 2),
                        ),
                        child: ScaleTransition(
                          scale: isFilled
                              ? _starScales[index]
                              : const AlwaysStoppedAnimation(1),
                          child: Icon(
                            isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                            size: starSize,
                            color: isFilled ? AppColors.starFilled : AppColors.starEmpty,
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: AppLayout.spacing(context, AppSpacing.sm)),
                  Text(
                    'Final Score: ${widget.score}',
                    style: AppLayout.text(context, AppTypography.headline),
                  ),
                  SizedBox(height: AppLayout.spacing(context, AppSpacing.xs)),
                  Text(
                    'Best Score: ${widget.bestScore}',
                    style: AppLayout.text(
                      context,
                      AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.titlePurple,
                      ),
                    ),
                  ),
                  if (widget.isNewRecord) ...[
                    SizedBox(height: AppLayout.spacing(context, AppSpacing.xs)),
                    Text(
                      'New Record!',
                      style: AppLayout.text(
                        context,
                        AppTypography.headline.copyWith(
                          color: AppColors.hudScoreAccent,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: AppLayout.spacing(context, AppSpacing.md)),
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppLayout.spacing(context, AppSpacing.sm),
                        ),
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.playButtonOrange,
                            AppColors.playAgainGreen,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.playButtonOrange.withOpacity(0.35),
                            blurRadius: AppLayout.spacing(context, AppSpacing.sm),
                            offset: Offset(0, AppLayout.spacing(context, AppSpacing.xs)),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: widget.onPlayAgain,
                          borderRadius: BorderRadius.circular(
                            AppLayout.spacing(context, AppSpacing.sm),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppLayout.spacing(context, AppSpacing.sm),
                            ),
                            child: Center(
                              child: Text(
                                'Play Again',
                                style: AppLayout.text(context, AppTypography.buttonLarge),
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
          ),
        );
      },
    );
  }
}
