// lib/views/onboarding/onboarding_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_widgets.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});
  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _pageCtrl = PageController();
  int _currentPage = 0;

  final List<_OnboardPage> _pages = [
    _OnboardPage(
      icon: Icons.shopping_bag_outlined,
      gradientColors: [const Color(0xFF6C63FF), const Color(0xFF9C63FF)],
      title: 'تسوّق بلا حدود',
      subtitle: 'آلاف المنتجات من أفضل الماركات العالمية بأسعار لا تُصدّق',
    ),
    _OnboardPage(
      icon: Icons.local_shipping_outlined,
      gradientColors: [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
      title: 'توصيل سريع لبابك',
      subtitle: 'نوصّل طلبك في غضون 24 ساعة مع تتبع لحظي لشحنتك',
    ),
    _OnboardPage(
      icon: Icons.security_outlined,
      gradientColors: [const Color(0xFFFF6584), const Color(0xFFFF9A8B)],
      title: 'دفع آمن 100%',
      subtitle: 'جميع معاملاتك محمية بأعلى معايير الأمان والتشفير',
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageCtrl.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  void dispose() { _pageCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF0E0E1A), Color(0xFF1A1A2E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextButton(
                    onPressed: () => Get.offAllNamed('/login'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.08),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('تخطي', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ),
                ),
              ),
              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageCtrl,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (_, i) => _buildPage(_pages[i]),
                ),
              ),
              // Indicator + Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _pageCtrl,
                      count: _pages.length,
                      effect: ExpandingDotsEffect(
                        dotColor: Colors.white.withOpacity(0.2),
                        activeDotColor: _pages[_currentPage].gradientColors.first,
                        dotHeight: 8, dotWidth: 8, expansionFactor: 4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    GradientButton(
                      text: _currentPage == _pages.length - 1 ? 'ابدأ التسوق' : 'التالي',
                      onTap: _next,
                      colors: _pages[_currentPage].gradientColors,
                      icon: _currentPage == _pages.length - 1 ? Icons.shopping_bag_rounded : Icons.arrow_back_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180, height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: page.gradientColors),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: page.gradientColors.first.withOpacity(0.4), blurRadius: 50, spreadRadius: 10)],
            ),
            child: Icon(page.icon, color: Colors.white, size: 90),
          ),
          const SizedBox(height: 48),
          Text(page.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(page.subtitle,
            style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.7),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OnboardPage {
  final IconData icon;
  final List<Color> gradientColors;
  final String title;
  final String subtitle;
  const _OnboardPage({required this.icon, required this.gradientColors, required this.title, required this.subtitle});
}