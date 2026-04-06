// lib/views/search/search_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/product/product_card.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});
  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _searchCtrl = TextEditingController();
  late final ProductController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.find<ProductController>();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        title: TextField(
          controller: _searchCtrl,
          autofocus: true,
          onChanged: (v) { ctrl.search(v); ctrl.update(); setState(() {}); },
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'ابحث عن منتجات، ماركات...',
            border: InputBorder.none,
            hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 15),
            suffixIcon: _searchCtrl.text.isNotEmpty
                ? IconButton(
                onPressed: () { _searchCtrl.clear(); ctrl.search(''); ctrl.update(); setState(() {}); },
                icon: const Icon(Icons.clear, size: 18))
                : null,
          ),
        ),
        leading: IconButton(
          onPressed: () { ctrl.search(''); ctrl.update(); Get.back(); },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        actions: [
          IconButton(
            onPressed: () => _showFilterSheet(context),
            icon: GetBuilder<ProductController>(builder: (c) => Stack(children: [
              const Icon(Icons.tune_rounded, color: AppColors.primary),
              if (c.filterRating.value > 0 || c.filterMax.value < 3000 || c.filterMin.value > 0)
                Positioned(right: 0, top: 0,
                    child: Container(width: 8, height: 8,
                        decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle))),
            ])),
          ),
        ],
      ),
      body: Column(children: [
        _buildSortChips(),
        Expanded(child: _buildResults()),
      ]),
    );
  }

  Widget _buildSortChips() {
    return GetBuilder<ProductController>(builder: (c) => SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: c.sortOptions.length,
        itemBuilder: (_, i) {
          final opt = c.sortOptions[i];
          final sel = c.sortBy.value == opt;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () { c.sortBy.value = opt; c.applyFilters(); c.update(); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: sel ? AppColors.primaryGradient : null,
                  color: sel ? null : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: sel ? null : Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Text(opt, style: TextStyle(
                  fontSize: 12,
                  color: sel ? Colors.white : AppColors.textSecondary,
                  fontWeight: sel ? FontWeight.w700 : FontWeight.normal,
                )),
              ),
            ),
          );
        },
      ),
    ));
  }

  Widget _buildResults() {
    return GetBuilder<ProductController>(builder: (c) {
      if (c.searchQuery.value.isEmpty && c.filterMin.value == 0 && c.filterMax.value == 3000 && c.filterRating.value == 0) {
        return _buildSuggestions();
      }
      if (c.filteredProducts.isEmpty) return _buildEmpty();
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.7,
            mainAxisSpacing: 14, crossAxisSpacing: 14),
        itemCount: c.filteredProducts.length,
        itemBuilder: (_, i) => ProductGridCard(product: c.filteredProducts[i]),
      );
    });
  }

  Widget _buildSuggestions() {
    final popular = ['آيفون', 'سماعات', 'لابتوب', 'ساعة ذكية', 'iPad'];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('البحث الشائع',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 14),
        Wrap(spacing: 10, runSpacing: 10,
            children: popular.map((s) => GestureDetector(
              onTap: () {
                _searchCtrl.text = s;
                ctrl.search(s);
                ctrl.update();
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: AppColors.bgCard, borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.trending_up_rounded, color: AppColors.primary, size: 14),
                  const SizedBox(width: 6),
                  Text(s, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ]),
              ),
            )).toList()),
      ]),
    );
  }

  Widget _buildEmpty() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.search_off_rounded, size: 72, color: AppColors.textMuted.withOpacity(0.4)),
      const SizedBox(height: 16),
      const Text('لم نجد ما تبحث عنه',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 8),
      const Text('جرّب كلمات بحث مختلفة', style: TextStyle(color: AppColors.textMuted)),
    ]));
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => _FilterSheet(ctrl: ctrl),
    );
  }
}

// ─── Filter Sheet ─────────────────────────────────────────────────────────────
class _FilterSheet extends StatefulWidget {
  final ProductController ctrl;
  const _FilterSheet({required this.ctrl});
  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late double _minPrice;
  late double _maxPrice;
  late double _rating;
  late String _category;

  @override
  void initState() {
    super.initState();
    _minPrice  = widget.ctrl.filterMin.value;
    _maxPrice  = widget.ctrl.filterMax.value;
    _rating    = widget.ctrl.filterRating.value;
    _category  = widget.ctrl.selectedCategory.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('تصفية النتائج',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          TextButton(
              onPressed: () {
                setState(() { _minPrice = 0; _maxPrice = 3000; _rating = 0; _category = 'الكل'; });
                widget.ctrl.resetFilters();
                widget.ctrl.update();
                Get.back();
              },
              child: const Text('إعادة ضبط', style: TextStyle(color: AppColors.secondary))),
        ]),
        const SizedBox(height: 20),

        // Price Range
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('نطاق السعر', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
          Text('\$${_minPrice.toStringAsFixed(0)} - \$${_maxPrice.toStringAsFixed(0)}',
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
        ]),
        RangeSlider(
          values: RangeValues(_minPrice, _maxPrice),
          min: 0, max: 3000,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.bgSurface,
          onChanged: (v) => setState(() { _minPrice = v.start; _maxPrice = v.end; }),
        ),
        const SizedBox(height: 16),

        // Rating
        const Text('الحد الأدنى للتقييم',
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(children: [1, 2, 3, 4, 5].map((r) {
          final sel = _rating >= r;
          return GestureDetector(
            onTap: () => setState(() => _rating = _rating == r.toDouble() ? 0 : r.toDouble()),
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(Icons.star_rounded,
                  color: sel ? AppColors.gold : AppColors.bgSurface, size: 32),
            ),
          );
        }).toList()),
        const SizedBox(height: 24),

        // Category
        const Text('الفئة', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8,
            children: widget.ctrl.categories.map((cat) {
              final sel = _category == cat;
              return GestureDetector(
                onTap: () => setState(() => _category = cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: sel ? AppColors.primaryGradient : null,
                    color: sel ? null : AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(cat, style: TextStyle(
                      fontSize: 12,
                      color: sel ? Colors.white : AppColors.textSecondary,
                      fontWeight: sel ? FontWeight.w700 : FontWeight.normal)),
                ),
              );
            }).toList()),
        const SizedBox(height: 24),

        // Apply Button
        SizedBox(
          width: double.infinity, height: 52,
          child: ElevatedButton(
            onPressed: () {
              widget.ctrl.filterMin.value    = _minPrice;
              widget.ctrl.filterMax.value    = _maxPrice;
              widget.ctrl.filterRating.value = _rating;
              widget.ctrl.selectedCategory.value = _category;
              widget.ctrl.applyFilters();
              widget.ctrl.update();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            child: const Text('تطبيق الفلتر',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }
}