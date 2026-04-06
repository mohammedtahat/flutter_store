// lib/views/wishlist/wishlist_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/product/product_card.dart';

class WishlistView extends GetView<ProductController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Obx(() => Text('المفضلة (${controller.wishlist.length})')),
        actions: [
          Obx(() => controller.wishlist.isNotEmpty
              ? TextButton(
            onPressed: () => controller.wishlist.clear(),
            child: const Text('مسح الكل', style: TextStyle(color: AppColors.error, fontSize: 13)),
          )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (controller.wishlist.isEmpty) {
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.favorite_border_rounded, size: 72, color: AppColors.textMuted.withOpacity(0.4)),
              const SizedBox(height: 16),
              const Text('قائمة المفضلة فارغة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Text('اضغط على ❤️ لإضافة منتجات', style: TextStyle(color: AppColors.textSecondary)),
            ]),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.70, mainAxisSpacing: 14, crossAxisSpacing: 14),
          itemCount: controller.wishlist.length,
          itemBuilder: (_, i) => ProductGridCard(product: controller.wishlist[i]),
        );
      }),
    );
  }
}