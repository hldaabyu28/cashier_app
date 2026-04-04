import 'package:get/get.dart';

class PosProduct {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String distance;

  const PosProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.distance,
  });
}

class PosController extends GetxController {
  final RxString pageTitle = 'Point of Sale'.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxInt cartCount = 0.obs;
  final RxDouble cartTotal = 0.0.obs;
  final RxList<PosProduct> cartItems = <PosProduct>[].obs;

  // ── Bottom nav tab — stored here so it survives widget rebuilds ──────────
  final RxInt selectedTab = 0.obs;

  // ── Reactive quantity map: productId → quantity ───────────────────────────
  // This is the ONLY reactive source of truth for quantities.
  // Obx widgets subscribe to this map for live updates.
  final RxMap<String, int> quantities = <String, int>{}.obs;

  /// Returns the current quantity for [productId] (default 0).
  int getQty(String productId) => quantities[productId] ?? 0;

  final List<String> categories = [
    'All',
    'Fresh Fruit',
    'Vegetables',
    'Meat',
    'Dairy',
    'Snacks',
    'Beverages',
  ];

  final List<PosProduct> allProducts = const [
    PosProduct(
      id: '1',
      name: 'Watermelon',
      category: 'Fresh Fruit',
      price: 19000,
      imageUrl:
          'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=400&auto=format&fit=crop',
      rating: 4.5,
      reviewCount: 1200,
      distance: '1 km',
    ),
    PosProduct(
      id: '2',
      name: 'Yellow Peach',
      category: 'Fresh Fruit',
      price: 12700,
      imageUrl:
          'https://images.unsplash.com/photo-1629828874338-99e30c800f21?w=400&auto=format&fit=crop',
      rating: 4.3,
      reviewCount: 760,
      distance: '2 km',
    ),
    PosProduct(
      id: '3',
      name: 'Green Bell Pepper',
      category: 'Vegetables',
      price: 16700,
      imageUrl:
          'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400&auto=format&fit=crop',
      rating: 4.1,
      reviewCount: 390,
      distance: '500 m',
    ),
    PosProduct(
      id: '4',
      name: 'Red Onion',
      category: 'Vegetables',
      price: 8900,
      imageUrl:
          'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=400&auto=format&fit=crop',
      rating: 4.0,
      reviewCount: 540,
      distance: '1.2 km',
    ),
    PosProduct(
      id: '5',
      name: 'Organic Banana',
      category: 'Fresh Fruit',
      price: 14500,
      imageUrl:
          'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400&auto=format&fit=crop',
      rating: 4.7,
      reviewCount: 2100,
      distance: '300 m',
    ),
    PosProduct(
      id: '6',
      name: 'Broccoli Crown',
      category: 'Vegetables',
      price: 22000,
      imageUrl:
          'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=400&auto=format&fit=crop',
      rating: 4.4,
      reviewCount: 870,
      distance: '800 m',
    ),
    PosProduct(
      id: '7',
      name: 'Fresh Chicken',
      category: 'Meat',
      price: 38000,
      imageUrl:
          'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=400&auto=format&fit=crop',
      rating: 4.6,
      reviewCount: 1580,
      distance: '1.5 km',
    ),
    PosProduct(
      id: '8',
      name: 'Whole Milk',
      category: 'Dairy',
      price: 18500,
      imageUrl:
          'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&auto=format&fit=crop',
      rating: 4.2,
      reviewCount: 930,
      distance: '400 m',
    ),
    PosProduct(
      id: '9',
      name: 'Potato Chips',
      category: 'Snacks',
      price: 12000,
      imageUrl:
          'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=400&auto=format&fit=crop',
      rating: 4.3,
      reviewCount: 1200,
      distance: '600 m',
    ),
    PosProduct(
      id: '10',
      name: 'Orange Juice',
      category: 'Beverages',
      price: 25000,
      imageUrl:
          'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400&auto=format&fit=crop',
      rating: 4.8,
      reviewCount: 3200,
      distance: '200 m',
    ),
  ];

  List<PosProduct> get filteredProducts {
    return allProducts.where((product) {
      final matchesCategory =
          selectedCategory.value == 'All' ||
          product.category == selectedCategory.value;
      final matchesSearch =
          searchQuery.value.isEmpty ||
          product.name
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void incrementProduct(PosProduct product) {
    final current = quantities[product.id] ?? 0;
    quantities[product.id] = current + 1;
    cartCount.value++;
    cartTotal.value += product.price;
    if (!cartItems.contains(product)) {
      cartItems.add(product);
    }
  }

  void decrementProduct(PosProduct product) {
    final current = quantities[product.id] ?? 0;
    if (current > 0) {
      quantities[product.id] = current - 1;
      cartCount.value--;
      cartTotal.value -= product.price;
      if (quantities[product.id] == 0) {
        cartItems.remove(product);
      }
    }
  }

  void clearCart() {
    quantities.clear();
    cartItems.clear();
    cartCount.value = 0;
    cartTotal.value = 0.0;
  }

  void setCategory(String cat) => selectedCategory.value = cat;

  void setSearch(String query) => searchQuery.value = query;
}
