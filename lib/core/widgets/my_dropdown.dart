import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class MyDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String label;
  final String? hint;
  final IconData? icon;
  final bool? isRequired;
  final VoidCallback? onClear;

  const MyDropdown({
    super.key,
    required this.items,
    this.value,
    required this.onChanged,
    required this.label,
    this.hint,
    this.icon,
    this.isRequired = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                items: items,
                onChanged: onChanged,
                value: value,
                iconSize: 22,
                enableFeedback: true,
                style: AppTextStyle.subtitle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                borderRadius: BorderRadius.circular(10),
                dropdownColor: Colors.white,
                isDense: true,
                isExpanded: false,
                alignment: Alignment.centerLeft,
                elevation: 8,
                icon: Icon(
                  icon ?? Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
                hint:
                    hint != null
                        ? Text(
                          hint!,
                          style:  AppTextStyle.subtitle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        : null,
              ),
            ),
          ),

          // Tombol clear filter
          if (value != null)
            GestureDetector(
              onTap: onClear,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFE0E0E0),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Colors.black54,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
