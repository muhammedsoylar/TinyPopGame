import 'package:flutter/material.dart';
import 'package:tiny_pop/services/asset_sound_player.dart';
import 'package:tiny_pop/services/game_audio.dart';
import 'package:tiny_pop/services/high_score_service.dart';
import 'package:tiny_pop/services/settings_storage.dart';
import 'package:tiny_pop/ui/main_menu_screen.dart';

class TinyPopApp extends StatefulWidget {
  const TinyPopApp({super.key});

  @override
  State<TinyPopApp> createState() => _TinyPopAppState();
}

class _TinyPopAppState extends State<TinyPopApp> {
  late final AssetSoundPlayer _soundPlayer = AssetSoundPlayer();
  late final GameAudio _gameAudio = GameAudio(
    player: _soundPlayer,
    storage: const SharedPreferencesSettingsStorage(),
  );
  late final HighScoreService _highScoreService = HighScoreService();

  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.wait([
      _highScoreService.load(),
      _gameAudio.load(),
    ]);

    if (!mounted) {
      return;
    }

    setState(() => _isReady = true);
  }

  @override
  void dispose() {
    _soundPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SizedBox.shrink(),
      );
    }

    return HighScoreScope(
      notifier: _highScoreService,
      child: GameAudioScope(
        notifier: _gameAudio,
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MainMenuScreen(),
        ),
      ),
    );
  }
}
