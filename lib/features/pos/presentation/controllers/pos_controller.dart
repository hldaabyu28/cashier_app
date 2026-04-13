import 'package:casier_app/core/services/auth_service.dart';
import 'package:casier_app/core/services/cart_service.dart';
import 'package:casier_app/core/services/transaction_service.dart';
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
  final RxBool isCartLoading = false.obs;
  final RxBool isCheckoutLoading = false.obs;
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

  // Transaction history
  final RxList<Map<String, dynamic>> transactionHistory =
      <Map<String, dynamic>>[].obs;
  final RxBool isTransactionLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _dio = DioConfig.setup(getToken: () async => AuthService.to.token);
    fetchProducts();
    fetchCart();
  }

  int getQty(String productId) => quantities[productId] ?? 0;

  // ─── Products ──────────────────────────────────────────────────────────────

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
            final categoryName =
                categoryObj != null ? categoryObj['name'] : 'Uncategorized';

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
      final matchesCategory = selectedCategory.value == 'All' ||
          product.category == selectedCategory.value;
      final matchesSearch = searchQuery.value.isEmpty ||
          product.name
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // ─── Cart API Integration ──────────────────────────────────────────────────

  Future<void> fetchCart() async {
    try {
      isCartLoading.value = true;
      final cartData = await CartService.to.getCart();

      if (cartData != null) {
        final List<dynamic> items = cartData['items'] ?? [];
        _syncCartFromApi(items);
      }
    } catch (e) {
      // Silently fail — local cart state is still usable
    } finally {
      isCartLoading.value = false;
    }
  }

  void _syncCartFromApi(List<dynamic> items) {
    quantities.clear();
    cartItems.clear();
    int totalCount = 0;
    double totalPrice = 0.0;

    for (final item in items) {
      final productData = item['product'];
      if (productData == null) continue;

      final String productId = productData['_id']?.toString() ?? '';
      final int qty = item['quantity'] ?? 0;

      if (productId.isEmpty || qty <= 0) continue;

      final categoryObj = productData['category'];
      final categoryName =
          categoryObj is Map ? categoryObj['name'] : (categoryObj ?? 'Uncategorized');

      final product = PosProduct(
        id: productId,
        name: productData['name'] ?? '',
        category: categoryName.toString(),
        price: productData['price']?.toDouble() ?? 0.0,
        imageUrl: productData['image'] ?? '',
        stock: productData['stock'] ?? 0,
        description: productData['description'] ?? '',
      );

      quantities[productId] = qty;
      cartItems.add(product);
      totalCount += qty;
      totalPrice += product.price * qty;
    }

    cartCount.value = totalCount;
    cartTotal.value = totalPrice;
  }

  Future<void> incrementProduct(PosProduct product) async {
    if (product.stock <= getQty(product.id)) {
      Get.snackbar('Out of Stock', 'Cannot add more of ${product.name}',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    // Optimistic UI update
    final current = quantities[product.id] ?? 0;
    quantities[product.id] = current + 1;
    cartCount.value++;
    cartTotal.value += product.price;

    if (!cartItems.any((item) => item.id == product.id)) {
      cartItems.add(product);
    }

    // Sync to API
    final result = await CartService.to.addToCart(
      productId: product.id,
      quantity: quantities[product.id]!,
    );

    if (result == null) {
      // Rollback on failure
      quantities[product.id] = current;
      cartCount.value--;
      cartTotal.value -= product.price;
      if (current == 0) {
        cartItems.removeWhere((item) => item.id == product.id);
      }
      Get.snackbar('Error', 'Failed to add item to cart',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> decrementProduct(PosProduct product) async {
    final current = quantities[product.id] ?? 0;
    if (current <= 0) return;

    // Optimistic UI update
    quantities[product.id] = current - 1;
    cartCount.value--;
    cartTotal.value -= product.price;

    bool shouldRemove = quantities[product.id] == 0;
    if (shouldRemove) {
      cartItems.removeWhere((item) => item.id == product.id);
    }

    // Sync to API
    bool success;
    if (shouldRemove) {
      success = await CartService.to.removeFromCart(product.id);
    } else {
      final result = await CartService.to.addToCart(
        productId: product.id,
        quantity: quantities[product.id]!,
      );
      success = result != null;
    }

    if (!success) {
      // Rollback on failure
      quantities[product.id] = current;
      cartCount.value++;
      cartTotal.value += product.price;
      if (shouldRemove) {
        cartItems.add(product);
      }
      Get.snackbar('Error', 'Failed to update cart',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> clearCart() async {
    // Store for rollback
    final prevQuantities = Map<String, int>.from(quantities);
    final prevItems = List<PosProduct>.from(cartItems);
    final prevCount = cartCount.value;
    final prevTotal = cartTotal.value;

    // Optimistic UI update
    quantities.clear();
    cartItems.clear();
    cartCount.value = 0;
    cartTotal.value = 0.0;

    final success = await CartService.to.clearCart();
    if (!success) {
      // Rollback
      quantities.addAll(prevQuantities);
      cartItems.addAll(prevItems);
      cartCount.value = prevCount;
      cartTotal.value = prevTotal;
      Get.snackbar('Error', 'Failed to clear cart',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // ─── Checkout / Transaction ────────────────────────────────────────────────

  Future<Map<String, dynamic>?> checkout({
    required String customerName,
    required String paymentType,
    String? discountCode,
    String? taxId,
  }) async {
    try {
      isCheckoutLoading.value = true;

      final response = await TransactionService.to.createTransaction(
        customer: customerName,
        paymentType: paymentType,
        discountCode: discountCode,
        taxId: taxId,
      );

      if (response != null && response['success'] == true) {
        // Clear local cart state after successful checkout
        quantities.clear();
        cartItems.clear();
        cartCount.value = 0;
        cartTotal.value = 0.0;

        Get.snackbar(
          'Success',
          response['message'] ?? 'Transaction created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );

        return response['data'];
      } else {
        Get.snackbar(
          'Error',
          response?['message'] ?? 'Failed to create transaction',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Checkout failed: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isCheckoutLoading.value = false;
    }
    return null;
  }

  // ─── Transaction History ───────────────────────────────────────────────────

  Future<void> fetchTransactions() async {
    try {
      isTransactionLoading.value = true;
      final data = await TransactionService.to.getTransactions();
      if (data != null) {
        transactionHistory.value =
            data.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch transactions',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isTransactionLoading.value = false;
    }
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  void setCategory(String cat) => selectedCategory.value = cat;
  void setSearch(String query) => searchQuery.value = query;
}
