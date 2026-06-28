import 'package:flutter/foundation.dart';
import 'package:tiny_pop/services/sound_player.dart';

/// Temporary sound backend until real audio assets are wired up.
class PlaceholderSoundPlayer extends SoundPlayer {
  const PlaceholderSoundPlayer();

  @override
  Future<void> playPop() async {
    assert(() {
      debugPrint('[GameAudio] pop sound placeholder');
      return true;
    }());
  }
}
