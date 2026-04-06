// lib/controllers/settings_controller.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final RxBool isDarkMode      = true.obs;
  final RxBool notificationsOn = true.obs;
  final RxString language      = 'العربية'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value      = prefs.getBool('darkMode') ?? true;
    notificationsOn.value = prefs.getBool('notifications') ?? true;
    language.value        = prefs.getString('language') ?? 'العربية';
  }

  Future<void> toggleDarkMode() async {
    isDarkMode.toggle();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode.value);
    // In real app: Get.changeTheme(isDarkMode.value ? AppTheme.dark : AppTheme.light);
  }

  Future<void> toggleNotifications() async {
    notificationsOn.toggle();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', notificationsOn.value);
  }

  Future<void> changeLanguage(String lang) async {
    language.value = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }
}