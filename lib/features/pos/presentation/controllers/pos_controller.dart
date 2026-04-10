import 'package:casier_app/core/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:casier_app/core/network/dio_config.dart';
import 'package:casier_app/core/network/api_route.dart';
import 'package:flutter/material.dart';

class PosProduct {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final int stock;
  final String description;

  const PosProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.stock,
    this.description = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PosProduct && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class PosController extends GetxController {
  final RxBool isLoading = true.obs;
  late final Dio _dio;

  final RxString pageTitle = 'Point of Sale'.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxInt cartCount = 0.obs;
  final RxDouble cartTotal = 0.0.obs;
  final RxList<PosProduct> cartItems = <PosProduct>[].obs;

  final RxInt selectedTab = 0.obs;
  final RxMap<String, int> quantities = <String, int>{}.obs;

  final RxList<String> categories = <String>['All'].obs;
  final RxList<PosProduct> allProducts = <PosProduct>[].obs;

  @override
  void onInit() {
    super.onInit();
    _dio = DioConfig.setup(getToken: () async => AuthService.to.token);
    fetchProducts();
  }

  int getQty(String productId) => quantities[productId] ?? 0;

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final response = await _dio.get(ApiRoute.PRODUCTS);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        if (resData['success'] == true) {
          final List<dynamic> dataList = resData['data'];
          
          final fetchedProducts = dataList.map((item) {
            final categoryObj = item['category'];
            final categoryName = categoryObj != null ? categoryObj['name'] : 'Uncategorized';
            
            return PosProduct(
              id: item['_id']?.toString() ?? '',
              name: item['name'] ?? '',
              category: categoryName.toString(),
              price: item['price']?.toDouble() ?? 0.0,
              imageUrl: item['image'] ?? '',
              stock: item['stock'] ?? 0,
              description: item['description'] ?? '',
            );
          }).toList();
          
          allProducts.value = fetchedProducts;

          // Update dynamic categories
          final Set<String> uniqueCats = {'All'};
          for (var p in fetchedProducts) {
             uniqueCats.add(p.category);
          }
          categories.value = uniqueCats.toList();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products: $e');
    } finally {
      isLoading.value = false;
    }
  }

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
    if (product.stock <= getQty(product.id)) {
      Get.snackbar('Out of Stock', 'Cannot add more of ${product.name}',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    
    final current = quantities[product.id] ?? 0;
    quantities[product.id] = current + 1;
    cartCount.value++;
    cartTotal.value += product.price;
    
    if (!cartItems.any((item) => item.id == product.id)) {
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
        cartItems.removeWhere((item) => item.id == product.id);
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
