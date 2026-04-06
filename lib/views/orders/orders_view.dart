// lib/views/orders/orders_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../models/cart_item_model.dart';
import '../../theme/app_theme.dart';

class OrdersView extends GetView<ProductController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('طلباتي')),
      body: Obx(() {
        if (controller.orders.isEmpty) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.receipt_long_outlined, size: 72, color: AppColors.textMuted.withOpacity(0.4)),
            const SizedBox(height: 16),
            const Text('لا يوجد طلبات بعد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            const Text('ابدأ التسوق الآن!', style: TextStyle(color: AppColors.textSecondary)),
          ]));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.orders.length,
          itemBuilder: (_, i) => _OrderCard(order: controller.orders[i]),
        );
      }),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  Color get _statusColor {
    switch (order.status) {
      case 'تم التوصيل': return AppColors.accent;
      case 'قيد الشحن': return AppColors.warning;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.bgCard, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(order.id, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 3),
              Text('${order.date.day}/${order.date.month}/${order.date.year}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: _statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
              child: Text(order.status, style: TextStyle(color: _statusColor, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
        const Divider(color: Color(0xFF2A2A4A), height: 1),
        // Items
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(children: [
            ...order.items.take(2).map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                ClipRRect(borderRadius: BorderRadius.circular(8),
                    child: Image.network(item.product.mainImage, width: 44, height: 44, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 44, height: 44, color: AppColors.bgSurface))),
                const SizedBox(width: 10),
                Expanded(child: Text(item.product.name,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                Text('x${item.quantity}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ]),
            )),
            if (order.items.length > 2)
              Text('+${order.items.length - 2} منتجات أخرى', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ]),
        ),
        const Divider(color: Color(0xFF2A2A4A), height: 1),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('طريقة الدفع: ${order.paymentMethod}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            Text('\$${order.total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
          ]),
        ),
      ]),
    );
  }
}