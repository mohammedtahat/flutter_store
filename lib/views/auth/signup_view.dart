// lib/views/auth/signup_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_widgets.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft,
              colors: [Color(0xFF0E0E1A), Color(0xFF1A1A3E), Color(0xFF0E0E1A)]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _BackBtn(),
                const SizedBox(height: 28),
                ShaderMask(
                  shaderCallback: (b) => AppColors.secondaryGradient.createShader(b),
                  child: const Text('إنشاء حساب ✨', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white)),
                ),
                const SizedBox(height: 6),
                const Text('انضم إلى ملايين المتسوقين وابدأ رحلتك', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                const SizedBox(height: 32),
                Form(
                  key: controller.signupFormKey,
                  child: Column(children: [
                    AppTextField(controller: controller.signupNameCtrl, label: 'الاسم الكامل', prefixIcon: Icons.person_outline, validator: controller.validateName),
                    const SizedBox(height: 14),
                    AppTextField(controller: controller.signupEmailCtrl, label: 'البريد الإلكتروني',
                        hint: 'example@email.com', prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress, textDirection: TextDirection.ltr,
                        validator: controller.validateEmail),
                    const SizedBox(height: 14),
                    Obx(() => AppTextField(
                      controller: controller.signupPasswordCtrl, label: 'كلمة المرور',
                      prefixIcon: Icons.lock_outline, obscure: !controller.isPasswordVisible.value,
                      validator: controller.validatePassword,
                      suffix: IconButton(
                        onPressed: controller.togglePasswordVisibility,
                        icon: Icon(controller.isPasswordVisible.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                      ),
                    )),
                    const SizedBox(height: 14),
                    Obx(() => AppTextField(
                      controller: controller.signupConfirmPasswordCtrl, label: 'تأكيد كلمة المرور',
                      prefixIcon: Icons.lock_outline, obscure: !controller.isConfirmPasswordVisible.value,
                      validator: controller.validatePassword,
                      suffix: IconButton(
                        onPressed: controller.toggleConfirmPasswordVisibility,
                        icon: Icon(controller.isConfirmPasswordVisible.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                      ),
                    )),
                  ]),
                ),
                const SizedBox(height: 28),
                Obx(() => GradientButton(
                  text: 'إنشاء الحساب', onTap: controller.signup, isLoading: controller.isLoading.value,
                  colors: const [AppColors.secondary, Color(0xFFFF9A8B)], icon: Icons.person_add_rounded,
                )),
                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('لديك حساب؟ ', style: TextStyle(color: AppColors.textSecondary)),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text('تسجيل الدخول', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
                  ),
                ]),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Forgot Password ──────────────────────────────────────────────────────────
class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF0E0E1A), Color(0xFF1A1A3E)]),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _BackBtn(),
                const SizedBox(height: 40),
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.lock_reset_rounded, color: AppColors.primary, size: 40),
                ),
                const SizedBox(height: 24),
                const Text('نسيت كلمة المرور؟', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                const Text('أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6)),
                const SizedBox(height: 36),
                Form(
                  key: controller.forgotFormKey,
                  child: AppTextField(
                    controller: controller.forgotEmailCtrl, label: 'البريد الإلكتروني',
                    hint: 'example@email.com', prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress, textDirection: TextDirection.ltr,
                    validator: controller.validateEmail,
                  ),
                ),
                const SizedBox(height: 28),
                Obx(() => GradientButton(
                  text: 'إرسال رابط الاستعادة', onTap: controller.forgotPassword,
                  isLoading: controller.isLoading.value, icon: Icons.send_rounded,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: AppColors.bgCard, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
      ),
    );
  }
}