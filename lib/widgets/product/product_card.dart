// lib/widgets/product/product_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';
import '../../theme/app_theme.dart';

class ProductCard extends GetView<ProductController> {
  final ProductModel product;
  final double width;

  const ProductCard({super.key, required this.product, this.width = 180});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.openProduct(product),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image Section ──────────────────────────────────
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Main image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      product.mainImage,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, progress) => progress == null
                          ? child
                          : Container(
                        color: AppColors.bgCardLight,
                        child: const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary, strokeWidth: 2),
                        ),
                      ),
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.bgCardLight,
                        child: const Icon(Icons.image_outlined,
                            color: AppColors.textMuted, size: 40),
                      ),
                    ),
                  ),

                  // Badges (New / Best Seller)
                  Positioned(
                    top: 10, left: 10,
                    child: Column(children: [
                      if (product.isNew) _badge('جديد', AppColors.accent),
                      if (product.isBestSeller) ...[
                        const SizedBox(height: 4),
                        _badge('الأكثر مبيعاً', AppColors.gold),
                      ],
                    ]),
                  ),

                  // Discount badge
                  if (product.discountPercent > 0)
                    Positioned(
                      top: 10, right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${product.discountPercent.toStringAsFixed(0)}%',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),

                  // Wishlist button — GetBuilder يحل مشكلة Obx
                  Positioned(
                    bottom: 8, right: 8,
                    child: GetBuilder<ProductController>(
                      builder: (ctrl) => GestureDetector(
                        onTap: () {
                          ctrl.toggleWishlist(product);
                          ctrl.update(); // تحديث واجهة الـ GetBuilder
                        },
                        child: Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            ctrl.isWishlisted(product.id)
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 15,
                            color: ctrl.isWishlisted(product.id)
                                ? AppColors.secondary
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info Section ───────────────────────────────────
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name
                    Text(
                      product.name,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Rating
                    Row(children: [
                      const Icon(Icons.star_rounded, color: AppColors.gold, size: 13),
                      const SizedBox(width: 2),
                      Text(product.rating.toString(),
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.w700)),
                      Text(' (${product.reviewCount})',
                          style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    ]),

                    // Price + Add to cart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            '\$${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800,
                                color: AppColors.primary),
                          ),
                          if (product.oldPrice > product.price)
                            Text(
                              '\$${product.oldPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontSize: 10, color: AppColors.textMuted,
                                  decoration: TextDecoration.lineThrough),
                            ),
                        ]),

                        // Add to cart button
                        GestureDetector(
                          onTap: () => controller.addToCart(product),
                          child: Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 8, offset: const Offset(0, 3))
                              ],
                            ),
                            child: const Icon(Icons.add_rounded,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ],
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

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
    );
  }
}

// ─── Grid Card ────────────────────────────────────────────────────────────────
class ProductGridCard extends StatelessWidget {
  final ProductModel product;
  const ProductGridCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ProductCard(product: product, width: double.infinity);
  }
}