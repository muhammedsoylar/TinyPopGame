import 'package:flutter/material.dart';

abstract final class GameConstants {
  static const gameDurationSeconds = 60;
  static const popAnimationDuration = Duration(milliseconds: 180);
  static const boxMoveDuration = Duration(milliseconds: 420);
  static const boxMoveCurve = Curves.elasticOut;
  static const burstOverlaySize = 192.0;

  static const initialBoxX = 120.0;
  static const initialBoxY = 220.0;
  static const initialBoxSize = 110.0;

  static const minBoxSize = 80.0;
  static const boxSizeRange = 70;
  static const maxBoxX = 250.0;
  static const minBoxY = 150.0;
  static const boxYRange = 400.0;

  static const initialBoxColor = Colors.redAccent;

  static const boxColors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.yellowAccent,
  ];
}
