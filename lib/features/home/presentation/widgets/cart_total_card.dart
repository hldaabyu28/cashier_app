import 'package:casier_app/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class CartTotalCard extends StatelessWidget {
  const CartTotalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sub Total:",
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
              ),

              Text(
                "Rp. 500.000",
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Discount:",
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "Rp. 500.000",
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tax:",
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "Rp. 500.000",
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(height: 24, thickness: 1.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total:",
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "Rp. 500.000",
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
