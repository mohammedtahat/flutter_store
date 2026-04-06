// lib/views/home/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/product_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_widgets.dart';
import '../../widgets/product/product_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _pageCtrl  = PageController(viewportFraction: 0.88);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      final ctrl = Get.find<ProductController>();
      final next = (_currentPage + 1) % ctrl.banners.length;
      _pageCtrl.animateToPage(next,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final ctrl = Get.find<ProductController>();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(auth, ctrl),
          _buildSearchBar(),
          _buildBannerSlider(ctrl),
          _buildCategories(ctrl),
          SliverToBoxAdapter(child: Column(children: [
            const SizedBox(height: 24),
            SectionHeader(title: 'الأكثر مبيعاً 🔥', actionText: 'عرض الكل', onAction: () => ctrl.changeTab(1)),
            const SizedBox(height: 16),
            _buildHorizontalList(ctrl, isBestSeller: true),
            const SizedBox(height: 24),
            SectionHeader(title: 'وصل حديثاً ✨', actionText: 'عرض الكل', onAction: () => ctrl.changeTab(1)),
            const SizedBox(height: 16),
            _buildHorizontalList(ctrl, isBestSeller: false),
            const SizedBox(height: 100),
          ])),
        ],
      ),
    );
  }

  Widget _buildAppBar(AuthController auth, ProductController ctrl) {
    return SliverAppBar(
      floating: true, snap: true,
      backgroundColor: AppColors.bg,
      titleSpacing: 20,
      title: Row(children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(14)),
          child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        GetBuilder<AuthController>(builder: (a) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('مرحباً، ${a.currentUser.value?.name.split(' ').first ?? 'ضيف'} 👋',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const Text('ماذا تبحث عنه اليوم؟',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ])),
      ]),
      actions: [
        GetBuilder<ProductController>(builder: (c) => Stack(children: [
          IconButton(onPressed: () => c.changeTab(2),
              icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.textPrimary)),
          if (c.cartItemCount > 0)
            Positioned(right: 8, top: 8,
                child: Container(
                  width: 17, height: 17,
                  decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                  child: Center(child: Text('${c.cartItemCount}',
                      style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w800))),
                )),
        ])),
        IconButton(onPressed: () => Get.toNamed('/search'),
            icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary)),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () => Get.toNamed('/search'),
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.bgCard, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Row(children: [
            const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
            const SizedBox(width: 12),
            const Text('ابحث عن منتجات، ماركات...', style: TextStyle(color: AppColors.textHint, fontSize: 14)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 16),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildBannerSlider(ProductController ctrl) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(children: [
          SizedBox(
            height: 175,
            child: PageView.builder(
              controller: _pageCtrl,
              itemCount: ctrl.banners.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) {
                final b = ctrl.banners[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(colors: [b['color1'] as Color, b['color2'] as Color]),
                      boxShadow: [BoxShadow(color: (b['color1'] as Color).withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 8))],
                    ),
                    child: Stack(children: [
                      Positioned(right: -30, top: -30,
                          child: Container(width: 150, height: 150,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.07)))),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                            child: Text(b['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 10),
                          Text(b['subtitle'] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, height: 1.3)),
                          const SizedBox(height: 14),
                          GestureDetector(
                            onTap: () => ctrl.changeTab(1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                              child: Text('تسوّق الآن',
                                  style: TextStyle(color: b['color1'] as Color, fontSize: 12, fontWeight: FontWeight.w800)),
                            ),
                          ),
                        ]),
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSmoothIndicator(
            activeIndex: _currentPage,
            count: ctrl.banners.length,
            effect: const WormEffect(dotHeight: 7, dotWidth: 7, activeDotColor: AppColors.primary, dotColor: Color(0xFF2A2A4A)),
          ),
        ]),
      ),
    );
  }

  Widget _buildCategories(ProductController ctrl) {
    final icons = {'الكل': Icons.apps_rounded, 'هواتف': Icons.smartphone_rounded, 'لابتوب': Icons.laptop_rounded,
      'سماعات': Icons.headphones_rounded, 'ساعات': Icons.watch_rounded, 'تابلت': Icons.tablet_rounded,
      'ألعاب': Icons.sports_esports_rounded, 'تلفزيونات': Icons.tv_rounded, 'كاميرات': Icons.camera_alt_rounded, 'درونز': Icons.flight_rounded};
    return SliverToBoxAdapter(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(title: 'الفئات 📦'),
        const SizedBox(height: 14),
        SizedBox(
          height: 90,
          child: GetBuilder<ProductController>(builder: (c) => ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: c.categories.length,
            itemBuilder: (_, i) {
              final cat = c.categories[i];
              final sel = c.selectedCategory.value == cat;
              return GestureDetector(
                onTap: () { c.filterByCategory(cat); c.changeTab(1); c.update(); },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 58, height: 58,
                      decoration: BoxDecoration(
                        gradient: sel ? AppColors.primaryGradient : null,
                        color: sel ? null : AppColors.bgCard,
                        borderRadius: BorderRadius.circular(18),
                        border: sel ? null : Border.all(color: Colors.white.withOpacity(0.06)),
                        boxShadow: sel ? [BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))] : null,
                      ),
                      child: Icon(icons[cat] ?? Icons.circle, color: sel ? Colors.white : AppColors.textMuted, size: 26),
                    ),
                    const SizedBox(height: 6),
                    Text(cat, style: TextStyle(fontSize: 11,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                        color: sel ? AppColors.primary : AppColors.textSecondary)),
                  ]),
                ),
              );
            },
          )),
        ),
      ]),
    );
  }

  Widget _buildHorizontalList(ProductController ctrl, {required bool isBestSeller}) {
    return GetBuilder<ProductController>(builder: (c) {
      final list = isBestSeller ? c.bestSellers : c.latestProducts;
      if (list.isEmpty) {
        return const SizedBox(height: 270,
            child: Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)));
      }
      return SizedBox(
        height: 270,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (_, i) => Padding(padding: const EdgeInsets.only(right: 14), child: ProductCard(product: list[i])),
        ),
      );
    });
  }
}