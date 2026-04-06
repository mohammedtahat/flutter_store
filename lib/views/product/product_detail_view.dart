// lib/views/product/product_detail_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_widgets.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});
  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _imgIndex = 0;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProductController>();
    final product = ctrl.selectedProduct.value;
    if (product == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Image SliverAppBar ──────────────────────────────
          SliverAppBar(
            expandedHeight: 340,
            backgroundColor: AppColors.bg,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: GetBuilder<ProductController>(builder: (c) => GestureDetector(
                  onTap: () { c.toggleWishlist(product); c.update(); },
                  child: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
                    child: Icon(
                      c.isWishlisted(product.id) ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: c.isWishlisted(product.id) ? AppColors.secondary : Colors.white, size: 20,
                    ),
                  ),
                )),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Column(children: [
                Expanded(
                  child: Stack(children: [
                    PageView.builder(
                      itemCount: product.images.length,
                      onPageChanged: (i) => setState(() => _imgIndex = i),
                      itemBuilder: (_, i) => Image.network(product.images[i], fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: AppColors.bgCard,
                              child: const Icon(Icons.image_outlined, size: 60, color: AppColors.textMuted))),
                    ),
                    // Page dots
                    Positioned(bottom: 12, left: 0, right: 0,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(product.images.length, (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _imgIndex == i ? 20 : 6, height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: _imgIndex == i ? AppColors.primary : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        )),
                      ),
                    ),
                    // Discount badge
                    if (product.discountPercent > 0)
                      Positioned(top: 60, left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(gradient: AppColors.secondaryGradient, borderRadius: BorderRadius.circular(10)),
                            child: Text('-${product.discountPercent.toStringAsFixed(0)}%',
                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
                          )),
                  ]),
                ),
                // Thumbnails
                if (product.images.length > 1)
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: product.images.length,
                      itemBuilder: (_, i) => GestureDetector(
                        onTap: () => setState(() => _imgIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 50, height: 50, margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _imgIndex == i ? AppColors.primary : Colors.transparent, width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(product.images[i], fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: AppColors.bgCard)),
                          ),
                        ),
                      ),
                    ),
                  ),
              ]),
            ),
          ),

          // ── Details ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Name & Price
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Text(product.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.3))),
                  const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary)),
                    if (product.oldPrice > product.price)
                      Text('\$${product.oldPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14, color: AppColors.textMuted, decoration: TextDecoration.lineThrough)),
                  ]),
                ]),
                const SizedBox(height: 12),
                // Rating
                Row(children: [
                  RatingBarIndicator(rating: product.rating, itemSize: 18,
                      itemBuilder: (_, __) => const Icon(Icons.star_rounded, color: AppColors.gold)),
                  const SizedBox(width: 8),
                  Text('${product.rating}', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 14)),
                  Text(' (${product.reviewCount} تقييم)', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ]),
                const SizedBox(height: 14),
                // Category
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withOpacity(0.25)),
                  ),
                  child: Text(product.category, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFF2A2A4A)),
                const SizedBox(height: 16),
                // Description
                const Text('الوصف', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                Text(product.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.8)),
                const SizedBox(height: 20),
                // Quantity
                Row(children: [
                  const Text('الكمية:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(width: 16),
                  _QtyBtn(icon: Icons.remove_rounded, onTap: () { if (_quantity > 1) setState(() => _quantity--); }),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary))),
                  _QtyBtn(icon: Icons.add_rounded, onTap: () => setState(() => _quantity++)),
                ]),
                const SizedBox(height: 20),
                // Stock
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: product.stock > 0 ? AppColors.accent.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    Icon(product.stock > 0 ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        color: product.stock > 0 ? AppColors.accent : AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Text(product.stock > 0 ? 'متوفر في المخزون (${product.stock} قطعة)' : 'غير متوفر حالياً',
                        style: TextStyle(color: product.stock > 0 ? AppColors.accent : AppColors.error, fontSize: 13, fontWeight: FontWeight.w600)),
                  ]),
                ),
                // Reviews
                if (product.reviews.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text('آراء العملاء', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  ...product.reviews.map((r) => _ReviewCard(review: r)),
                ],
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      // ── Bottom Bar ─────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: Row(children: [
          GetBuilder<ProductController>(builder: (c) => GestureDetector(
            onTap: () { c.toggleWishlist(product); c.update(); },
            child: Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: c.isWishlisted(product.id) ? AppColors.secondary.withOpacity(0.15) : AppColors.bgCardLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: c.isWishlisted(product.id) ? AppColors.secondary.withOpacity(0.4) : Colors.white.withOpacity(0.06)),
              ),
              child: Icon(c.isWishlisted(product.id) ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: c.isWishlisted(product.id) ? AppColors.secondary : AppColors.textMuted, size: 22),
            ),
          )),
          const SizedBox(width: 12),
          Expanded(
            child: GradientButton(
              text: 'أضف إلى السلة',
              icon: Icons.shopping_cart_rounded,
              onTap: () { ctrl.addToCart(product, qty: _quantity); ctrl.update(); Get.back(); },
            ),
          ),
        ]),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(width: 36, height: 36,
        decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withOpacity(0.08))),
        child: Icon(icon, color: AppColors.primary, size: 18)),
  );
}

class _ReviewCard extends StatelessWidget {
  final review;
  const _ReviewCard({required this.review});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.05))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(review.userName, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontSize: 13)),
        Row(children: [const Icon(Icons.star_rounded, color: AppColors.gold, size: 14), const SizedBox(width: 3),
          Text('${review.rating}', style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w700))]),
      ]),
      const SizedBox(height: 6),
      Text(review.comment, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
      const SizedBox(height: 4),
      Text(review.date, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
    ]),
  );
}