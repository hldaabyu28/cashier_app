import 'package:casier_app/core/network/api_route.dart';
import 'package:casier_app/core/network/dio_config.dart';
import 'package:casier_app/core/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DiscountService extends GetxService {
  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = DioConfig.setup(getToken: () async => AuthService.to.token);
  }

  /// GET /discounts — Get all active discounts
  Future<List<dynamic>?> getDiscounts() async {
    try {
      final response = await _dio.get(ApiRoute.DISCOUNTS);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return response.data['data'];
      }
    } catch (e) {
      if (kDebugMode) print('DiscountService.getDiscounts error: $e');
    }
    return null;
  }

  /// GET /discounts/check/:code — Validate a discount code
  Future<Map<String, dynamic>?> checkDiscountCode(String code) async {
    try {
      final response = await _dio.get(ApiRoute.discountCheck(code));
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return response.data['data'];
      }
    } catch (e) {
      if (kDebugMode) print('DiscountService.checkDiscountCode error: $e');
    }
    return null;
  }

  static DiscountService get to => Get.find();
}
