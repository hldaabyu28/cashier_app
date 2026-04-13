import 'package:casier_app/core/network/api_route.dart';
import 'package:casier_app/core/network/dio_config.dart';
import 'package:casier_app/core/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CartService extends GetxService {
  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = DioConfig.setup(getToken: () async => AuthService.to.token);
  }

  /// GET /cart — Fetch current cashier's cart
  Future<Map<String, dynamic>?> getCart() async {
    try {
      final response = await _dio.get(ApiRoute.CART);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return response.data['data'];
      }
    } catch (e) {
      if (kDebugMode) print('CartService.getCart error: $e');
    }
    return null;
  }

  /// POST /cart/add — Add or update quantity in cart
  Future<Map<String, dynamic>?> addToCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      final response = await _dio.post(
        ApiRoute.CART_ADD,
        data: {
          'productId': productId,
          'quantity': quantity,
        },
      );
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return response.data['data'];
      }
    } catch (e) {
      if (kDebugMode) print('CartService.addToCart error: $e');
    }
    return null;
  }

  /// DELETE /cart/remove/:productId — Remove item from cart
  Future<bool> removeFromCart(String productId) async {
    try {
      final response = await _dio.delete(ApiRoute.cartRemove(productId));
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) print('CartService.removeFromCart error: $e');
    }
    return false;
  }

  /// DELETE /cart/clear — Empty the cart
  Future<bool> clearCart() async {
    try {
      final response = await _dio.delete(ApiRoute.CART_CLEAR);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) print('CartService.clearCart error: $e');
    }
    return false;
  }

  static CartService get to => Get.find();
}
