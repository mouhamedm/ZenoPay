import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _Particle {
  final double xOffset;
  final double delay;
  final double duration;
  final double scale;
  final String emoji;

  _Particle(this.xOffset, this.delay, this.duration, this.scale, this.emoji);
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  final Random _random = Random();
  final List<String> _emojis = ['💸'];
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    // 3 seconds total for the splash screen
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    // Generate 30 flying money particles
    _particles = List.generate(30, (index) {
      return _Particle(
        _random.nextDouble() * 2 - 1, // X position: -1.0 to 1.0
        _random.nextDouble() * 0.8, // Delay: starts between 0% and 80% of timeline
        0.4 + _random.nextDouble() * 0.4, // Duration: takes 40% to 80% of timeline to cross screen
        0.5 + _random.nextDouble() * 0.8, // Scale: random sizes
        _emojis[_random.nextInt(_emojis.length)],
      );
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacementNamed('/signup');
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: Stack(
          children: [
            // -- Background glow --
            Center(
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.gradientStart.withAlpha(30),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // -- Flying Money Particles --
            ..._particles.map((p) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double progress = (_controller.value - p.delay) / p.duration;
                  progress = progress.clamp(0.0, 1.0);

                  if (progress == 0.0 || progress == 1.0) {
                    return const SizedBox.shrink();
                  }

                  // Calculate Y position (starts below screen (1.2) to above screen (-1.2))
                  double yPos = 1.2 - (progress * 2.4);

                  // Opacity fade in and fade out
                  double opacity = 1.0;
                  if (progress < 0.2) opacity = progress / 0.2;
                  if (progress > 0.8) opacity = (1.0 - progress) / 0.2;

                  return Align(
                    alignment: Alignment(p.xOffset, yPos),
                    child: Transform.scale(
                      scale: p.scale,
                      child: Opacity(
                        opacity: opacity,
                        child: Text(p.emoji, style: const TextStyle(fontSize: 32)),
                      ),
                    ),
                  );
                },
              );
            }),

            // -- Zeno Pay Text & Progress Bar --
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnim,
                    child: Transform.scale(
                      scale: _scaleAnim.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Zeno Pay',
                            style: AppTextStyles.displayLarge.copyWith(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    AppColors.gradientStart,
                                    AppColors.gradientEnd,
                                  ],
                                ).createShader(const Rect.fromLTWH(0, 0, 300, 100)),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Adjusted width progress bar
                          SizedBox(
                            width: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: _controller.value,
                                backgroundColor: AppColors.surfaceElevated,
                                color: AppColors.gradientStart,
                                minHeight: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
