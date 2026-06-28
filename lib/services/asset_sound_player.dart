import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tiny_pop/services/sound_player.dart';

/// Plays bundled sound effects with [audioplayers].
class AssetSoundPlayer extends SoundPlayer {
  AssetSoundPlayer({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  static const popAssetPath = 'assets/sounds/pop.mp3';
  static const popSourcePath = 'sounds/pop.mp3';

  final AudioPlayer _player;
  bool? _popSoundAvailable;
  bool _hasLoggedFailure = false;

  void _disablePopSound([Object? error]) {
    _popSoundAvailable = false;
    if (_hasLoggedFailure) {
      return;
    }

    _hasLoggedFailure = true;
    assert(() {
      debugPrint('[AssetSoundPlayer] pop sound disabled: $error');
      return true;
    }());
  }

  Future<bool> _ensurePopSoundAvailable() async {
    if (_popSoundAvailable != null) {
      return _popSoundAvailable!;
    }

    try {
      final data = await rootBundle.load(popAssetPath);
      if (data.lengthInBytes == 0) {
        _disablePopSound('empty asset');
        return false;
      }

      _popSoundAvailable = true;
      return true;
    } catch (error) {
      _disablePopSound(error);
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
    } catch (error) {
      _disablePopSound(error);
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
