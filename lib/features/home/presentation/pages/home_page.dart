import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/theme/app_text.dart';
import 'package:casier_app/core/widgets/circle_icon_button.dart';
import 'package:casier_app/core/widgets/my_input.dart';
import 'package:casier_app/features/home/presentation/widgets/filter_section.dart';
import 'package:casier_app/features/home/presentation/widgets/heading_section.dart';
import 'package:casier_app/features/home/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory;
  String? searchQuery;

  final List<String> categories = [
    'Electronics',
    'Books',
    'Clothing',
    'Home & Kitchen',
    'Sports',
    'Toys',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingSection(),
              const SizedBox(height: 24),

              MyInput.search(placeholder: "Search", fillColor: Colors.white),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("All Items", style: AppTextStyle.heading3),
              ),
              const SizedBox(height: 16),

              FilterSection(
                categories: categories,
                selectedCategory: selectedCategory,
                onCategoryChanged: (val) {
                  setState(() => selectedCategory = val);
                },
                onSearchChanged: (query) {
                  setState(() => searchQuery = query);
                },
              ),

              const SizedBox(height: 24),

              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return ProductCard();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
