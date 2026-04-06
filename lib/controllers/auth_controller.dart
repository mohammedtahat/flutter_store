// lib/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final RxBool isLoading                  = false.obs;
  final RxBool isPasswordVisible          = false.obs;
  final RxBool isConfirmPasswordVisible   = false.obs;
  final Rx<UserModel?> currentUser        = Rx<UserModel?>(null);

  // Login
  final loginEmailCtrl    = TextEditingController();
  final loginPasswordCtrl = TextEditingController();
  final loginFormKey      = GlobalKey<FormState>();

  // Signup
  final signupNameCtrl            = TextEditingController();
  final signupEmailCtrl           = TextEditingController();
  final signupPasswordCtrl        = TextEditingController();
  final signupConfirmPasswordCtrl = TextEditingController();
  final signupFormKey             = GlobalKey<FormState>();

  // Forgot
  final forgotEmailCtrl = TextEditingController();
  final forgotFormKey   = GlobalKey<FormState>();

  // Profile Edit
  final editNameCtrl    = TextEditingController();
  final editEmailCtrl   = TextEditingController();
  final editPhoneCtrl   = TextEditingController();
  final editAddressCtrl = TextEditingController();
  final editFormKey     = GlobalKey<FormState>();

  void togglePasswordVisibility()        => isPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    currentUser.value = UserModel(
      id: '1', name: 'أحمد محمد',
      email: loginEmailCtrl.text,
      phone: '+966 50 123 4567',
      address: 'الرياض، المملكة العربية السعودية',
    );
    isLoading.value = false;
    Get.offAllNamed('/main');
  }

  Future<void> signup() async {
    if (!signupFormKey.currentState!.validate()) return;
    if (signupPasswordCtrl.text != signupConfirmPasswordCtrl.text) {
      _showError('كلمات المرور غير متطابقة');
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    currentUser.value = UserModel(
      id: '1', name: signupNameCtrl.text, email: signupEmailCtrl.text,
    );
    isLoading.value = false;
    Get.offAllNamed('/main');
  }

  Future<void> forgotPassword() async {
    if (!forgotFormKey.currentState!.validate()) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    Get.back();
    _showSuccess('تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني');
  }

  Future<void> updateProfile() async {
    if (!editFormKey.currentState!.validate()) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    currentUser.value = currentUser.value?.copyWith(
      name: editNameCtrl.text,
      email: editEmailCtrl.text,
      phone: editPhoneCtrl.text,
      address: editAddressCtrl.text,
    );
    isLoading.value = false;
    Get.back();
    _showSuccess('تم تحديث الملف الشخصي بنجاح');
  }

  void fillEditForm() {
    editNameCtrl.text    = currentUser.value?.name ?? '';
    editEmailCtrl.text   = currentUser.value?.email ?? '';
    editPhoneCtrl.text   = currentUser.value?.phone ?? '';
    editAddressCtrl.text = currentUser.value?.address ?? '';
  }

  void logout() {
    currentUser.value = null;
    Get.offAllNamed('/login');
  }

  // Validators
  String? validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'البريد الإلكتروني مطلوب';
    if (!GetUtils.isEmail(v)) return 'بريد إلكتروني غير صحيح';
    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'كلمة المرور مطلوبة';
    if (v.length < 6) return 'يجب أن تكون 6 أحرف على الأقل';
    return null;
  }

  String? validateName(String? v) {
    if (v == null || v.isEmpty) return 'الاسم مطلوب';
    if (v.length < 3) return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    return null;
  }

  String? validateRequired(String? v) {
    if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';
    return null;
  }

  void _showError(String msg) {
    Get.snackbar('خطأ ❌', msg,
      backgroundColor: const Color(0xFFFF4D6D),
      colorText: Colors.white, snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 14, duration: const Duration(seconds: 3),
    );
  }

  void _showSuccess(String msg) {
    Get.snackbar('نجاح ✅', msg,
      backgroundColor: const Color(0xFF43E97B),
      colorText: Colors.white, snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 14, duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    loginEmailCtrl.dispose(); loginPasswordCtrl.dispose();
    signupNameCtrl.dispose(); signupEmailCtrl.dispose();
    signupPasswordCtrl.dispose(); signupConfirmPasswordCtrl.dispose();
    forgotEmailCtrl.dispose();
    editNameCtrl.dispose(); editEmailCtrl.dispose();
    editPhoneCtrl.dispose(); editAddressCtrl.dispose();
    super.onClose();
  }
}