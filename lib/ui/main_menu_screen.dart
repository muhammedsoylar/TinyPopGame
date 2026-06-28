import 'package:flutter/material.dart';
import 'package:tiny_pop/core/app_colors.dart';
import 'package:tiny_pop/core/app_layout.dart';
import 'package:tiny_pop/core/app_spacing.dart';
import 'package:tiny_pop/core/app_typography.dart';
import 'package:tiny_pop/services/high_score_service.dart';
import 'package:tiny_pop/ui/game_screen.dart';
import 'package:tiny_pop/widgets/menu_bubble.dart';
import 'package:tiny_pop/widgets/sound_toggle_button.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  void _startGame(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const GameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scale = AppLayout.scaleOf(context);
    final contentWidth = AppLayout.contentWidth(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.menuGradient,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              for (var i = 0; i < AppColors.menuBubble.length; i++)
                Positioned(
                  top: AppLayout.spacing(context, AppSpacing.xl + (i * AppSpacing.xs)),
                  left: i.isEven ? AppLayout.spacing(context, AppSpacing.sm) : null,
                  right: i.isOdd ? AppLayout.spacing(context, AppSpacing.sm) : null,
                  child: MenuBubble(
                    color: AppColors.menuBubble[i],
                    size: AppLayout.spacing(context, AppSpacing.xl + (i * AppSpacing.xs / 2)),
                  ),
                ),
              Positioned(
                top: AppLayout.spacing(context, AppSpacing.xs),
                right: AppLayout.spacing(context, AppSpacing.xs),
                child: const SoundToggleButton(),
              ),
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppLayout.spacing(context, AppSpacing.lg),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: contentWidth,
                          maxHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '🎁',
                              style: TextStyle(fontSize: 72 * scale),
                            ),
                            SizedBox(height: AppLayout.spacing(context, AppSpacing.sm)),
                            Text(
                              'Tiny Pop',
                              textAlign: TextAlign.center,
                              style: AppLayout.text(context, AppTypography.display),
                            ),
                            SizedBox(height: AppLayout.spacing(context, AppSpacing.xs)),
                            Text(
                              'Tap the gifts as fast as you can!',
                              textAlign: TextAlign.center,
                              style: AppLayout.text(context, AppTypography.bodyLarge),
                            ),
                            SizedBox(height: AppLayout.spacing(context, AppSpacing.sm)),
                            ListenableBuilder(
                              listenable: HighScoreScope.of(context),
                              builder: (context, _) {
                                final highScore = HighScoreScope.of(context).highScore;
                                return Text(
                                  'Best Score: $highScore',
                                  style: AppLayout.text(
                                    context,
                                    AppTypography.headline.copyWith(
                                      color: AppColors.hudScoreAccent,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: AppLayout.spacing(context, AppSpacing.md)),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _startGame(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.playButtonOrange,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppLayout.spacing(context, AppSpacing.sm),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppLayout.spacing(context, AppSpacing.md),
                                    ),
                                  ),
                                  elevation: 6,
                                  textStyle: AppLayout.text(context, AppTypography.buttonLarge),
                                ),
                                child: const Text('Play'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
