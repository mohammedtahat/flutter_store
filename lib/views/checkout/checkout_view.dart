// lib/views/checkout/checkout_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_widgets.dart';

class CheckoutView extends GetView<ProductController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('إتمام الشراء')),
      body: Form(
        key: controller.checkoutFormKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _SectionCard(title: 'عنوان التوصيل 📍', icon: Icons.location_on_outlined, child: Column(children: [
              AppTextField(controller: controller.addressCtrl, label: 'العنوان الكامل',
                  prefixIcon: Icons.home_outlined, validator: controller.validateRequired,
                  maxLines: 2),
            ])),
            const SizedBox(height: 16),
            // Payment Method
            _SectionCard(title: 'طريقة الدفع 💳', icon: Icons.payment_rounded, child: Obx(() => Column(children: [
              _PaymentOption(
                icon: Icons.payments_outlined, title: 'الدفع عند الاستلام', subtitle: 'ادفع نقداً عند وصول الطلب',
                value: 'cash', groupValue: controller.paymentMethod.value,
                onChanged: (v) => controller.paymentMethod.value = v!,
              ),
              const SizedBox(height: 10),
              _PaymentOption(
                icon: Icons.credit_card_rounded, title: 'بطاقة ائتمانية', subtitle: 'Visa / Mastercard / Mada',
                value: 'card', groupValue: controller.paymentMethod.value,
                onChanged: (v) => controller.paymentMethod.value = v!,
              ),
              // Card fields
              if (controller.paymentMethod.value == 'card') ...[
                const SizedBox(height: 16),
                AppTextField(controller: controller.cardNumberCtrl, label: 'رقم البطاقة',
                    prefixIcon: Icons.credit_card_rounded, keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr, validator: (v) {
                      if (v == null || v.isEmpty) return 'رقم البطاقة مطلوب';
                      if (v.replaceAll(' ', '').length < 16) return 'رقم البطاقة غير صحيح';
                      return null;
                    }),
                const SizedBox(height: 12),
                AppTextField(controller: controller.cardNameCtrl, label: 'اسم صاحب البطاقة',
                    prefixIcon: Icons.person_outline, validator: controller.validateRequired),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: AppTextField(controller: controller.cardExpiryCtrl,
                      label: 'MM/YY', prefixIcon: Icons.calendar_today_outlined,
                      keyboardType: TextInputType.number, textDirection: TextDirection.ltr,
                      validator: controller.validateRequired)),
                  const SizedBox(width: 12),
                  Expanded(child: AppTextField(controller: controller.cardCvvCtrl, label: 'CVV',
                      prefixIcon: Icons.lock_outline, obscure: true,
                      keyboardType: TextInputType.number, textDirection: TextDirection.ltr,
                      validator: controller.validateRequired)),
                ]),
              ],
            ]))),
            const SizedBox(height: 16),
            // Order Summary
            _SectionCard(title: 'ملخص الطلب 🛒', icon: Icons.receipt_long_outlined, child: Obx(() => Column(children: [
              ...controller.cartItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(item.product.mainImage, width: 46, height: 46, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 46, height: 46, color: AppColors.bgSurface)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.product.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text('الكمية: ${item.quantity}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ])),
                  Text('\$${item.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ]),
              )),
              const Divider(color: Color(0xFF2A2A4A)),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('الإجمالي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                Text('\$${controller.cartTotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary)),
              ]),
            ]))),
            const SizedBox(height: 28),
            Obx(() => GradientButton(
              text: 'تأكيد الطلب',
              icon: Icons.check_circle_rounded,
              isLoading: controller.isLoading.value,
              onTap: () {
                if (controller.checkoutFormKey.currentState!.validate()) {
                  controller.placeOrder();
                }
              },
            )),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppColors.bgCard, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.05)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ]),
      const SizedBox(height: 16),
      child,
    ]),
  );
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title, subtitle, value, groupValue;
  final ValueChanged<String?> onChanged;
  const _PaymentOption({required this.icon, required this.title, required this.subtitle,
    required this.value, required this.groupValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final sel = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: sel ? AppColors.primary.withOpacity(0.1) : AppColors.bgCardLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: sel ? AppColors.primary.withOpacity(0.5) : Colors.white.withOpacity(0.05), width: sel ? 1.5 : 1),
        ),
        child: Row(children: [
          Icon(icon, color: sel ? AppColors.primary : AppColors.textMuted, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: sel ? AppColors.primary : AppColors.textPrimary)),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ])),
          Container(
            width: 20, height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: sel ? AppColors.primary : AppColors.textMuted, width: 2),
              color: sel ? AppColors.primary : Colors.transparent,
            ),
            child: sel ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
          ),
        ]),
      ),
    );
  }
}

// ─── Order Success Screen ─────────────────────────────────────────────────────
class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 130, height: 130,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient, shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 40, spreadRadius: 5)],
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 72),
            ),
            const SizedBox(height: 36),
            const Text('تم تأكيد طلبك! 🎉',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.textPrimary), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            const Text('سيصلك طلبك خلال 24-48 ساعة. يمكنك متابعة حالة الطلب من صفحة طلباتي.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.7), textAlign: TextAlign.center),
            const SizedBox(height: 40),
            GradientButton(text: 'متابعة التسوق', icon: Icons.shopping_bag_rounded, onTap: () => Get.offAllNamed('/main')),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: () { Get.offAllNamed('/main'); Get.toNamed('/orders'); },
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: const Text('عرض طلباتي'),
            ),
          ]),
        ),
      ),
    );
  }
}