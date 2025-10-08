import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/theme/app_text.dart';
import 'package:casier_app/core/widgets/my_dropdown.dart';
import 'package:flutter/material.dart';

class FilterSection extends StatefulWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String>? onSearchChanged;
  const FilterSection({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategoryChanged,
    this.onSearchChanged,
  });

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle_outline, color: AppColor.primary),
                const SizedBox(width: 8),
                Text(
                  "Add",
                  style: AppTextStyle.subtitle.copyWith(
                    fontWeight: FontWeight.w600,

                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 200,
          child: MyDropdown<String>(
            label: 'Kategori',
            hint: 'Pilih kategori',
            isRequired: false,
            value: widget.selectedCategory,
            items:
                widget.categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
            onChanged: widget.onCategoryChanged,
            onClear: () => widget.onCategoryChanged(null),
          ),
        ),
      ],
    );
  }
}
