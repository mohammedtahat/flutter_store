// lib/views/auth/login_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_widgets.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFF0E0E1A), Color(0xFF1A1A3E), Color(0xFF0E0E1A)]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                // Logo
                Row(children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  ShaderMask(
                    shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
                    child: const Text('متجري', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                  ),
                ]),
                const SizedBox(height: 40),
                const Text('مرحباً بك 👋', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                const Text('سجّل دخولك للاستمتاع بأفضل تجربة تسوق', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                const SizedBox(height: 36),
                // Form
                Form(
                  key: controller.loginFormKey,
                  child: Column(children: [
                    AppTextField(controller: controller.loginEmailCtrl, label: 'البريد الإلكتروني',
                        hint: 'example@email.com', prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress, textDirection: TextDirection.ltr,
                        validator: controller.validateEmail),
                    const SizedBox(height: 16),
                    Obx(() => AppTextField(
                      controller: controller.loginPasswordCtrl, label: 'كلمة المرور',
                      prefixIcon: Icons.lock_outline, obscure: !controller.isPasswordVisible.value,
                      validator: controller.validatePassword,
                      suffix: IconButton(
                        onPressed: controller.togglePasswordVisibility,
                        icon: Icon(controller.isPasswordVisible.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                      ),
                    )),
                  ]),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => Get.toNamed('/forgot-password'),
                    child: const Text('نسيت كلمة المرور؟', style: TextStyle(color: AppColors.primary, fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => GradientButton(text: 'تسجيل الدخول', onTap: controller.login, isLoading: controller.isLoading.value, icon: Icons.login_rounded)),
                const SizedBox(height: 32),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('ليس لديك حساب؟ ', style: TextStyle(color: AppColors.textSecondary)),
                  GestureDetector(
                    onTap: () => Get.toNamed('/signup'),
                    child: const Text('إنشاء حساب', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}