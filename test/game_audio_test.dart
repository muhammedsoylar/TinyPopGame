import 'package:flutter_test/flutter_test.dart';

import 'package:tiny_pop/services/game_audio.dart';
import 'package:tiny_pop/services/settings_storage.dart';
import 'package:tiny_pop/services/sound_player.dart';

class _FakeSoundPlayer extends SoundPlayer {
  _FakeSoundPlayer();

  int popCount = 0;

  @override
  Future<void> playPop() async {
    popCount++;
  }
}

class _MemorySettingsStorage implements SettingsStorage {
  _MemorySettingsStorage({this.initialEnabled = true});

  final bool initialEnabled;
  bool? _enabled;

  @override
  Future<bool> readSoundEnabled() async {
    return _enabled ?? initialEnabled;
  }

  @override
  Future<void> writeSoundEnabled(bool enabled) async {
    _enabled = enabled;
  }
}

void main() {
  group('GameAudio', () {
    test('is enabled by default', () {
      final audio = GameAudio(player: _FakeSoundPlayer());

      expect(audio.isEnabled, isTrue);
    });

    test('playPop triggers sound when enabled', () async {
      final player = _FakeSoundPlayer();
      final audio = GameAudio(player: player);

      await audio.playPop();

      expect(player.popCount, 1);
    });

    test('playPop is skipped when sound is disabled', () async {
      final player = _FakeSoundPlayer();
      final audio = GameAudio(player: player);
      await audio.toggleEnabled();

      await audio.playPop();

      expect(player.popCount, 0);
    });

    test('toggleEnabled switches sound state', () async {
      final audio = GameAudio(player: _FakeSoundPlayer());

      await audio.toggleEnabled();
      expect(audio.isEnabled, isFalse);

      await audio.toggleEnabled();
      expect(audio.isEnabled, isTrue);
    });

    test('load restores saved sound setting', () async {
      final storage = _MemorySettingsStorage(initialEnabled: false);
      final audio = GameAudio(
        player: _FakeSoundPlayer(),
        storage: storage,
        enabled: true,
      );

      await audio.load();

      expect(audio.isEnabled, isFalse);
    });

    test('toggleEnabled persists setting', () async {
      final storage = _MemorySettingsStorage();
      final audio = GameAudio(player: _FakeSoundPlayer(), storage: storage);

      await audio.toggleEnabled();

      expect(audio.isEnabled, isFalse);
      expect(await storage.readSoundEnabled(), isFalse);
    });
  });
}
