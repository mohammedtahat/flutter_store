// lib/routes/app_routes.dart
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/settings_controller.dart';
import '../views/MainView.dart';
import '../views/auth/login_view.dart';
import '../views/auth/signup_view.dart';
import '../views/checkout/checkout_view.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/orders/orders_view.dart';
import '../views/product/product_detail_view.dart';
import '../views/profile/profile_view.dart';
import '../views/search/search_view.dart';
import '../views/settings/settings_view.dart';
import '../views/splash/splash_view.dart';
import '../views/wishlist/wishlist_view.dart';

class AppRoutes {
  static const splash         = '/';
  static const onboarding     = '/onboarding';
  static const login          = '/login';
  static const signup         = '/signup';
  static const forgotPassword = '/forgot-password';
  static const main           = '/main';
  static const search         = '/search';
  static const productDetail  = '/product-detail';
  static const checkout       = '/checkout';
  static const orderSuccess   = '/order-success';
  static const orders         = '/orders';
  static const profile        = '/profile';
  static const editProfile    = '/edit-profile';
  static const wishlist       = '/wishlist';
  static const settings       = '/settings';

  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: login,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: signup,
      page: () => const SignupView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: main,
      page: () => const MainView(),
      binding: BindingsBuilder(() {
        // AuthController قد يكون موجوداً من Login، نستخدم permanent: true
        if (!Get.isRegistered<AuthController>()) {
          Get.put(AuthController(), permanent: true);
        }
        Get.put(ProductController(), permanent: true);
        Get.put(SettingsController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: search,
      page: () => const SearchView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: productDetail,
      page: () => const ProductDetailView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: checkout,
      page: () => const CheckoutView(),
      transition: Transition.upToDown,
    ),
    GetPage(
      name: orderSuccess,
      page: () => const OrderSuccessView(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: orders,
      page: () => const OrdersView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: profile,
      page: () => const ProfileView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: editProfile,
      page: () => const EditProfileView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: wishlist,
      page: () => const WishlistView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: settings,
      page: () => const SettingsView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<SettingsController>()) {
          Get.put(SettingsController());
        }
      }),
      transition: Transition.rightToLeft,
    ),
  ];
}