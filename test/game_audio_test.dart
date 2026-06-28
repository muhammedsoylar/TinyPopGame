import 'package:flutter_test/flutter_test.dart';

import 'package:tiny_pop/services/game_audio.dart';
import 'package:tiny_pop/services/sound_player.dart';

class _FakeSoundPlayer extends SoundPlayer {
  _FakeSoundPlayer();

  int popCount = 0;

  @override
  Future<void> playPop() async {
    popCount++;
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
      final audio = GameAudio(player: player)..toggleEnabled();

      await audio.playPop();

      expect(player.popCount, 0);
    });

    test('toggleEnabled switches sound state', () {
      final audio = GameAudio(player: _FakeSoundPlayer());

      audio.toggleEnabled();
      expect(audio.isEnabled, isFalse);

      audio.toggleEnabled();
      expect(audio.isEnabled, isTrue);
    });
  });
}
