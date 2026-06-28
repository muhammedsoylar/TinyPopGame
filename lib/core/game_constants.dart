import 'package:flutter/material.dart';

abstract final class GameConstants {
  static const gameDurationSeconds = 60;
  static const popAnimationDuration = Duration(milliseconds: 180);
  static const boxMoveDuration = Duration(milliseconds: 220);
  static const boxMoveCurve = Curves.easeOutBack;
  static const boxMoveTiltDuration = Duration(milliseconds: 220);
  static const burstOverlaySize = 176.0;

  // Gift box idle float (6–8 px, 2.5 s easeInOut loop)
  static const giftIdleDuration = Duration(milliseconds: 2500);
  static const giftFloatAmplitude = 7.0;

  // Tap squash & stretch
  static const giftTapSquashScaleX = 0.92;
  static const giftTapStretchScaleY = 1.08;
  static const giftTapDuration = Duration(milliseconds: 320);

  // Gentle screen shake on pop
  static const shakeDuration = Duration(milliseconds: 80);
  static const shakeMaxOffset = 2.5;

  // Confetti burst
  static const burstLifetime = Duration(milliseconds: 450);
  static const burstParticleCount = 36;

  static const initialBoxX = 120.0;
  static const initialBoxY = 220.0;
  static const initialBoxSize = 110.0;

  static const minBoxSize = 80.0;
  static const boxSizeRange = 70;
  static const maxBoxX = 250.0;
  static const minBoxY = 150.0;
  static const boxYRange = 400.0;

  /// See [BackgroundLayer] playfield bounds for background decor margins.

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
