// lib/controllers/product_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class ProductController extends GetxController {
  // Data
  final RxList<ProductModel>   allProducts      = <ProductModel>[].obs;
  final RxList<ProductModel>   filteredProducts = <ProductModel>[].obs;
  final RxList<ProductModel>   wishlist         = <ProductModel>[].obs;
  final RxList<CartItemModel>  cartItems        = <CartItemModel>[].obs;
  final RxList<OrderModel>     orders           = <OrderModel>[].obs;

  // State
  final RxBool   isLoading        = false.obs;
  final RxString selectedCategory = 'الكل'.obs;
  final RxString searchQuery      = ''.obs;
  final RxString sortBy           = 'الافتراضي'.obs;
  final RxDouble minPrice         = 0.0.obs;
  final RxDouble maxPrice         = 3000.0.obs;
  final RxDouble filterMin        = 0.0.obs;
  final RxDouble filterMax        = 3000.0.obs;
  final RxDouble filterRating     = 0.0.obs;
  final RxInt    selectedTab      = 0.obs;

  // Product Detail
  final Rx<ProductModel?> selectedProduct     = Rx<ProductModel?>(null);
  final RxInt             selectedImageIndex  = 0.obs;
  final RxInt             selectedQuantity    = 1.obs;

  // Checkout
  final addressCtrl       = TextEditingController();
  final cardNumberCtrl    = TextEditingController();
  final cardNameCtrl      = TextEditingController();
  final cardExpiryCtrl    = TextEditingController();
  final cardCvvCtrl       = TextEditingController();
  final RxString paymentMethod = 'cash'.obs;
  final checkoutFormKey   = GlobalKey<FormState>();

  final List<String> categories = [
    'الكل', 'هواتف', 'لابتوب', 'سماعات', 'ساعات', 'تابلت', 'ألعاب', 'تلفزيونات', 'كاميرات', 'درونز',
  ];

  final List<String> sortOptions = ['الافتراضي', 'السعر: الأقل', 'السعر: الأعلى', 'التقييم الأعلى', 'الأحدث'];

  final List<Map<String, dynamic>> banners = [
    {'title': 'عروض الربيع 🌸', 'subtitle': 'خصومات حتى 50%', 'color1': const Color(0xFF6C63FF), 'color2': const Color(0xFF9C63FF)},
    {'title': 'أحدث الإلكترونيات ⚡', 'subtitle': 'تقنية بلا حدود', 'color1': const Color(0xFFFF6584), 'color2': const Color(0xFFFF9A8B)},
    {'title': 'شحن مجاني 🚀', 'subtitle': 'على جميع الطلبات فوق \$100', 'color1': const Color(0xFF43E97B), 'color2': const Color(0xFF38F9D7)},
  ];

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    debounce(searchQuery, (_) => applyFilters(), time: const Duration(milliseconds: 400));
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    allProducts.assignAll(ProductModel.dummy);
    filteredProducts.assignAll(ProductModel.dummy);
    isLoading.value = false;
  }

  List<ProductModel> get latestProducts  => allProducts.where((p) => p.isNew).toList();
  List<ProductModel> get bestSellers     => allProducts.where((p) => p.isBestSeller).toList();

  // --- Filtering ---
  void filterByCategory(String cat) {
    selectedCategory.value = cat;
    applyFilters();
  }

  void applyFilters() {
    List<ProductModel> result = List.from(allProducts);
    if (selectedCategory.value != 'الكل') {
      result = result.where((p) => p.category == selectedCategory.value).toList();
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result.where((p) => p.name.toLowerCase().contains(q) || p.description.toLowerCase().contains(q) || p.category.toLowerCase().contains(q)).toList();
    }
    result = result.where((p) => p.price >= filterMin.value && p.price <= filterMax.value).toList();
    if (filterRating.value > 0) {
      result = result.where((p) => p.rating >= filterRating.value).toList();
    }
    switch (sortBy.value) {
      case 'السعر: الأقل':   result.sort((a, b) => a.price.compareTo(b.price)); break;
      case 'السعر: الأعلى':  result.sort((a, b) => b.price.compareTo(a.price)); break;
      case 'التقييم الأعلى': result.sort((a, b) => b.rating.compareTo(a.rating)); break;
    }
    filteredProducts.assignAll(result);
  }

  // --- Missing methods ---
  void search(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void sortProducts(String sort) {
    sortBy.value = sort;
    applyFilters();
  }

  String? validateRequired(String? v) {
    if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
    return null;
  }

  void resetFilters() {
    filterMin.value    = 0;
    filterMax.value    = 3000;
    filterRating.value = 0;
    sortBy.value       = 'الافتراضي';
    selectedCategory.value = 'الكل';
    applyFilters();
  }

  // --- Wishlist ---
  void toggleWishlist(ProductModel p) {
    if (isWishlisted(p.id)) {
      wishlist.removeWhere((w) => w.id == p.id);
      _snack('تمت الإزالة', '${p.name} أُزيل من المفضلة', const Color(0xFF6E6E8E));
    } else {
      wishlist.add(p);
      _snack('تمت الإضافة ❤️', '${p.name} أُضيف إلى المفضلة', const Color(0xFFFF6584));
    }
    update(); // يحدّث GetBuilder في ProductCard
  }
  bool isWishlisted(int id) => wishlist.any((p) => p.id == id);

  // --- Cart ---
  void addToCart(ProductModel product, {int qty = 1}) {
    final idx = cartItems.indexWhere((c) => c.product.id == product.id);
    if (idx >= 0) {
      cartItems[idx].quantity += qty;
      cartItems.refresh();
    } else {
      cartItems.add(CartItemModel(product: product, quantity: qty));
    }
    _snack('🛒 أُضيف للسلة', product.name, const Color(0xFF6C63FF));
  }

  void removeFromCart(int productId) {
    cartItems.removeWhere((c) => c.product.id == productId);
  }

  void increaseQty(int productId) {
    final idx = cartItems.indexWhere((c) => c.product.id == productId);
    if (idx >= 0) { cartItems[idx].quantity++; cartItems.refresh(); }
  }

  void decreaseQty(int productId) {
    final idx = cartItems.indexWhere((c) => c.product.id == productId);
    if (idx >= 0) {
      if (cartItems[idx].quantity > 1) { cartItems[idx].quantity--; cartItems.refresh(); }
      else removeFromCart(productId);
    }
  }

  double get cartTotal     => cartItems.fold(0, (s, c) => s + c.totalPrice);
  int    get cartItemCount => cartItems.fold(0, (s, c) => s + c.quantity);

  // --- Checkout ---
  Future<void> placeOrder() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    final order = OrderModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(cartItems),
      total: cartTotal,
      address: addressCtrl.text,
      paymentMethod: paymentMethod.value == 'cash' ? 'كاش' : 'بطاقة ائتمان',
      date: DateTime.now(),
    );
    orders.insert(0, order);
    cartItems.clear();
    isLoading.value = false;
    Get.offAllNamed('/order-success');
  }

  // --- Product Detail ---
  void openProduct(ProductModel p) {
    selectedProduct.value     = p;
    selectedImageIndex.value  = 0;
    selectedQuantity.value    = 1;
    Get.toNamed('/product-detail');
  }

  void changeTab(int i) => selectedTab.value = i;

  void _snack(String title, String msg, Color color) {
    Get.snackbar(title, msg,
      backgroundColor: color.withOpacity(0.9),
      colorText: Colors.white, snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16), borderRadius: 14,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    addressCtrl.dispose(); cardNumberCtrl.dispose(); cardNameCtrl.dispose();
    cardExpiryCtrl.dispose(); cardCvvCtrl.dispose();
    super.onClose();
  }
}