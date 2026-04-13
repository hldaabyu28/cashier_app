import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/theme/app_text.dart';
import 'package:casier_app/features/pos/presentation/controllers/pos_controller.dart';
import 'package:casier_app/features/pos/presentation/pages/pos_catalog_page.dart';
import 'package:casier_app/features/pos/presentation/pages/pos_cart_page.dart';
import 'package:casier_app/features/pos/presentation/pages/pos_recipes_page.dart';
import 'package:casier_app/features/pos/presentation/pages/pos_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PosPage extends GetView<PosController> {
  const PosPage({super.key});

  static const List<Widget> _pages = [
    PosCatalogPage(),
    PosRecipesPage(),
    PosCartPage(),
    _PosWishlistPlaceholder(),
    PosProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // controller.selectedTab is the single Rx source — no local Rx created here
    return Obx(() => Scaffold(
          backgroundColor: AppColor.background,
          body: _pages[controller.selectedTab.value],
          bottomNavigationBar: _buildBottomNav(),
        ));
  }

  Widget _buildBottomNav() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    isSelected: controller.selectedTab.value == 0,
                    onTap: () => controller.selectedTab.value = 0,
                  ),
                  _NavItem(
                    icon: Icons.receipt_long_rounded,
                    label: 'History',
                    isSelected: controller.selectedTab.value == 1,
                    onTap: () => controller.selectedTab.value = 1,
                  ),
                  _NavCartItem(
                    isSelected: controller.selectedTab.value == 2,
                    onTap: () => controller.selectedTab.value = 2,
                    count: controller.cartCount,
                  ),
                  _NavItem(
                    icon: Icons.favorite_border_rounded,
                    label: 'Wishlist',
                    isSelected: controller.selectedTab.value == 3,
                    onTap: () => controller.selectedTab.value = 3,
                  ),
                  _NavItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Profile',
                    isSelected: controller.selectedTab.value == 4,
                    onTap: () => controller.selectedTab.value = 4,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Nav item widgets
// ─────────────────────────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.secondary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppColor.primary : Colors.grey[400],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyle.caption.copyWith(
                color: isSelected ? AppColor.primary : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavCartItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final RxInt count;

  const _NavCartItem({
    required this.isSelected,
    required this.onTap,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(
        // Only this Obx watches cartCount — correct narrow scope
        () => Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primary.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.shopping_cart_rounded,
                size: 22,
                color: AppColor.secondary,
              ),
            ),
            if (count.value > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${count.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Wishlist placeholder
// ─────────────────────────────────────────────────────────────────────────────

class _PosWishlistPlaceholder extends StatelessWidget {
  const _PosWishlistPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite_border_rounded,
                size: 80,
                color: Colors.grey[200],
              ),
              const SizedBox(height: 16),
              Text(
                'No Wishlist Yet',
                style: AppTextStyle.heading3.copyWith(color: Colors.grey[400]),
              ),
              const SizedBox(height: 8),
              Text(
                'Save items you love to your wishlist.',
                style: AppTextStyle.caption.copyWith(color: Colors.grey[300]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
