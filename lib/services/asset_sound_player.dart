import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:tiny_pop/services/sound_player.dart';

/// Plays bundled sound effects with [audioplayers].
class AssetSoundPlayer extends SoundPlayer {
  AssetSoundPlayer({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  static const popAssetPath = 'assets/sounds/pop.mp3';
  static const popSourcePath = 'sounds/pop.mp3';

  final AudioPlayer _player;
  bool? _popSoundAvailable;

  void _disablePopSound() {
    _popSoundAvailable = false;
  }

  Future<bool> _ensurePopSoundAvailable() async {
    if (_popSoundAvailable != null) {
      return _popSoundAvailable!;
    }

    try {
      final data = await rootBundle.load(popAssetPath);
      if (data.lengthInBytes == 0) {
        _disablePopSound();
        return false;
      }

      _popSoundAvailable = true;
      return true;
    } catch (_) {
      _disablePopSound();
      return false;
    }
  }

  @override
  Future<void> playPop() async {
    if (_popSoundAvailable == false) {
      return;
    }

    if (!await _ensurePopSoundAvailable()) {
      return;
    }

    try {
      await _player.stop();
      await _player.play(AssetSource(popSourcePath));
    } catch (_) {
      _disablePopSound();
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
