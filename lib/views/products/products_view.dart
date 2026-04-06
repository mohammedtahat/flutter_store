// lib/views/products/products_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/product/product_card.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProductController>();
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: GetBuilder<ProductController>(
          builder: (c) => Text('المنتجات (${c.filteredProducts.length})'),
        ),
        actions: [
          PopupMenuButton<String>(
            color: AppColors.bgCard,
            icon: const Icon(Icons.sort_rounded, color: AppColors.textPrimary),
            onSelected: (v) { ctrl.sortProducts(v); ctrl.update(); },
            itemBuilder: (_) => ctrl.sortOptions.map((o) =>
                PopupMenuItem(value: o, child: Text(o, style: const TextStyle(color: AppColors.textPrimary)))).toList(),
          ),
        ],
      ),
      body: Column(children: [
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TextField(
            onChanged: (v) { ctrl.search(v); ctrl.update(); },
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'ابحث عن منتج...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
              filled: true, fillColor: AppColors.bgCard,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
        ),
        // Categories
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            height: 38,
            child: GetBuilder<ProductController>(builder: (c) => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: c.categories.length,
              itemBuilder: (_, i) {
                final cat = c.categories[i];
                final sel = c.selectedCategory.value == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () { c.filterByCategory(cat); c.update(); },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: sel ? AppColors.primaryGradient : null,
                        color: sel ? null : AppColors.bgCard,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(cat, style: TextStyle(fontSize: 12,
                          color: sel ? Colors.white : AppColors.textSecondary,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.normal)),
                    ),
                  ),
                );
              },
            )),
          ),
        ),
        // Grid
        Expanded(
          child: GetBuilder<ProductController>(builder: (c) {
            if (c.isLoading.value) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            if (c.filteredProducts.isEmpty) {
              return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.search_off_rounded, size: 72, color: AppColors.textMuted.withOpacity(0.3)),
                const SizedBox(height: 16),
                const Text('لا توجد منتجات مطابقة', style: TextStyle(color: AppColors.textMuted, fontSize: 16)),
              ]));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.70, mainAxisSpacing: 14, crossAxisSpacing: 14),
              itemCount: c.filteredProducts.length,
              itemBuilder: (_, i) => ProductGridCard(product: c.filteredProducts[i]),
            );
          }),
        ),
      ]),
    );
  }
}