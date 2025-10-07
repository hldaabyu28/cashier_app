import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/theme/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final Color? fillColor;
  final Color? borderColor;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final bool? obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? padding;
  const MyInput({
    super.key,
    this.controller,
    this.placeholder,
    this.keyboardType,
    this.validator,
    this.maxLines,
    this.obscureText,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.padding,
    this.fillColor,
    this.borderColor, 
  });
  static Widget password({
    TextEditingController? controller,
    bool disabled = false,
    String? placeholder,
    String? Function(String?)? validator,
    Color? fillColor,
    Color? borderColor,
  }) {
    final obscureText = ValueNotifier<bool>(true);
    return ValueListenableBuilder(
      valueListenable: obscureText,
      builder: (context, value, child) {
        return MyInput(
          controller: controller,
          placeholder: placeholder,
          obscureText: value,
          fillColor: fillColor,
          borderColor: borderColor,
          validator: validator,
          suffixIcon: IconButton(
            onPressed: () {
              obscureText.value = !obscureText.value;
            },
            icon:
                value
                    ? const Icon(Icons.visibility_off, color: AppColor.primary)
                    : const Icon(Icons.visibility, color: AppColor.primary),
          ),
        );
      },
    );
  }

  @override
  State<MyInput> createState() => _MyInputState();
}

class _MyInputState extends State<MyInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: widget.obscureText ?? false,
      validator: widget.validator,
      cursorColor: AppColor.primary,
      cursorErrorColor: AppColor.danger,
      style: AppTextStyle.body.copyWith(color: AppColor.textColor, fontSize: 14),
      obscuringCharacter: '*',
      decoration: InputDecoration(
        hintText: widget.placeholder ?? "Enter text",
        
        hintStyle: AppTextStyle.body.copyWith(color: AppColor.textColor.withOpacity(0.5), fontSize: 14),
        contentPadding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        fillColor: widget.fillColor ?? AppColor.background,
        filled: true,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Colors.transparent)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color:AppColor.secondary, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: AppColor.danger, width: 1.5)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: widget.borderColor ?? Colors.transparent)),
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
