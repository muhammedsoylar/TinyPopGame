import 'package:flutter/material.dart';

abstract final class GameConstants {
  static const gameDurationSeconds = 60;
  static const popAnimationDuration = Duration(milliseconds: 180);
  static const boxMoveDuration = Duration(milliseconds: 460);
  static const boxMoveCurve = Curves.easeOutCubic;
  static const boxMoveTiltDuration = Duration(milliseconds: 520);
  static const burstOverlaySize = 208.0;

  // Gift box idle feel
  static const giftIdleDuration = Duration(milliseconds: 2400);
  static const giftFloatAmplitude = 5.0;
  static const giftIdleTiltAmplitude = 0.038;
  static const giftIdleBreatheScale = 0.018;

  // Tap squash & stretch
  static const giftTapDuration = Duration(milliseconds: 280);

  // Screen shake on pop
  static const shakeDuration = Duration(milliseconds: 260);
  static const shakeMaxOffset = 4.0;

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
