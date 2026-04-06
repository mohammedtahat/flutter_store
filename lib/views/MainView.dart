// lib/views/main_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../theme/app_theme.dart';
import 'cart/cart_view.dart';
import 'home/home_view.dart';
import 'products/products_view.dart';
import 'profile/profile_view.dart';
import 'wishlist/wishlist_view.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProductController>();
    final pages = [
      const HomeView(),
      const ProductsView(),
      const CartView(),
      const WishlistView(),
      const ProfileView(),
    ];
    return GetBuilder<ProductController>(
      builder: (c) => Scaffold(
        backgroundColor: AppColors.bg,
        body: IndexedStack(index: c.selectedTab.value, children: pages),
        bottomNavigationBar: _BottomNav(ctrl: ctrl),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final ProductController ctrl;
  const _BottomNav({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(Icons.home_rounded,          Icons.home_outlined,           'الرئيسية'),
      _NavItem(Icons.grid_view_rounded,     Icons.grid_view_outlined,      'المنتجات'),
      _NavItem(Icons.shopping_cart_rounded, Icons.shopping_cart_outlined,  'السلة'),
      _NavItem(Icons.favorite_rounded,      Icons.favorite_border_rounded, 'المفضلة'),
      _NavItem(Icons.person_rounded,        Icons.person_outline_rounded,  'حسابي'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 24, offset: const Offset(0, -6))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: GetBuilder<ProductController>(
            builder: (c) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                final item  = items[i];
                final isSel = c.selectedTab.value == i;
                return GestureDetector(
                  onTap: () { c.changeTab(i); c.update(); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(horizontal: isSel ? 16 : 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isSel ? AppColors.primaryGradient : null,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: isSel ? [BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))] : null,
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      // Cart badge
                      i == 2
                          ? _BadgeIcon(icon: isSel ? item.activeIcon : item.icon,
                          color: isSel ? Colors.white : AppColors.textMuted,
                          badge: c.cartItemCount > 0 ? '${c.cartItemCount}' : null)
                          : i == 3
                          ? _BadgeIcon(icon: isSel ? item.activeIcon : item.icon,
                          color: isSel ? Colors.white : AppColors.textMuted,
                          badge: c.wishlist.isNotEmpty ? '${c.wishlist.length}' : null)
                          : Icon(isSel ? item.activeIcon : item.icon,
                          color: isSel ? Colors.white : AppColors.textMuted, size: 22),
                      if (isSel) ...[
                        const SizedBox(width: 6),
                        Text(item.label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ]),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData activeIcon, icon;
  final String label;
  const _NavItem(this.activeIcon, this.icon, this.label);
}

class _BadgeIcon extends StatelessWidget {
  final IconData icon; final Color color; final String? badge;
  const _BadgeIcon({required this.icon, required this.color, this.badge});
  @override
  Widget build(BuildContext context) => Stack(clipBehavior: Clip.none, children: [
    Icon(icon, color: color, size: 22),
    if (badge != null)
      Positioned(right: -6, top: -6,
          child: Container(padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
              child: Text(badge!, style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.w800)))),
  ]);
}