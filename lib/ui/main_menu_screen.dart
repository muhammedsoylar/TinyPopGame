import 'package:flutter/material.dart';
import 'package:tiny_pop/core/app_colors.dart';
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
                  top: 40.0 + (i * 48),
                  left: i.isEven ? 24 : null,
                  right: i.isOdd ? 24 : null,
                  child: MenuBubble(
                    color: AppColors.menuBubble[i],
                    size: 36 + (i * 6),
                  ),
                ),
              const Positioned(
                top: 8,
                right: 8,
                child: SoundToggleButton(),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '🎁',
                        style: TextStyle(fontSize: 72),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tiny Pop',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.titlePurple,
                              letterSpacing: 1.2,
                            ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Tap the gifts as fast as you can!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.subtitleBrown,
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _startGame(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.playButtonOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 6,
                            textStyle: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
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
