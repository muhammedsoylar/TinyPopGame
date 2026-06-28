import 'package:tiny_pop/services/sound_player.dart';

/// Silent fallback when no sound backend is configured.
class PlaceholderSoundPlayer extends SoundPlayer {
  const PlaceholderSoundPlayer();

  @override
  Future<void> playPop() async {}
}
