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
  late final Animation<double> _idleFloat;
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
    _idleFloat = Tween<double>(
      begin: -GameConstants.giftFloatAmplitude,
      end: GameConstants.giftFloatAmplitude,
    ).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );

    _tapController = AnimationController(
      vsync: this,
      duration: GameConstants.giftTapDuration,
    );

    _tapScaleX = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: GameConstants.giftTapSquashScaleX)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: Tween(begin: GameConstants.giftTapSquashScaleX, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 82,
      ),
    ]).animate(_tapController);

    _tapScaleY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: GameConstants.giftTapStretchScaleY)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: Tween(begin: GameConstants.giftTapStretchScaleY, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 82,
      ),
    ]).animate(_tapController);

    if (widget.isActive) {
      _idleController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(GiftBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_idleController.isAnimating) {
      _idleController.repeat(reverse: true);
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

  double _shadowPulseScale(double floatY) {
    final normalized = (floatY + GameConstants.giftFloatAmplitude) /
        (GameConstants.giftFloatAmplitude * 2);
    return 0.86 + 0.14 * normalized;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_idleController, _tapController]),
      builder: (context, child) {
        final isIdle = widget.isActive;
        final floatY = isIdle ? _idleFloat.value : 0.0;
        final shadowPulse = isIdle ? _shadowPulseScale(floatY) : 1.0;
        final groundShadowWidth = widget.size * (0.58 + 0.18 * shadowPulse);
        final groundShadowOpacity = isIdle ? 0.09 + 0.11 * shadowPulse : 0.16;

        final scaleX = _tapScaleX.value;
        final scaleY = _tapScaleY.value;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: Offset(0, floatY),
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
                          blurRadius: 6 + 8 * shadowPulse,
                          spreadRadius: shadowPulse - 0.86,
                          offset: Offset(0, 3 + 2 * shadowPulse),
                          color: Colors.black.withOpacity(0.12 * shadowPulse),
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
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: groundShadowWidth,
              height: widget.size * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4 + 6 * shadowPulse,
                    spreadRadius: 0.5 + shadowPulse,
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
