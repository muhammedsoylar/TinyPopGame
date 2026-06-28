import 'package:flutter/widgets.dart';
import 'package:tiny_pop/services/placeholder_sound_player.dart';
import 'package:tiny_pop/services/settings_storage.dart';
import 'package:tiny_pop/services/sound_player.dart';

/// Central audio settings and effect triggers for the game.
class GameAudio extends ChangeNotifier {
  GameAudio({
    SoundPlayer? player,
    SettingsStorage? storage,
    bool enabled = true,
  })  : _player = player ?? const PlaceholderSoundPlayer(),
        _storage = storage,
        _enabled = enabled;

  final SoundPlayer _player;
  final SettingsStorage? _storage;
  bool _enabled;

  bool get isEnabled => _enabled;

  Future<void> load() async {
    final storage = _storage;
    if (storage == null) {
      return;
    }

    _enabled = await storage.readSoundEnabled();
    notifyListeners();
  }

  Future<void> toggleEnabled() async {
    final nextEnabled = !_enabled;
    final storage = _storage;
    if (storage != null) {
      await storage.writeSoundEnabled(nextEnabled);
    }

    _enabled = nextEnabled;
    notifyListeners();
  }

  Future<void> playPop() {
    if (!_enabled) {
      return Future<void>.value();
    }

    return _player.playPop();
  }
}

/// Provides [GameAudio] to the widget tree.
class GameAudioScope extends InheritedNotifier<GameAudio> {
  const GameAudioScope({
    required GameAudio super.notifier,
    required super.child,
    super.key,
  });

  static GameAudio of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<GameAudioScope>();
    assert(scope != null, 'GameAudioScope not found in context');
    return scope!.notifier!;
  }
}
