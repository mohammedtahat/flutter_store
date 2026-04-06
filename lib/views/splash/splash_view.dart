// lib/views/splash/splash_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _scaleCtrl, _fadeCtrl, _slideCtrl;
  late Animation<double> _scaleAnim, _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));

    _scaleAnim = CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);
    _fadeAnim  = CurvedAnimation(parent: _fadeCtrl,  curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    _scaleCtrl.forward();
    Future.delayed(const Duration(milliseconds: 400), () => _fadeCtrl.forward());
    Future.delayed(const Duration(milliseconds: 600), () => _slideCtrl.forward());
    Future.delayed(const Duration(milliseconds: 2800), () => Get.offAllNamed('/onboarding'));
  }

  @override
  void dispose() {
    _scaleCtrl.dispose(); _fadeCtrl.dispose(); _slideCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF0E0E1A), Color(0xFF1A1A3E), Color(0xFF0E0E1A)],
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(top: -100, right: -80,
                child: _glowCircle(300, AppColors.primary.withOpacity(0.08))),
            Positioned(bottom: -120, left: -60,
                child: _glowCircle(280, AppColors.secondary.withOpacity(0.07))),
            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Container(
                      width: 110, height: 110,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 40, spreadRadius: 5)],
                      ),
                      child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 56),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Column(children: [
                        ShaderMask(
                          shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
                          child: const Text('متجري', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2)),
                        ),
                        const SizedBox(height: 8),
                        const Text('تسوّق بذكاء، عش بأسلوب',
                            style: TextStyle(fontSize: 15, color: AppColors.textSecondary, letterSpacing: 0.5)),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom loader
            Positioned(
              bottom: 60, left: 0, right: 0,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(children: [
                  SizedBox(
                    width: 120,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('جاري التحميل...', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle(double size, Color color) {
    return Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
  }
}