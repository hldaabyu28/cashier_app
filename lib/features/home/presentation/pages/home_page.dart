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
                child: Text(
                  "All Items",
                  style: AppTextStyle.heading3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      imageUrl:
                          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      title: 'Product ${index + 1}',
                      price: '${(index + 1) * 10}',
                    );
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
