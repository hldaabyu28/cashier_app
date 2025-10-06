import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final bool? isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  const MyInput({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.maxLines,
    this.minLines,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: isPassword ?? false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}


// class CustomInputField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final bool isPassword;
//   final TextInputType keyboardType;
//   final IconData? icon;
//   final double fontSize;
//   final double borderRadius;
//   final EdgeInsetsGeometry contentPadding;
//   final double iconSize;

//   const CustomInputField({
//     super.key,
//     required this.controller,
//     required this.label,
//     this.isPassword = false,
//     this.keyboardType = TextInputType.text,
//     this.icon,
//     this.fontSize = 16,
//     this.borderRadius = 8,
//     this.contentPadding = const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//     this.iconSize = 22,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword,
//       keyboardType: keyboardType,
//       style: AppTextStyles.body.copyWith(fontSize: fontSize),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: AppTextStyles.bodySecondary.copyWith(fontSize: fontSize - 2),
//         prefixIcon: icon != null ? Icon(icon, size: iconSize) : null,
//         contentPadding: contentPadding,
//         filled: true,
//         fillColor: AppColors.surface,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(borderRadius),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(borderRadius),
//           borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
//         ),
//       ),
//     );
//   }
// }
