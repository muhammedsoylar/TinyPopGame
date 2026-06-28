import 'package:flutter/material.dart';
import 'package:tiny_pop/core/app_colors.dart';
import 'package:tiny_pop/core/app_layout.dart';

/// Which screen layout the shared pastel background should use.
enum BackgroundVariant {
  menu,
  game,
}

/// Shared Option A (Minimal Pastel) background for menu and game screens.
///
/// Owns the gradient wash, bokeh circles, optional cloud blob, and slow
/// decorative drift. Gameplay content is passed as [child] on top.
class BackgroundLayer extends StatefulWidget {
  const BackgroundLayer({
    required this.variant,
    required this.child,
    super.key,
  });

  final BackgroundVariant variant;
  final Widget child;

  @override
  State<BackgroundLayer> createState() => _BackgroundLayerState();
}

class _BackgroundLayerState extends State<BackgroundLayer>
    with SingleTickerProviderStateMixin {
  static const _driftDuration = Duration(seconds: 14);

  late final AnimationController _driftController;

  @override
  void initState() {
    super.initState();
    _driftController = AnimationController(
      vsync: this,
      duration: _driftDuration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _driftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final playfield = _PlayfieldBounds.spawnRect(
      margin: AppLayout.spacing(context, _PlayfieldBounds.decorMargin),
    );

    return AnimatedBuilder(
      animation: _driftController,
      builder: (context, child) {
        final drift = Curves.easeInOut.transform(_driftController.value);

        return Stack(
          fit: StackFit.expand,
          children: [
            _PastelGradient(variant: widget.variant),
            if (widget.variant == BackgroundVariant.menu)
              _CloudBlob(
                top: size.height * 0.12 + drift * 6,
                left: size.width * 0.08,
                width: size.width * 0.55,
                height: size.height * 0.18,
              ),
            ..._BokehDecor.build(
              context: context,
              variant: widget.variant,
              size: size,
              playfield: playfield,
              drift: drift,
            ),
            if (child != null) child,
          ],
        );
      },
      child: widget.child,
    );
  }
}

/// Gift spawn bounds plus decor margin — keeps bokeh out of the playfield.
abstract final class _PlayfieldBounds {
  static const decorMargin = 24.0;

  static const minX = 0.0;
  static const maxX = 250.0;
  static const minY = 150.0;
  static const maxY = 550.0;
  static const maxBoxExtent = 150.0;

  static Rect spawnRect({required double margin}) {
    return Rect.fromLTRB(
      minX - margin,
      minY - margin,
      maxX + maxBoxExtent + margin,
      maxY + maxBoxExtent + margin,
    );
  }
}

class _PastelGradient extends StatelessWidget {
  const _PastelGradient({required this.variant});

  final BackgroundVariant variant;

  @override
  Widget build(BuildContext context) {
    final isMenu = variant == BackgroundVariant.menu;
    final colors = isMenu ? AppColors.menuGradient : AppColors.gameGradient;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isMenu ? Alignment.topLeft : Alignment.topCenter,
          end: isMenu ? Alignment.bottomRight : Alignment.bottomCenter,
          colors: colors,
        ),
      ),
    );
  }
}

abstract final class _BokehDecor {
  static List<Widget> build({
    required BuildContext context,
    required BackgroundVariant variant,
    required Size size,
    required Rect playfield,
    required double drift,
  }) {
    final specs = variant == BackgroundVariant.menu
        ? _menuSpecs(size)
        : _gameSpecs(size, playfield);

    return [
      for (var i = 0; i < specs.length; i++)
        Positioned(
          top: specs[i].top + (i.isEven ? drift * 8 : -drift * 6),
          left: specs[i].left,
          right: specs[i].right,
          child: _BackgroundBokeh(
            color: AppColors.menuBubble[i % AppColors.menuBubble.length],
            size: AppLayout.spacing(context, specs[i].size),
          ),
        ),
    ];
  }

  static List<_BokehSpec> _menuSpecs(Size size) {
    return [
      _BokehSpec(top: size.height * 0.08, left: size.width * 0.04, size: 44),
      _BokehSpec(top: size.height * 0.16, right: size.width * 0.05, size: 52),
      _BokehSpec(top: size.height * 0.28, left: size.width * 0.08, size: 38),
      _BokehSpec(top: size.height * 0.42, right: size.width * 0.07, size: 46),
      _BokehSpec(top: size.height * 0.62, left: size.width * 0.03, size: 40),
    ];
  }

  static List<_BokehSpec> _gameSpecs(Size size, Rect playfield) {
    final specs = <_BokehSpec>[];
    final candidates = [
      _BokehSpec(top: size.height * 0.06, left: size.width * 0.03, size: 36),
      _BokehSpec(top: size.height * 0.1, right: size.width * 0.04, size: 40),
      _BokehSpec(top: size.height * 0.78, left: size.width * 0.05, size: 34),
      _BokehSpec(top: size.height * 0.82, right: size.width * 0.06, size: 38),
    ];

    for (final candidate in candidates) {
      final center = Offset(
        candidate.left ?? (size.width - (candidate.right ?? 0) - candidate.size),
        candidate.top + candidate.size / 2,
      );
      if (!playfield.contains(center)) {
        specs.add(candidate);
      }
    }

    if (specs.length < 3) {
      specs.add(
        _BokehSpec(top: size.height * 0.04, right: size.width * 0.08, size: 32),
      );
    }

    return specs.take(4).toList();
  }
}

class _BokehSpec {
  const _BokehSpec({
    required this.top,
    required this.size,
    this.left,
    this.right,
  });

  final double top;
  final double? left;
  final double? right;
  final double size;
}

class _BackgroundBokeh extends StatelessWidget {
  const _BackgroundBokeh({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(AppColors.backgroundBokehOpacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CloudBlob extends StatelessWidget {
  const _CloudBlob({
    required this.top,
    required this.left,
    required this.width,
    required this.height,
  });

  final double top;
  final double left;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Transform.rotate(
        angle: -0.08,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.backgroundCloud.withOpacity(AppColors.backgroundCloudOpacity),
            borderRadius: BorderRadius.circular(height),
          ),
        ),
      ),
    );
  }
}
