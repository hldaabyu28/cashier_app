import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/theme/app_text.dart';
import 'package:casier_app/features/pos/presentation/controllers/pos_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PosCartPage extends GetView<PosController> {
  const PosCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Your Cart',
                      style: AppTextStyle.heading2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                  Obx(() => controller.cartItems.length > 0
                      ? TextButton(
                          onPressed: controller.clearCart,
                          child: Text(
                            'Clear All',
                            style: AppTextStyle.caption.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : const SizedBox.shrink()),
                ],
              ),
            ),

            // ── Cart items list ───────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                if (controller.cartItems.length == 0) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 80, color: Colors.grey[200]),
                        const SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: AppTextStyle.heading3
                              .copyWith(color: Colors.grey[400]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add products from the catalog to get started',
                          style: AppTextStyle.caption
                              .copyWith(color: Colors.grey[300]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.cartItems.length,
                  itemBuilder: (context, index) {
                    final product = controller.cartItems[index];

                    // Obx here watches controller.quantities (RxMap) — correct
                    return Obx(() {
                      final qty =
                          controller.quantities[product.id] ?? 0;
                      final subtotal = product.price * qty;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                product.imageUrl,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 64,
                                  height: 64,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: AppTextStyle.subtitle.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${_fmt(subtotal.toInt())}',
                                    style: AppTextStyle.subtitle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Quantity stepper
                            Row(
                              children: [
                                _StepperBtn(
                                  icon: Icons.remove,
                                  onTap: () =>
                                      controller.decrementProduct(product),
                                  filled: false,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$qty',
                                  style: AppTextStyle.subtitle.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                _StepperBtn(
                                  icon: Icons.add,
                                  onTap: () =>
                                      controller.incrementProduct(product),
                                  filled: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
                  },
                );
              }),
            ),

            // ── Total + Checkout ──────────────────────────────────────────────
            Obx(() {
              if (controller.cartItems.length == 0) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total (${controller.cartCount.value} items)',
                          style: AppTextStyle.subtitle
                              .copyWith(color: Colors.grey[500]),
                        ),
                        Text(
                          'Rp ${_fmt(controller.cartTotal.value.toInt())}',
                          style: AppTextStyle.heading3.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Get.snackbar(
                          'Order Placed!',
                          'Total: Rp ${_fmt(controller.cartTotal.value.toInt())}',
                          backgroundColor: AppColor.success,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                        );
                        controller.clearCart();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: AppColor.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Checkout',
                        style: AppTextStyle.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColor.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _fmt(int n) {
    return n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}

class _StepperBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _StepperBtn({
    required this.icon,
    required this.onTap,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: filled ? AppColor.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: filled ? AppColor.secondary : Colors.grey[600],
        ),
      ),
    );
  }
}
