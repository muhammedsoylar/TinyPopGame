import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tiny_pop/services/game_audio.dart';
import 'package:tiny_pop/core/app_colors.dart';
import 'package:tiny_pop/core/game_constants.dart';
import 'package:tiny_pop/game/game_controller.dart';
import 'package:tiny_pop/widgets/game_hud.dart';
import 'package:tiny_pop/widgets/game_over_panel.dart';
import 'package:tiny_pop/widgets/gift_box.dart';
import 'package:tiny_pop/widgets/pop_burst.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  static const _shakeDuration = Duration(milliseconds: 240);
  static const _moveTiltDuration = Duration(milliseconds: 480);
  static const _shakeMaxOffset = 3.5;
  static const _maxMoveTilt = 0.14;

  late final GameController _controller = GameController();
  late final AnimationController _shakeController;
  late final AnimationController _moveTiltController;

  double _moveTiltStart = 0;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(vsync: this, duration: _shakeDuration);
    _moveTiltController = AnimationController(
      vsync: this,
      duration: _moveTiltDuration,
    );
    _controller.start();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _moveTiltController.dispose();
    _controller.dispose();
    super.dispose();
  }

  double _tiltForMovement(double dx, double dy) {
    if (dx.abs() < 0.5 && dy.abs() < 0.5) {
      return 0;
    }

    final tilt = atan2(dy, dx) * 0.18;
    return tilt.clamp(-_maxMoveTilt, _maxMoveTilt);
  }

  void _handlePopBox() {
    final previous = _controller.state;

    GameAudioScope.of(context).playPop();
    _controller.popBox();

    final next = _controller.state;
    _moveTiltStart = _tiltForMovement(
      next.boxX - previous.boxX,
      next.boxY - previous.boxY,
    );

    _moveTiltController.forward(from: 0);
    _shakeController.forward(from: 0);
  }

  void _handleRemoveBurst(int id) {
    if (!mounted) {
      return;
    }

    _controller.removeBurst(id);
  }

  Offset _shakeOffset(double value) {
    final decay = pow(1 - value, 1.4).toDouble();
    return Offset(
      sin(value * pi * 8) * _shakeMaxOffset * decay,
      cos(value * pi * 7) * (_shakeMaxOffset - 0.8) * decay,
    );
  }

  double _moveTiltAngle() {
    final eased = Curves.elasticOut.transform(_moveTiltController.value);
    return _moveTiltStart * (1 - eased);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final state = _controller.state;

        return Scaffold(
          backgroundColor: AppColors.gameBackground,
          body: SafeArea(
            child: AnimatedBuilder(
              animation: Listenable.merge([_shakeController, _moveTiltController]),
              builder: (context, child) {
                return Transform.translate(
                  offset: _shakeOffset(_shakeController.value),
                  child: child,
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GameHud(
                    score: state.score,
                    remainingSeconds: state.remainingSeconds,
                  ),
                  for (final burst in state.activeBursts)
                    Positioned(
                      left: burst.center.dx - GameConstants.burstOverlaySize / 2,
                      top: burst.center.dy - GameConstants.burstOverlaySize / 2,
                      width: GameConstants.burstOverlaySize,
                      height: GameConstants.burstOverlaySize,
                      child: IgnorePointer(
                        child: PopBurst(
                          key: ValueKey(burst.id),
                          colors: GameConstants.boxColors,
                          onComplete: () => _handleRemoveBurst(burst.id),
                        ),
                      ),
                    ),
                  AnimatedPositioned(
                    duration: GameConstants.boxMoveDuration,
                    curve: GameConstants.boxMoveCurve,
                    left: state.boxX,
                    top: state.boxY,
                    child: Transform.rotate(
                      angle: _moveTiltAngle(),
                      child: GiftBox(
                        size: state.boxSize,
                        color: state.boxColor,
                        isActive: state.isActive,
                        onTap: _handlePopBox,
                      ),
                    ),
                  ),
                  if (!state.isActive)
                    Positioned.fill(
                      child: ColoredBox(
                        color: Colors.black38,
                        child: Center(
                          child: GameOverPanel(
                            score: state.score,
                            onPlayAgain: _controller.playAgain,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
