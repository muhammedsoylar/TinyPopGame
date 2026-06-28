import 'package:flutter/material.dart';
import 'package:tiny_pop/core/game_constants.dart';
import 'package:tiny_pop/models/active_burst.dart';

class GameState {
  const GameState({
    required this.score,
    required this.remainingSeconds,
    required this.isActive,
    required this.boxX,
    required this.boxY,
    required this.boxSize,
    required this.boxColor,
    required this.activeBursts,
  });

  factory GameState.initial() {
    return const GameState(
      score: 0,
      remainingSeconds: GameConstants.gameDurationSeconds,
      isActive: true,
      boxX: GameConstants.initialBoxX,
      boxY: GameConstants.initialBoxY,
      boxSize: GameConstants.initialBoxSize,
      boxColor: GameConstants.initialBoxColor,
      activeBursts: [],
    );
  }

  final int score;
  final int remainingSeconds;
  final bool isActive;
  final double boxX;
  final double boxY;
  final double boxSize;
  final Color boxColor;
  final List<ActiveBurst> activeBursts;

  GameState copyWith({
    int? score,
    int? remainingSeconds,
    bool? isActive,
    double? boxX,
    double? boxY,
    double? boxSize,
    Color? boxColor,
    List<ActiveBurst>? activeBursts,
  }) {
    return GameState(
      score: score ?? this.score,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isActive: isActive ?? this.isActive,
      boxX: boxX ?? this.boxX,
      boxY: boxY ?? this.boxY,
      boxSize: boxSize ?? this.boxSize,
      boxColor: boxColor ?? this.boxColor,
      activeBursts: activeBursts ?? this.activeBursts,
    );
  }
}
