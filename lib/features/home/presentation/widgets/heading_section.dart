import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/widgets/circle_icon_button.dart';
import 'package:flutter/material.dart';

class HeadingSection extends StatelessWidget {
  const HeadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleIconButton(
          icon: Icons.person_2_outlined,
          onPressed: () {},
          backgroundColor: Colors.white,
          iconColor: AppColor.primary,
        ),
        const SizedBox(width: 10),
        CircleIconButton(
          backgroundColor: Colors.white,
          iconColor: AppColor.primary,
          icon: Icons.shopping_cart_outlined,
          onPressed: () {},
        ),
      ],
    );
  }
}
