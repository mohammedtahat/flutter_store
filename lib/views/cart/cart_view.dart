// lib/views/cart/cart_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_widgets.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProductController>();
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: GetBuilder<ProductController>(
          builder: (c) => Text('السلة (${c.cartItems.length})'),
        ),
        actions: [
          GetBuilder<ProductController>(builder: (c) => c.cartItems.isNotEmpty
              ? TextButton(
              onPressed: () => _confirmClear(context, c),
              child: const Text('مسح الكل', style: TextStyle(color: AppColors.error, fontSize: 13)))
              : const SizedBox.shrink()),
        ],
      ),
      body: GetBuilder<ProductController>(builder: (c) {
        if (c.cartItems.isEmpty) return _buildEmpty(c);
        return Column(children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: c.cartItems.length,
              itemBuilder: (_, i) => _CartItemCard(index: i, ctrl: c),
            ),
          ),
          _buildSummary(c),
        ]);
      }),
    );
  }

  Widget _buildEmpty(ProductController ctrl) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 120, height: 120,
          decoration: BoxDecoration(color: AppColors.bgCard, shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.06))),
          child: const Icon(Icons.shopping_cart_outlined, size: 56, color: AppColors.textMuted)),
      const SizedBox(height: 24),
      const Text('سلتك فارغة!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
      const SizedBox(height: 8),
      const Text('أضف بعض المنتجات الرائعة', style: TextStyle(color: AppColors.textMuted)),
      const SizedBox(height: 28),
      GestureDetector(
        onTap: () { ctrl.changeTab(0); ctrl.update(); },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))]),
          child: const Text('تصفح المنتجات', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
        ),
      ),
    ]));
  }

  Widget _buildSummary(ProductController c) {
    final shipping = c.cartTotal > 100 ? 0.0 : 9.99;
    final discount = c.cartTotal * 0.05;
    final total    = c.cartTotal + shipping - discount;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: Column(children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 16),
        _SummaryRow('المجموع الجزئي', '\$${c.cartTotal.toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        _SummaryRow('الشحن', c.cartTotal > 100 ? 'مجاني 🎉' : '\$9.99'),
        const SizedBox(height: 8),
        _SummaryRow('خصم العضوية (5%)', '-\$${discount.toStringAsFixed(2)}', valueColor: AppColors.accent),
        const SizedBox(height: 12),
        const Divider(color: Color(0xFF2A2A4A)),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('الإجمالي', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary)),
        ]),
        const SizedBox(height: 16),
        GradientButton(text: 'إتمام الشراء', icon: Icons.shopping_bag_rounded, onTap: () => Get.toNamed('/checkout')),
      ]),
    );
  }

  void _confirmClear(BuildContext context, ProductController c) {
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: AppColors.bgCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('مسح السلة؟', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800)),
      content: const Text('هل تريد إزالة جميع المنتجات؟', style: TextStyle(color: AppColors.textSecondary)),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('إلغاء', style: TextStyle(color: AppColors.textMuted))),
        TextButton(onPressed: () { c.cartItems.clear(); c.update(); Get.back(); },
            child: const Text('مسح', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700))),
      ],
    ));
  }
}

class _CartItemCard extends StatelessWidget {
  final int index;
  final ProductController ctrl;
  const _CartItemCard({required this.index, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    if (index >= ctrl.cartItems.length) return const SizedBox.shrink();
    final item = ctrl.cartItems[index];
    return Dismissible(
      key: Key('cart_${item.product.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) { ctrl.removeFromCart(item.product.id); ctrl.update(); },
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(color: AppColors.error.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.delete_rounded, color: AppColors.error, size: 28),
          SizedBox(height: 4),
          Text('حذف', style: TextStyle(color: AppColors.error, fontSize: 11)),
        ]),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05))),
        child: Row(children: [
          ClipRRect(borderRadius: BorderRadius.circular(14),
              child: Image.network(item.product.mainImage, width: 80, height: 80, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 80, height: 80, color: AppColors.bgSurface,
                      child: const Icon(Icons.image_outlined, color: AppColors.textMuted)))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.product.name,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(item.product.category, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('\$${item.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
              Row(children: [
                _QtyBtn(icon: Icons.remove_rounded, onTap: () { ctrl.decreaseQty(item.product.id); ctrl.update(); }),
                Container(width: 32, height: 32,
                    decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(8)),
                    child: Center(child: Text('${item.quantity}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)))),
                _QtyBtn(icon: Icons.add_rounded, onTap: () { ctrl.increaseQty(item.product.id); ctrl.update(); }),
              ]),
            ]),
          ])),
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
    child: Container(width: 30, height: 30, margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppColors.primary, size: 16)),
  );
}

Widget _SummaryRow(String label, String value, {Color? valueColor}) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 2),
  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
    Text(value, style: TextStyle(color: valueColor ?? AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
  ]),
);