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

  static const duration = Duration(milliseconds: 720);

  @override
  State<PopBurst> createState() => _PopBurstState();
}

class _PopBurstState extends State<PopBurst> with SingleTickerProviderStateMixin {
  static const _particleCount = 28;
  static const _sparkCount = 10;
  static const _spread = 108.0;
  static const _gravity = 42.0;

  late final AnimationController _controller;
  late final List<_BurstParticle> _particles;
  late final List<_SparkParticle> _sparks;

  @override
  void initState() {
    super.initState();
    _particles = _BurstParticle.generate(
      count: _particleCount,
      colors: widget.colors,
    );
    _sparks = _SparkParticle.generate(count: _sparkCount);
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
        final elasticProgress = Curves.elasticOut.transform(raw.clamp(0.0, 0.82) / 0.82);

        return CustomPaint(
          painter: _BurstPainter(
            progress: progress,
            elasticProgress: elasticProgress,
            rawProgress: raw,
            particles: _particles,
            sparks: _sparks,
            spread: _spread,
            gravity: _gravity,
            accentColor: widget.colors.first,
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
        size: 4 + random.nextDouble() * (index.isEven ? 12 : 9),
        shape: shapeRoll == 0
            ? _ParticleShape.star
            : shapeRoll.isEven
                ? _ParticleShape.circle
                : _ParticleShape.strip,
        spin: random.nextDouble() * pi,
        speed: 0.65 + random.nextDouble() * 0.6,
        delay: random.nextDouble() * 0.14,
      );
    });
  }
}

class _SparkParticle {
  const _SparkParticle({
    required this.angle,
    required this.speed,
    required this.delay,
  });

  final double angle;
  final double speed;
  final double delay;

  static List<_SparkParticle> generate({required int count}) {
    final random = Random();
    return List.generate(count, (index) {
      return _SparkParticle(
        angle: (index / count) * pi * 2 + random.nextDouble() * 0.4,
        speed: 0.55 + random.nextDouble() * 0.45,
        delay: random.nextDouble() * 0.08,
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
    required this.sparks,
    required this.spread,
    required this.gravity,
    required this.accentColor,
  });

  final double progress;
  final double elasticProgress;
  final double rawProgress;
  final List<_BurstParticle> particles;
  final List<_SparkParticle> sparks;
  final double spread;
  final double gravity;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final opacity = (1 - Curves.easeInCubic.transform(rawProgress)).clamp(0.0, 1.0);

    if (rawProgress < 0.45) {
      final flashT = (1 - rawProgress / 0.45).clamp(0.0, 1.0);
      canvas.drawCircle(
        center,
        26 * flashT * elasticProgress,
        Paint()..color = Colors.white.withOpacity(0.45 * flashT),
      );
      canvas.drawCircle(
        center,
        14 * flashT,
        Paint()..color = accentColor.withOpacity(0.35 * flashT),
      );
      canvas.drawCircle(
        center,
        8 * flashT,
        Paint()..color = Colors.white.withOpacity(0.7 * flashT),
      );
    }

    if (rawProgress < 0.65) {
      final ringT = Curves.easeOut.transform(rawProgress / 0.65);
      final ringPaint = Paint()
        ..color = Colors.white.withOpacity((1 - ringT) * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawCircle(center, 12 + ringT * 42, ringPaint);

      final innerRingPaint = Paint()
        ..color = accentColor.withOpacity((1 - ringT) * 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(center, 8 + ringT * 24, innerRingPaint);
    }

    for (final spark in sparks) {
      final localProgress =
          ((progress - spark.delay) / (1 - spark.delay)).clamp(0.0, 1.0);
      if (localProgress <= 0) {
        continue;
      }

      final distance = spread * 0.85 * Curves.easeOut.transform(localProgress) * spark.speed;
      final position = center +
          Offset(
            cos(spark.angle) * distance,
            sin(spark.angle) * distance,
          );
      final sparkOpacity = (1 - localProgress) * opacity;
      canvas.drawCircle(
        position,
        1.5 + (1 - localProgress) * 1.2,
        Paint()..color = Colors.white.withOpacity(sparkOpacity * 0.9),
      );
    }

    for (final particle in particles) {
      final localProgress =
          ((progress - particle.delay) / (1 - particle.delay)).clamp(0.0, 1.0);
      if (localProgress <= 0) {
        continue;
      }

      final burstProgress = Curves.easeOutBack.transform(localProgress);
      final distance = spread * burstProgress * particle.speed;
      final particleScale = 0.35 + 0.65 * Curves.elasticOut.transform(localProgress);
      final fall = gravity * pow(localProgress, 1.35);

      final position = center +
          Offset(
            cos(particle.angle) * distance,
            sin(particle.angle) * distance + fall,
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
          canvas.rotate(particle.spin + localProgress * pi * 3.5);
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: particle.size * particleScale,
                height: particle.size * 0.5 * particleScale,
              ),
              const Radius.circular(2),
            ),
            paint,
          );
          canvas.restore();
        case _ParticleShape.star:
          canvas.save();
          canvas.translate(position.dx, position.dy);
          canvas.rotate(particle.spin + localProgress * pi * 2);
          _drawStar(
            canvas,
            Offset.zero,
            particle.size * 0.55 * particleScale,
            paint,
          );
          canvas.restore();
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
