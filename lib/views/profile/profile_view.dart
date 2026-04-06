// lib/views/profile/profile_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/product_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_widgets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final prod = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.bg,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [Color(0xFF1A1A3E), Color(0xFF2A2A5E)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const SizedBox(height: 8),
                      Row(children: [
                        Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient, shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 16)],
                          ),
                          child: Center(
                            child: Text(
                              auth.currentUser.value?.name.isNotEmpty == true
                                  ? auth.currentUser.value!.name[0].toUpperCase() : 'م',
                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(auth.currentUser.value?.name ?? 'المستخدم',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Text(auth.currentUser.value?.email ?? '',
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          if ((auth.currentUser.value?.phone ?? '').isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(auth.currentUser.value!.phone,
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          ],
                        ])),
                        GestureDetector(
                          onTap: () { auth.fillEditForm(); Get.toNamed('/edit-profile'); },
                          child: Container(
                            width: 38, height: 38,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      // Stats
                      Obx(() => Row(children: [
                        _StatChip('${prod.orders.length}', 'طلب'),
                        const SizedBox(width: 12),
                        _StatChip('${prod.wishlist.length}', 'مفضلة'),
                        const SizedBox(width: 12),
                        _StatChip('${prod.cartItems.length}', 'سلة'),
                      ])),
                    ])),
                  ),
                ),
              ),
            ),
            title: const Text('ملفي الشخصي'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                _ProfileSection(title: 'حسابي', items: [
                  _ProfileItem(Icons.shopping_bag_outlined,    'طلباتي',         () => Get.toNamed('/orders')),
                  _ProfileItem(Icons.favorite_border_rounded,  'المفضلة',         () => Get.toNamed('/wishlist')),
                  _ProfileItem(Icons.location_on_outlined,     'عناوين التوصيل', () {}),
                  _ProfileItem(Icons.payment_outlined,         'طرق الدفع',      () {}),
                ]),
                const SizedBox(height: 14),
                _ProfileSection(title: 'الإعدادات', items: [
                  _ProfileItem(Icons.settings_outlined,        'الإعدادات',       () => Get.toNamed('/settings')),
                  _ProfileItem(Icons.help_outline_rounded,     'مركز المساعدة',  () {}),
                  _ProfileItem(Icons.privacy_tip_outlined,     'سياسة الخصوصية', () {}),
                  _ProfileItem(Icons.info_outline_rounded,     'عن التطبيق',     () {}),
                ]),
                const SizedBox(height: 14),
                // Logout
                GestureDetector(
                  onTap: () => _confirmLogout(auth),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.08), borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.error.withOpacity(0.2)),
                    ),
                    child: const Row(children: [
                      Icon(Icons.logout_rounded, color: AppColors.error, size: 22),
                      SizedBox(width: 14),
                      Text('تسجيل الخروج', style: TextStyle(color: AppColors.error, fontSize: 15, fontWeight: FontWeight.w700)),
                      Spacer(),
                      Icon(Icons.arrow_back_ios_rounded, color: AppColors.error, size: 14),
                    ]),
                  ),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(AuthController auth) {
    Get.dialog(AlertDialog(
      backgroundColor: AppColors.bgCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('تسجيل الخروج', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800)),
      content: const Text('هل أنت متأكد من تسجيل الخروج؟', style: TextStyle(color: AppColors.textSecondary)),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('إلغاء', style: TextStyle(color: AppColors.textMuted))),
        TextButton(onPressed: auth.logout, child: const Text('خروج', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700))),
      ],
    ));
  }
}

class _StatChip extends StatelessWidget {
  final String count, label;
  const _StatChip(this.count, this.label);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
    child: Column(children: [
      Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
    ]),
  );
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const _ProfileSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.only(right: 4, bottom: 10),
        child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textMuted))),
    Container(
      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(children: List.generate(items.length, (i) => Column(children: [
        items[i],
        if (i < items.length - 1) const Divider(height: 1, color: Color(0xFF2A2A4A), indent: 54),
      ]))),
    ),
  ]);
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _ProfileItem(this.icon, this.title, this.onTap);

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    leading: Container(width: 36, height: 36,
        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.primary, size: 18)),
    title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
    trailing: const Icon(Icons.arrow_back_ios_rounded, size: 13, color: AppColors.textMuted),
  );
}

// ─── Edit Profile ─────────────────────────────────────────────────────────────
class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تعديل الملف الشخصي')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: auth.editFormKey,
          child: Column(children: [
            // Avatar
            Center(
              child: Stack(children: [
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                  child: Obx(() => Center(child: Text(
                    auth.currentUser.value?.name.isNotEmpty == true ? auth.currentUser.value!.name[0].toUpperCase() : 'م',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white),
                  ))),
                ),
                Positioned(bottom: 0, left: 0,
                    child: Container(width: 28, height: 28,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 15))),
              ]),
            ),
            const SizedBox(height: 28),
            AppTextField(controller: auth.editNameCtrl, label: 'الاسم الكامل', prefixIcon: Icons.person_outline, validator: auth.validateName),
            const SizedBox(height: 14),
            AppTextField(controller: auth.editEmailCtrl, label: 'البريد الإلكتروني', prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress, textDirection: TextDirection.ltr, validator: auth.validateEmail),
            const SizedBox(height: 14),
            AppTextField(controller: auth.editPhoneCtrl, label: 'رقم الهاتف', prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 14),
            AppTextField(controller: auth.editAddressCtrl, label: 'العنوان', prefixIcon: Icons.location_on_outlined, maxLines: 2),
            const SizedBox(height: 28),
            Obx(() => GradientButton(text: 'حفظ التغييرات', icon: Icons.save_rounded,
                isLoading: auth.isLoading.value, onTap: auth.updateProfile)),
          ]),
        ),
      ),
    );
  }
}