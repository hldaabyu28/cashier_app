import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool? isLoading;
  final Color? color;
  final Color? textColor;
  final Color? iconColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading,
    this.iconColor,
    this.color,
    this.padding,
    this.textColor,
    this.width,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (isLoading ?? false) ? null : onPressed,
      style: ElevatedButton.styleFrom(
        surfaceTintColor: Colors.transparent,
        backgroundColor: color ?? AppColor.primary,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: Size(width ?? double.infinity, height ?? 50),
        shadowColor: Colors.transparent,
      ),
      child:
          (isLoading ?? false)
              ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Icon(icon, color: iconColor ?? AppColor.primary),
                  if (icon != null) const SizedBox(width: 8),
                  Text(
                    text,
                    style: AppTextStyle.body.copyWith(
                      color: textColor ?? AppColor.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
    );
  }
}
