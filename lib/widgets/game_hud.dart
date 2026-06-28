import 'package:flutter/material.dart';

class GameHud extends StatelessWidget {
  const GameHud({
    required this.score,
    required this.remainingSeconds,
    super.key,
  });

  final int score;
  final int remainingSeconds;

  static const _labelStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 24,
          left: 24,
          child: Text(
            'Score: $score',
            style: _labelStyle,
          ),
        ),
        Positioned(
          top: 24,
          right: 24,
          child: Text(
            'Time: $remainingSeconds',
            style: _labelStyle,
          ),
        ),
      ],
    );
  }
}
