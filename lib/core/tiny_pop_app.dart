import 'package:flutter/material.dart';
import 'package:tiny_pop/services/asset_sound_player.dart';
import 'package:tiny_pop/services/game_audio.dart';
import 'package:tiny_pop/ui/main_menu_screen.dart';

class TinyPopApp extends StatefulWidget {
  const TinyPopApp({super.key});

  @override
  State<TinyPopApp> createState() => _TinyPopAppState();
}

class _TinyPopAppState extends State<TinyPopApp> {
  late final AssetSoundPlayer _soundPlayer = AssetSoundPlayer();
  late final GameAudio _gameAudio = GameAudio(player: _soundPlayer);

  @override
  void dispose() {
    _soundPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameAudioScope(
      notifier: _gameAudio,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainMenuScreen(),
      ),
    );
  }
}
