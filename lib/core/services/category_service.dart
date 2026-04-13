import 'package:casier_app/core/network/api_route.dart';
import 'package:casier_app/core/network/dio_config.dart';
import 'package:casier_app/core/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CategoryService extends GetxService {
  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = DioConfig.setup(getToken: () async => AuthService.to.token);
  }

  /// GET /categories — Get all product categories
  Future<List<dynamic>?> getCategories() async {
    try {
      final response = await _dio.get(ApiRoute.CATEGORIES);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return response.data['data'];
      }
    } catch (e) {
      if (kDebugMode) print('CategoryService.getCategories error: $e');
    }
    return null;
  }

  /// POST /categories — Create category (Admin)
  Future<Map<String, dynamic>?> createCategory({
    required String name,
  }) async {
    try {
      final response = await _dio.post(
        ApiRoute.CATEGORIES,
        data: {'name': name},
      );
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return response.data['data'];
      }
    } catch (e) {
      if (kDebugMode) print('CategoryService.createCategory error: $e');
    }
    return null;
  }

  static CategoryService get to => Get.find();
}
