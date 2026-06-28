import 'dart:math';

import 'package:flutter/material.dart';

/// A short radial confetti burst for child-friendly tap feedback.
class PopBurst extends StatefulWidget {
  const PopBurst({
    required this.colors,
    required this.onComplete,
    super.key,
  });

  final List<Color> colors;
  final VoidCallback onComplete;

  static const duration = Duration(milliseconds: 680);

  @override
  State<PopBurst> createState() => _PopBurstState();
}

class _PopBurstState extends State<PopBurst> with SingleTickerProviderStateMixin {
  static const _particleCount = 24;
  static const _spread = 98.0;
  static const _gravity = 38.0;

  late final AnimationController _controller;
  late final List<_BurstParticle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = _BurstParticle.generate(
      count: _particleCount,
      colors: widget.colors,
    );
    _controller = AnimationController(vsync: this, duration: PopBurst.duration)
      ..forward().whenComplete(widget.onComplete);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final raw = _controller.value;
        final progress = Curves.easeOutExpo.transform(raw);
        final elasticProgress = Curves.elasticOut.transform(raw.clamp(0.0, 0.85) / 0.85);

        return CustomPaint(
          painter: _BurstPainter(
            progress: progress,
            elasticProgress: elasticProgress,
            rawProgress: raw,
            particles: _particles,
            spread: _spread,
            gravity: _gravity,
          ),
        );
      },
    );
  }
}

enum _ParticleShape { circle, strip, star }

class _BurstParticle {
  const _BurstParticle({
    required this.angle,
    required this.color,
    required this.size,
    required this.shape,
    required this.spin,
    required this.speed,
    required this.delay,
  });

  final double angle;
  final Color color;
  final double size;
  final _ParticleShape shape;
  final double spin;
  final double speed;
  final double delay;

  static List<_BurstParticle> generate({
    required int count,
    required List<Color> colors,
  }) {
    final random = Random();
    return List.generate(count, (index) {
      final shapeRoll = index % 6;
      return _BurstParticle(
        angle: random.nextDouble() * pi * 2,
        color: colors[random.nextInt(colors.length)],
        size: 4 + random.nextDouble() * (index.isEven ? 11 : 8),
        shape: shapeRoll == 0
            ? _ParticleShape.star
            : shapeRoll.isEven
                ? _ParticleShape.circle
                : _ParticleShape.strip,
        spin: random.nextDouble() * pi,
        speed: 0.7 + random.nextDouble() * 0.55,
        delay: random.nextDouble() * 0.12,
      );
    });
  }
}

class _BurstPainter extends CustomPainter {
  const _BurstPainter({
    required this.progress,
    required this.elasticProgress,
    required this.rawProgress,
    required this.particles,
    required this.spread,
    required this.gravity,
  });

  final double progress;
  final double elasticProgress;
  final double rawProgress;
  final List<_BurstParticle> particles;
  final double spread;
  final double gravity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final opacity = (1 - Curves.easeInCubic.transform(rawProgress)).clamp(0.0, 1.0);

    if (rawProgress < 0.4) {
      final flashT = (1 - rawProgress / 0.4).clamp(0.0, 1.0);
      canvas.drawCircle(
        center,
        22 * flashT,
        Paint()..color = Colors.white.withOpacity(0.4 * flashT),
      );
      canvas.drawCircle(
        center,
        12 * flashT,
        Paint()..color = Colors.white.withOpacity(0.55 * flashT),
      );
    }

    if (rawProgress < 0.55) {
      final ringT = Curves.easeOut.transform(rawProgress / 0.55);
      final ringPaint = Paint()
        ..color = Colors.white.withOpacity((1 - ringT) * 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(center, 14 + ringT * 36, ringPaint);
    }

    for (final particle in particles) {
      final localProgress =
          ((progress - particle.delay) / (1 - particle.delay)).clamp(0.0, 1.0);
      if (localProgress <= 0) {
        continue;
      }

      final burstProgress = Curves.easeOutBack.transform(localProgress);
      final distance = spread * burstProgress * particle.speed;
      final particleScale = 0.4 + 0.6 * Curves.elasticOut.transform(localProgress);

      final position = center +
          Offset(
            cos(particle.angle) * distance,
            sin(particle.angle) * distance + gravity * localProgress,
          );

      final paint = Paint()
        ..color = particle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      switch (particle.shape) {
        case _ParticleShape.circle:
          canvas.drawCircle(
            position,
            particle.size * 0.5 * particleScale,
            paint,
          );
        case _ParticleShape.strip:
          canvas.save();
          canvas.translate(position.dx, position.dy);
          canvas.rotate(particle.spin + localProgress * pi * 3);
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: particle.size * particleScale,
                height: particle.size * 0.55 * particleScale,
              ),
              const Radius.circular(2),
            ),
            paint,
          );
          canvas.restore();
        case _ParticleShape.star:
          _drawStar(
            canvas,
            position,
            particle.size * 0.55 * particleScale,
            paint,
          );
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    const points = 4;
    final path = Path();
    for (var i = 0; i < points * 2; i++) {
      final angle = (i * pi / points) - pi / 2;
      final radiusScale = i.isEven ? 1.0 : 0.45;
      final point = center +
          Offset(cos(angle) * radius * radiusScale, sin(angle) * radius * radiusScale);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BurstPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.elasticProgress != elasticProgress ||
        oldDelegate.rawProgress != rawProgress;
  }
}
