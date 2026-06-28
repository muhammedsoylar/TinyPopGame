import 'package:flutter/material.dart';
import 'package:tiny_pop/core/app_colors.dart';
import 'package:tiny_pop/core/app_spacing.dart';
import 'package:tiny_pop/core/app_typography.dart';
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
                  top: AppSpacing.xl + (i * AppSpacing.xs),
                  left: i.isEven ? AppSpacing.sm : null,
                  right: i.isOdd ? AppSpacing.sm : null,
                  child: MenuBubble(
                    color: AppColors.menuBubble[i],
                    size: AppSpacing.xl + (i * AppSpacing.xs / 2),
                  ),
                ),
              const Positioned(
                top: AppSpacing.xs,
                right: AppSpacing.xs,
                child: SoundToggleButton(),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '🎁',
                        style: TextStyle(fontSize: 72),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const Text(
                        'Tiny Pop',
                        textAlign: TextAlign.center,
                        style: AppTypography.display,
                      ),
                      const SizedBox(height: AppSpacing.xs + 4),
                      const Text(
                        'Tap the gifts as fast as you can!',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _startGame(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.playButtonOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.md),
                            ),
                            elevation: 6,
                            textStyle: AppTypography.buttonLarge,
                          ),
                          child: const Text('Play'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
