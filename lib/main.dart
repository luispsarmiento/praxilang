import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const MuralCrossPlatformApp());
}

class MuralCrossPlatformApp extends StatelessWidget {
  const MuralCrossPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mural',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF9F6F0), // Mural warm background
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7B54),
          surface: const Color(0xFFF9F6F0),
        ),
        fontFamily: 'Roboto',
      ),
      home: const ResponsiveShell(child: MainNavigationScreen()),
    );
  }
}

/// Constrains layout on Flutter Web / Tablet (width > 480) while expanding
/// normally (full screen, no outer scaffold/backdrop) on Android mobile.
class ResponsiveShell extends StatelessWidget {
  final Widget child;
  const ResponsiveShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // On narrow screens (phones / Android mobile) render the child directly
        // so it becomes the root scaffold and fills the screen. Wrapping it in
        // an outer Scaffold + centered 480px column breaks layout and button
        // hit-testing on mobile.
        if (constraints.maxWidth <= 480) {
          return child;
        }
        return Scaffold(
          backgroundColor: const Color(0xFFECE7DF), // Subtle backdrop for desktop web gutters
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Container(
                color: const Color(0xFFF9F6F0),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TalkScreen(),
    Center(child: Text('Temas', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 16))),
    Center(child: Text('Vocabulario', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 16))),
    Center(child: Text('Ajustes', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 16))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9F6F0),
          border: Border(
            top: BorderSide(color: Colors.black.withValues(alpha:0.06), width: 1),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.mic_rounded, 'Hablar'),
                _buildNavItem(1, Icons.dashboard_outlined, 'Temas'),
                _buildNavItem(2, Icons.menu_book_rounded, 'Vocabulario'),
                _buildNavItem(3, Icons.tune_rounded, 'Ajustes'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? const Color(0xFF1E1E1E) : const Color(0xFF8E8E93);

    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: () => setState(() => _currentIndex = index),
          splashColor: Colors.transparent,
          highlightColor: Colors.black.withValues(alpha:0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TalkScreen extends StatefulWidget {
  const TalkScreen({super.key});

  @override
  State<TalkScreen> createState() => _TalkScreenState();
}

class _TalkScreenState extends State<TalkScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Header Bar: Language dropdown & options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  elevation: 1,
                  shadowColor: Colors.black.withValues(alpha:0.12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    mouseCursor: SystemMouseCursors.click,
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🇪🇸', style: TextStyle(fontSize: 16)),
                          SizedBox(width: 8),
                          Text(
                            'Español',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C2C2E),
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFF8E8E93)),
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF2C2C2E)),
                    mouseCursor: SystemMouseCursors.click,
                    onPressed: () {},
                  ),
                ),
              ],
            ),

            const Spacer(flex: 2),

            // Animated Breathing Organic Gradient Orb
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => setState(() => _isSpeaking = !_isSpeaking),
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final scale = 1.0 + (_pulseController.value * 0.08);
                    final angle = _pulseController.value * 2 * math.pi;

                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF9E79).withValues(alpha:0.35 + (_pulseController.value * 0.15)),
                              blurRadius: 55,
                              spreadRadius: 8 + (_pulseController.value * 14),
                            ),
                            BoxShadow(
                              color: const Color(0xFFFFD480).withValues(alpha:0.35),
                              blurRadius: 35,
                              spreadRadius: 2,
                            ),
                          ],
                          gradient: SweepGradient(
                            transform: GradientRotation(angle),
                            colors: const [
                              Color(0xFFFFB074), // Warm Peach
                              Color(0xFFFF7B54), // Sunset Coral
                              Color(0xFFFFD56B), // Golden Honey
                              Color(0xFFFF9B85), // Soft Tangerine
                              Color(0xFFFFB074), // Smooth loop
                            ],
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: const Alignment(-0.25, -0.25),
                              radius: 0.9,
                              colors: [
                                Colors.white.withValues(alpha:0.38),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 44),

            // Typography Section
            const Text(
              '¡Hola!',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: Color(0xFF1D1D1F),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Di algo en español para empezar a hablar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.35,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1D1D1F).withValues(alpha:0.65),
                ),
              ),
            ),

            const Spacer(flex: 3),

            // Bottom Actions: Text fallback, Mic pill, and Captions
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSecondaryAction(
                    icon: Icons.keyboard_alt_outlined,
                    tooltip: 'Escribir',
                    onTap: () {},
                  ),
                  const SizedBox(width: 16),
                  // Primary Voice Pill Button
                  Material(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(32),
                    elevation: 3,
                    shadowColor: Colors.black.withValues(alpha:0.2),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32),
                      mouseCursor: SystemMouseCursors.click,
                      onTap: () => setState(() => _isSpeaking = !_isSpeaking),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isSpeaking ? Icons.stop_rounded : Icons.mic_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _isSpeaking ? 'Escuchando...' : 'Empezar charla',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildSecondaryAction(
                    icon: Icons.subtitles_outlined,
                    tooltip: 'Subtítulos',
                    onTap: () {},
                  ),
                ],
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryAction({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha:0.08),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          customBorder: const CircleBorder(),
          mouseCursor: SystemMouseCursors.click,
          onTap: onTap,
          child: SizedBox(
            width: 52,
            height: 52,
            child: Icon(icon, size: 23, color: const Color(0xFF2C2C2E)),
          ),
        ),
      ),
    );
  }
}
