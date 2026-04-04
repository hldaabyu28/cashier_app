import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/theme/app_text.dart';
import 'package:casier_app/features/pos/presentation/controllers/pos_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PosRecipesPage extends GetView<PosController> {
  const PosRecipesPage({super.key});

  // Featured recipe items
  final List<Map<String, dynamic>> recipes = const [
    {
      'name': 'Fluffy Waffles',
      'description': 'with strawberries and syrup',
      'rating': 4.5,
      'reviews': 3,
      'price': 150000,
      'image':
          'https://images.unsplash.com/photo-1568051243858-533a607809a5?w=400&auto=format&fit=crop',
    },
    {
      'name': 'Garden Salad',
      'description': 'Fresh organic greens mix',
      'rating': 4.3,
      'reviews': 12,
      'price': 65000,
      'image':
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&auto=format&fit=crop',
    },
    {
      'name': 'Herb Roasted Chicken',
      'description': 'Roasted with herbs & garlic',
      'rating': 4.7,
      'reviews': 8,
      'price': 245000,
      'image':
          'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=400&auto=format&fit=crop',
    },
    {
      'name': 'Avocado Toast',
      'description': 'With poached egg and chili flakes',
      'rating': 4.6,
      'reviews': 21,
      'price': 85000,
      'image':
          'https://images.unsplash.com/photo-1541519227354-08fa5d50c820?w=400&auto=format&fit=crop',
    },
    {
      'name': 'Cucumber Peach Bowl',
      'description': 'Cucumber, Peach & corn',
      'rating': 4.2,
      'reviews': 6,
      'price': 72000,
      'image':
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&auto=format&fit=crop',
    },
    {
      'name': 'Beans & Pomegranate',
      'description': 'Green with pomegranate seeds',
      'rating': 4.0,
      'reviews': 4,
      'price': 58000,
      'image':
          'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=400&auto=format&fit=crop',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Recipes',
                      style: AppTextStyle.heading2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.bookmark_border_rounded,
                      color: AppColor.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(Icons.search_rounded, color: Colors.grey[400], size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: AppTextStyle.subtitle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search recipes...',
                          hintStyle: AppTextStyle.subtitle.copyWith(
                            color: Colors.grey[400],
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Recipe List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return _RecipeListItem(recipe: recipe);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeListItem extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const _RecipeListItem({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              recipe['image'] as String,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 70,
                height: 70,
                color: Colors.grey[200],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe['name'] as String,
                  style: AppTextStyle.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  recipe['description'] as String,
                  style: AppTextStyle.caption.copyWith(color: Colors.grey[500]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      '${recipe['rating']}',
                      style: AppTextStyle.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      ' (${recipe['reviews']})',
                      style: AppTextStyle.caption.copyWith(color: Colors.grey[400]),
                    ),
                    const Spacer(),
                    Text(
                      'Rp ${_formatPrice(recipe['price'] as int)}',
                      style: AppTextStyle.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Add button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColor.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+ ADD',
              style: AppTextStyle.caption.copyWith(
                color: AppColor.primary,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),

          // Bookmark
          const SizedBox(width: 6),
          Icon(Icons.bookmark_border_rounded, color: Colors.grey[300], size: 18),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}
