import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Animated gradient background with shimmer effect
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final bool isDark;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    required this.isDark,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
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
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.isDark
                  ? [
                      Color.lerp(
                        const Color(0xFF2C2C2C),
                        const Color(0xFF1A1A1A),
                        _controller.value,
                      )!,
                      Color.lerp(
                        const Color(0xFF1A1A1A),
                        const Color(0xFF2C2C2C),
                        _controller.value,
                      )!,
                    ]
                  : [
                      Color.lerp(
                        const Color(0xFFFF8C42),
                        const Color(0xFFFFAA00),
                        _controller.value,
                      )!,
                      Color.lerp(
                        const Color(0xFFFFD93D),
                        const Color(0xFFFFE57F),
                        _controller.value,
                      )!,
                    ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Floating particles background
class FloatingParticles extends StatefulWidget {
  final bool isDark;

  const FloatingParticles({super.key, required this.isDark});

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _initParticles();
  }

  void _initParticles() {
    final random = math.Random();
    final icons = ['₹', '\$', '€', '💰', '📊', '📈', '%', '💳', '💸'];
    for (int i = 0; i < 20; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          speed: 0.0001 + random.nextDouble() * 0.0003,
          size: 14 + random.nextDouble() * 18,
          icon: icons[random.nextInt(icons.length)],
          opacity: 0.08 + random.nextDouble() * 0.15,
          rotation: random.nextDouble() * math.pi * 2,
          rotationSpeed: (random.nextDouble() - 0.5) * 0.02,
        ),
      );
    }
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
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            animation: _controller.value,
            isDark: widget.isDark,
          ),
          child: Container(),
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  final double speed;
  final double size;
  final String icon;
  final double opacity;
  double rotation;
  final double rotationSpeed;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.icon,
    required this.opacity,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;
  final bool isDark;

  ParticlePainter({
    required this.particles,
    required this.animation,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Update particle position
      particle.y -= particle.speed;
      particle.rotation += particle.rotationSpeed;

      // Reset if particle goes off screen
      if (particle.y < -0.1) {
        particle.y = 1.1;
        particle.x = math.Random().nextDouble();
      }

      // Draw particle
      final textPainter = TextPainter(
        text: TextSpan(
          text: particle.icon,
          style: TextStyle(
            fontSize: particle.size,
            color: (isDark ? Colors.white : Colors.black).withOpacity(
              particle.opacity,
            ),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      canvas.save();
      canvas.translate(particle.x * size.width, particle.y * size.height);
      canvas.rotate(particle.rotation);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

/// Wave pattern overlay
class WavePattern extends StatefulWidget {
  final bool isDark;

  const WavePattern({super.key, required this.isDark});

  @override
  State<WavePattern> createState() => _WavePatternState();
}

class _WavePatternState extends State<WavePattern>
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
        return CustomPaint(
          painter: WavePainter(
            animation: _controller.value,
            isDark: widget.isDark,
          ),
          child: Container(),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double animation;
  final bool isDark;

  WavePainter({required this.animation, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.white).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 20.0;
    final waveLength = size.width / 2;

    path.moveTo(0, size.height);

    for (double i = 0; i <= size.width; i++) {
      path.lineTo(
        i,
        size.height -
            30 +
            math.sin((i / waveLength + animation * 2) * 2 * math.pi) *
                waveHeight,
      );
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Second wave
    final path2 = Path();
    path2.moveTo(0, size.height);

    for (double i = 0; i <= size.width; i++) {
      path2.lineTo(
        i,
        size.height -
            20 +
            math.sin((i / waveLength + animation * 2 + 0.5) * 2 * math.pi) *
                waveHeight *
                0.8,
      );
    }

    path2.lineTo(size.width, size.height);
    path2.close();

    final paint2 = Paint()
      ..color = (isDark ? Colors.white : Colors.white).withOpacity(0.05)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}
