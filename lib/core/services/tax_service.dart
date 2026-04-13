import 'package:casier_app/core/network/api_route.dart';
import 'package:casier_app/core/network/dio_config.dart';
import 'package:casier_app/core/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class TaxService extends GetxService {
  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = DioConfig.setup(getToken: () async => AuthService.to.token);
  }

  /// GET /taxes — Get all taxes
  Future<List<dynamic>?> getTaxes() async {
    try {
      final response = await _dio.get(ApiRoute.TAXES);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return response.data['data'];
      }
    } catch (e) {
      if (kDebugMode) print('TaxService.getTaxes error: $e');
    }
    return null;
  }

  /// POST /taxes — Create new tax (Admin)
  Future<Map<String, dynamic>?> createTax({
    required String name,
    required double percentage,
  }) async {
    try {
      final response = await _dio.post(
        ApiRoute.TAXES,
        data: {
          'name': name,
          'percentage': percentage,
        },
      );
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return response.data['data'];
      }
    } catch (e) {
      if (kDebugMode) print('TaxService.createTax error: $e');
    }
    return null;
  }

  static TaxService get to => Get.find();
}
