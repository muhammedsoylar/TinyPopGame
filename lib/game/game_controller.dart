import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tiny_pop/core/game_constants.dart';
import 'package:tiny_pop/models/active_burst.dart';
import 'package:tiny_pop/models/game_state.dart';

class GameController extends ChangeNotifier {
  GameController({Random? random}) : _random = random ?? Random();

  final Random _random;

  GameState _state = GameState.initial();
  Timer? _countdownTimer;
  int _nextBurstId = 0;

  GameState get state => _state;

  void start() {
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_state.isActive) {
        return;
      }

      final remainingSeconds = _state.remainingSeconds - 1;
      if (remainingSeconds <= 0) {
        _state = _state.copyWith(remainingSeconds: 0);
        _endGame();
      } else {
        _state = _state.copyWith(remainingSeconds: remainingSeconds);
      }
      notifyListeners();
    });
  }

  void _endGame() {
    _state = _state.copyWith(isActive: false);
    _countdownTimer?.cancel();
    notifyListeners();
  }

  void popBox() {
    if (!_state.isActive) {
      return;
    }

    final burstCenter = Offset(
      _state.boxX + _state.boxSize / 2,
      _state.boxY + _state.boxSize / 2,
    );

    _state = _state.copyWith(
      score: _state.score + 1,
      boxSize: GameConstants.minBoxSize +
          _random.nextInt(GameConstants.boxSizeRange).toDouble(),
      boxColor: GameConstants
          .boxColors[_random.nextInt(GameConstants.boxColors.length)],
      boxX: _random.nextDouble() * GameConstants.maxBoxX,
      boxY: GameConstants.minBoxY +
          _random.nextDouble() * GameConstants.boxYRange,
      activeBursts: [
        ..._state.activeBursts,
        ActiveBurst(id: _nextBurstId++, center: burstCenter),
      ],
    );
    notifyListeners();
  }

  void playAgain() {
    _state = GameState.initial();
    notifyListeners();
    _startCountdown();
  }

  void removeBurst(int id) {
    _state = _state.copyWith(
      activeBursts:
          _state.activeBursts.where((burst) => burst.id != id).toList(),
    );
    notifyListeners();
  }
}
