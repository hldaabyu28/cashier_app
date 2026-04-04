import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/theme/app_text.dart';
import 'package:casier_app/features/pos/presentation/controllers/pos_controller.dart';
import 'package:casier_app/features/pos/presentation/widgets/pos_promo_banner.dart';
import 'package:casier_app/features/pos/presentation/widgets/pos_category_chips.dart';
import 'package:casier_app/features/pos/presentation/widgets/pos_product_list_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PosCatalogPage extends GetView<PosController> {
  const PosCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ───────────────────────────────────────
            _buildHeader(),

            // ─── Search Bar ───────────────────────────────────
            _buildSearchBar(),

            // ─── Category Chips + List ─────────────────────────
            Expanded(
              child: Obx(() {
                final products = controller.filteredProducts;
                return CustomScrollView(
                  slivers: [
                    // Promo Banner
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: const PosPromoBanner(),
                      ),
                    ),

                    // Category Chips
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: PosCategoryChips(
                          categories: controller.categories,
                          selectedCategory: controller.selectedCategory.value,
                          onCategoryChanged: controller.setCategory,
                        ),
                      ),
                    ),

                    // Section label
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.selectedCategory.value == 'All'
                                  ? 'All Products'
                                  : controller.selectedCategory.value,
                              style: AppTextStyle.heading3.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${products.length} items',
                              style: AppTextStyle.caption.copyWith(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Product List
                    if (products.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No products found',
                                style: AppTextStyle.body.copyWith(
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = products[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              child: PosProductListCard(product: product),
                            );
                          },
                          childCount: products.length,
                        ),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          // Avatar + greeting
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: AppColor.secondary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning! 👋',
                  style: AppTextStyle.caption.copyWith(color: Colors.grey[500]),
                ),
                Text(
                  'Cashier Dashboard',
                  style: AppTextStyle.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),
          ),
          // Notification bell
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: AppColor.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(Icons.search_rounded, color: Colors.grey[400], size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                onChanged: controller.setSearch,
                style: AppTextStyle.subtitle,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search products...',
                  hintStyle: AppTextStyle.subtitle.copyWith(
                    color: Colors.grey[400],
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.tune_rounded,
                color: AppColor.secondary,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
