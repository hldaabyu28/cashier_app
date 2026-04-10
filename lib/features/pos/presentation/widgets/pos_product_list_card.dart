import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/theme/app_text.dart';
import 'package:casier_app/features/pos/presentation/controllers/pos_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PosProductListCard extends StatelessWidget {
  final PosProduct product;

  const PosProductListCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PosController>();

    return Container(
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
          // ── Product image ────────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: Colors.grey[100],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
              loadingBuilder: (ctx, child, progress) {
                if (progress == null) return child;
                return Container(
                  width: 72,
                  height: 72,
                  color: Colors.grey[100],
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.secondary,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),

          // ── Product info ─────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + bookmark
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: AppTextStyle.subtitle
                            .copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.bookmark_border_rounded,
                      color: Colors.grey[300],
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Category tag
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColor.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    product.category,
                    style: AppTextStyle.caption.copyWith(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Stock + Price
                Row(
                  children: [
                    Icon(Icons.inventory_2_outlined,
                        color: Colors.grey[400], size: 12),
                    const SizedBox(width: 4),
                    Text(
                      'Stock: ${product.stock}',
                      style: AppTextStyle.caption
                          .copyWith(color: Colors.grey[400], fontSize: 11),
                    ),
                    const Spacer(),
                    Text(
                      'Rp${_fmt(product.price.toInt())}',
                      style: AppTextStyle.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // ── Quantity stepper ─────────────────────────────────────────────
          // Obx watches controller.quantities (RxMap) — a proper Rx source
          Obx(() {
            final qty = controller.quantities[product.id] ?? 0;
            return qty == 0
                ? GestureDetector(
                    onTap: () => controller.incrementProduct(product),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        color: AppColor.secondary,
                        size: 18,
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => controller.decrementProduct(product),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.remove_rounded,
                                size: 14, color: AppColor.primary),
                          ),
                        ),
                        SizedBox(
                          width: 26,
                          child: Text(
                            '$qty',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.caption.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.incrementProduct(product),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.add_rounded,
                                size: 14, color: AppColor.secondary),
                          ),
                        ),
                      ],
                    ),
                  );
          }),
        ],
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
