import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tiny_pop/core/game_constants.dart';

class GiftBox extends StatefulWidget {
  const GiftBox({
    required this.size,
    required this.color,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  static const tapKey = Key('gift-box');

  final double size;
  final Color color;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  State<GiftBox> createState() => _GiftBoxState();
}

class _GiftBoxState extends State<GiftBox> with TickerProviderStateMixin {
  static const _idleDuration = Duration(milliseconds: 2000);
  static const _tapDuration = Duration(milliseconds: 260);
  static const _floatAmplitude = 6.0;
  static const _idleTiltAmplitude = 0.045;

  late final AnimationController _idleController;
  late final AnimationController _tapController;
  late final Animation<double> _tapScaleX;
  late final Animation<double> _tapScaleY;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(vsync: this, duration: _idleDuration);
    _tapController = AnimationController(vsync: this, duration: _tapDuration);

    _tapScaleX = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.16).chain(CurveTween(curve: Curves.easeIn)),
        weight: 28,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.16, end: 0.93).chain(CurveTween(curve: Curves.easeOut)),
        weight: 32,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.93, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(_tapController);

    _tapScaleY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.74).chain(CurveTween(curve: Curves.easeIn)),
        weight: 28,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.74, end: 1.1).chain(CurveTween(curve: Curves.easeOut)),
        weight: 32,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(_tapController);

    if (widget.isActive) {
      _idleController.repeat();
    }
  }

  @override
  void didUpdateWidget(GiftBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_idleController.isAnimating) {
      _idleController.repeat();
    } else if (!widget.isActive) {
      _idleController.stop();
    }
  }

  @override
  void dispose() {
    _idleController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isActive || widget.onTap == null) {
      return;
    }

    _tapController.forward(from: 0);
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_idleController, _tapController]),
      builder: (context, child) {
        final idlePhase = _idleController.value * 2 * pi;
        final isIdle = widget.isActive;

        final floatY = isIdle ? sin(idlePhase) * _floatAmplitude : 0.0;
        final idleTilt = isIdle ? sin(idlePhase * 0.85) * _idleTiltAmplitude : 0.0;
        final idleScale = isIdle ? 1.0 + sin(idlePhase) * 0.025 : 1.0;

        final shadowPulse = isIdle ? 0.6 + 0.4 * sin(idlePhase) : 1.0;
        final blurRadius = 6 + 10 * shadowPulse;
        final shadowOffsetY = 2 + 6 * shadowPulse;
        final shadowScale = 0.85 + 0.15 * shadowPulse;

        final scaleX = _tapScaleX.value * idleScale;
        final scaleY = _tapScaleY.value * idleScale;

        return Transform.translate(
          offset: Offset(0, floatY),
          child: Transform.rotate(
            angle: idleTilt,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.diagonal3Values(scaleX, scaleY, 1),
              child: GestureDetector(
                key: GiftBox.tapKey,
                behavior: HitTestBehavior.opaque,
                onTap: _handleTap,
                child: AnimatedContainer(
                  duration: GameConstants.popAnimationDuration,
                  curve: GameConstants.boxMoveCurve,
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: blurRadius,
                        spreadRadius: 1 * shadowPulse,
                        offset: Offset(0, shadowOffsetY),
                        color: Colors.black.withOpacity(
                          (0.12 + 0.14 * shadowPulse) * shadowScale,
                        ),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '🎁',
                      style: TextStyle(fontSize: 52),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
