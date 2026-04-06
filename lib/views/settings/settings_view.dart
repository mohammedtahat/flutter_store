// lib/views/settings/settings_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import '../../theme/app_theme.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('الإعدادات')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          _SettingsSection(title: 'المظهر', items: [
            Obx(() => _ToggleTile(
              icon: Icons.dark_mode_rounded, iconColor: AppColors.primary,
              title: 'الوضع الليلي',
              subtitle: controller.isDarkMode.value ? 'مفعّل' : 'معطّل',
              value: controller.isDarkMode.value,
              onChanged: (_) => controller.toggleDarkMode(),
            )),
          ]),
          const SizedBox(height: 14),
          _SettingsSection(title: 'اللغة', items: [
            Obx(() => _SelectTile(
              icon: Icons.language_rounded, iconColor: AppColors.accent,
              title: 'لغة التطبيق',
              selected: controller.language.value,
              options: const ['العربية', 'English'],
              onSelected: controller.changeLanguage,
            )),
          ]),
          const SizedBox(height: 14),
          _SettingsSection(title: 'الإشعارات', items: [
            Obx(() => _ToggleTile(
              icon: Icons.notifications_outlined, iconColor: AppColors.warning,
              title: 'إشعارات التطبيق',
              subtitle: controller.notificationsOn.value ? 'مفعّلة' : 'معطّلة',
              value: controller.notificationsOn.value,
              onChanged: (_) => controller.toggleNotifications(),
            )),
            const Divider(height: 1, color: Color(0xFF2A2A4A), indent: 54),
            _ToggleTile(
              icon: Icons.local_offer_outlined, iconColor: AppColors.secondary,
              title: 'إشعارات العروض',
              subtitle: 'تنبيهات حول الخصومات والعروض الخاصة',
              value: true,
              onChanged: (_) {},
            ),
          ]),
          const SizedBox(height: 14),
          _SettingsSection(title: 'عن التطبيق', items: [
            _InfoTile(Icons.info_outline_rounded, AppColors.primary, 'إصدار التطبيق', '1.0.0'),
            const Divider(height: 1, color: Color(0xFF2A2A4A), indent: 54),
            _InfoTile(Icons.build_outlined, AppColors.accent, 'آخر تحديث', 'مارس 2025'),
          ]),
          const SizedBox(height: 100),
        ]),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.only(right: 4, bottom: 10),
        child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textMuted))),
    Container(
      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(children: items),
    ),
  ]);
}

class _ToggleTile extends StatelessWidget {
  final IconData icon; final Color iconColor;
  final String title; final String? subtitle;
  final bool value; final ValueChanged<bool> onChanged;
  const _ToggleTile({required this.icon, required this.iconColor, required this.title, this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Container(width: 36, height: 36,
        decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 18)),
    title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
    subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)) : null,
    trailing: Switch.adaptive(value: value, onChanged: onChanged, activeColor: AppColors.primary),
  );
}

class _SelectTile extends StatelessWidget {
  final IconData icon; final Color iconColor;
  final String title, selected;
  final List<String> options;
  final Function(String) onSelected;
  const _SelectTile({required this.icon, required this.iconColor, required this.title, required this.selected, required this.options, required this.onSelected});

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Container(width: 36, height: 36,
        decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 18)),
    title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(selected, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
      const SizedBox(width: 4),
      const Icon(Icons.arrow_back_ios_rounded, size: 12, color: AppColors.textMuted),
    ]),
    onTap: () => Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('اختر اللغة', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          ...options.map((opt) => ListTile(
            title: Text(opt, style: const TextStyle(color: AppColors.textPrimary)),
            trailing: opt == selected ? const Icon(Icons.check_rounded, color: AppColors.primary) : null,
            onTap: () { onSelected(opt); Get.back(); },
          )),
        ]),
      ),
    ),
  );
}

class _InfoTile extends StatelessWidget {
  final IconData icon; final Color color;
  final String title, value;
  const _InfoTile(this.icon, this.color, this.title, this.value);

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Container(width: 36, height: 36,
        decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 18)),
    title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
    trailing: Text(value, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
  );
}