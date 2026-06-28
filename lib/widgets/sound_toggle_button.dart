import 'package:flutter/material.dart';
import 'package:tiny_pop/core/app_colors.dart';
import 'package:tiny_pop/core/app_spacing.dart';
import 'package:tiny_pop/services/game_audio.dart';

class SoundToggleButton extends StatelessWidget {
  const SoundToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = GameAudioScope.of(context);

    return ListenableBuilder(
      listenable: audio,
      builder: (context, _) {
        final isEnabled = audio.isEnabled;

        return IconButton(
          tooltip: isEnabled ? 'Sound on' : 'Sound off',
          icon: Icon(
            isEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
            size: AppSpacing.lg,
          ),
          color: AppColors.titlePurple,
          onPressed: () {
            audio.toggleEnabled();
          },
        );
      },
    );
  }
}
