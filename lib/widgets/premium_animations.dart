import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 3D Flip Card Animation for Calculator Cards
class FlipCard3D extends StatefulWidget {
  final Widget front;
  final Widget back;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const FlipCard3D({
    super.key,
    required this.front,
    required this.back,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<FlipCard3D> createState() => _FlipCard3DState();
}

class _FlipCard3DState extends State<FlipCard3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_showFront) {
      _controller.forward().then((_) {
        setState(() => _showFront = false);
      });
    } else {
      _controller.reverse().then((_) {
        setState(() => _showFront = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: () {
        _flip();
        widget.onLongPress?.call();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * math.pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: angle >= math.pi / 2
                ? Transform(
                    transform: Matrix4.identity()..rotateY(math.pi),
                    alignment: Alignment.center,
                    child: widget.back,
                  )
                : widget.front,
          );
        },
      ),
    );
  }
}

/// Magnetic Ripple Effect Widget
class MagneticRipple extends StatefulWidget {
  final Widget child;
  final Color rippleColor;

  const MagneticRipple({
    super.key,
    required this.child,
    required this.rippleColor,
  });

  @override
  State<MagneticRipple> createState() => _MagneticRippleState();
}

class _MagneticRippleState extends State<MagneticRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _tapPosition = details.localPosition;
        });
        _controller.forward(from: 0);
      },
      child: Stack(
        children: [
          widget.child,
          if (_tapPosition != null)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: RipplePainter(
                    position: _tapPosition!,
                    animation: _controller.value,
                    color: widget.rippleColor,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final Offset position;
  final double animation;
  final Color color;

  RipplePainter({
    required this.position,
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity((1 - animation) * 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final radius = math.max(size.width, size.height) * animation;
    canvas.drawCircle(position, radius, paint);

    // Second ripple
    if (animation > 0.3) {
      final paint2 = Paint()
        ..color = color.withOpacity((1 - animation) * 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      final radius2 = math.max(size.width, size.height) * (animation - 0.3);
      canvas.drawCircle(position, radius2, paint2);
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) => true;
}

/// Shimmer Overlay Effect
class ShimmerOverlay extends StatefulWidget {
  final Widget child;
  final bool isDark;

  const ShimmerOverlay({super.key, required this.child, required this.isDark});

  @override
  State<ShimmerOverlay> createState() => _ShimmerOverlayState();
}

class _ShimmerOverlayState extends State<ShimmerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
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
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 - _controller.value * 2, 0),
              end: Alignment(1.0 + _controller.value * 2, 0),
              colors: widget.isDark
                  ? [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.0),
                    ]
                  : [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.0),
                    ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

/// Breathing/Pulse Animation
class BreathingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const BreathingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<BreathingWidget> createState() => _BreathingWidgetState();
}

class _BreathingWidgetState extends State<BreathingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(scale: _animation.value, child: widget.child);
      },
    );
  }
}

/// Parallax Effect Container
class ParallaxContainer extends StatefulWidget {
  final Widget child;
  final double depth;

  const ParallaxContainer({super.key, required this.child, this.depth = 20.0});

  @override
  State<ParallaxContainer> createState() => _ParallaxContainerState();
}

class _ParallaxContainerState extends State<ParallaxContainer> {
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final size = renderBox.size;
        final localPosition = renderBox.globalToLocal(event.position);

        setState(() {
          _offset = Offset(
            (localPosition.dx - size.width / 2) / size.width * widget.depth,
            (localPosition.dy - size.height / 2) / size.height * widget.depth,
          );
        });
      },
      onExit: (_) {
        setState(() {
          _offset = Offset.zero;
        });
      },
      child: TweenAnimationBuilder<Offset>(
        tween: Tween(begin: Offset.zero, end: _offset),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        builder: (context, offset, child) {
          return Transform.translate(offset: offset, child: widget.child);
        },
      ),
    );
  }
}

/// Glow Effect on Hover/Press
class GlowEffect extends StatefulWidget {
  final Widget child;
  final Color glowColor;

  const GlowEffect({super.key, required this.child, required this.glowColor});

  @override
  State<GlowEffect> createState() => _GlowEffectState();
}

class _GlowEffectState extends State<GlowEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(0.3 * _animation.value),
                blurRadius: 20 * _animation.value,
                spreadRadius: 5 * _animation.value,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}
