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
  late final AnimationController _idleController;
  late final AnimationController _tapController;
  late final Animation<double> _tapScaleX;
  late final Animation<double> _tapScaleY;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: GameConstants.giftIdleDuration,
    );
    _tapController = AnimationController(
      vsync: this,
      duration: GameConstants.giftTapDuration,
    );

    _tapScaleX = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.18).chain(CurveTween(curve: Curves.easeIn)),
        weight: 26,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.18, end: 0.9).chain(CurveTween(curve: Curves.easeOut)),
        weight: 34,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.9, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(_tapController);

    _tapScaleY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.72).chain(CurveTween(curve: Curves.easeIn)),
        weight: 26,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.72, end: 1.12).chain(CurveTween(curve: Curves.easeOut)),
        weight: 34,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.12, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)),
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

        final floatWave = isIdle ? sin(idlePhase) : 0.0;
        final floatY = floatWave * GameConstants.giftFloatAmplitude;
        final idleTilt =
            isIdle ? sin(idlePhase * 0.82) * GameConstants.giftIdleTiltAmplitude : 0.0;
        final idleScale =
            isIdle ? 1.0 + floatWave * GameConstants.giftIdleBreatheScale : 1.0;

        final shadowPulse = isIdle ? 0.55 + 0.45 * sin(idlePhase + pi) : 1.0;
        final groundShadowWidth = widget.size * (0.62 + 0.14 * shadowPulse);
        final groundShadowOpacity = isIdle ? 0.1 + 0.12 * shadowPulse : 0.16;

        final scaleX = _tapScaleX.value * idleScale;
        final scaleY = _tapScaleY.value * idleScale;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
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
                            blurRadius: 8 + 6 * shadowPulse,
                            spreadRadius: 0.5,
                            offset: const Offset(0, 4),
                            color: widget.color.withOpacity(0.35),
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
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: groundShadowWidth,
              height: widget.size * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6 + 8 * shadowPulse,
                    spreadRadius: 1,
                    color: Colors.black.withOpacity(groundShadowOpacity),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
