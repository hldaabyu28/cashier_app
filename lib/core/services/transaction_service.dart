import 'package:casier_app/core/network/api_route.dart';
import 'package:casier_app/core/network/dio_config.dart';
import 'package:casier_app/core/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class TransactionService extends GetxService {
  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = DioConfig.setup(getToken: () async => AuthService.to.token);
  }

  /// POST /transactions — Create transaction (Checkout)
  /// If no [items] are provided, it will automatically use items from the Cart.
  Future<Map<String, dynamic>?> createTransaction({
    required String customer,
    required String paymentType,
    String? discountCode,
    String? taxId,
    List<Map<String, dynamic>>? items,
  }) async {
    try {
      final data = <String, dynamic>{
        'customer': customer,
        'paymentType': paymentType,
      };
      if (discountCode != null && discountCode.isNotEmpty) {
        data['discountCode'] = discountCode;
      }
      if (taxId != null && taxId.isNotEmpty) {
        data['taxId'] = taxId;
      }
      if (items != null && items.isNotEmpty) {
        data['items'] = items;
      }

      final response = await _dio.post(ApiRoute.TRANSACTIONS, data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
      return response.data;
    } catch (e) {
      if (kDebugMode) print('TransactionService.createTransaction error: $e');
    }
    return null;
  }

  /// GET /transactions — Get transaction history
  Future<List<dynamic>?> getTransactions() async {
    try {
      final response = await _dio.get(ApiRoute.TRANSACTIONS);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return response.data['data'];
      }
    } catch (e) {
      if (kDebugMode) print('TransactionService.getTransactions error: $e');
    }
    return null;
  }

  /// GET /transactions/:id — Get transaction detail
  Future<Map<String, dynamic>?> getTransactionDetail(String id) async {
    try {
      final response = await _dio.get(ApiRoute.transactionDetail(id));
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return response.data['data'];
      }
    } catch (e) {
      if (kDebugMode) {
        print('TransactionService.getTransactionDetail error: $e');
      }
    }
    return null;
  }

  static TransactionService get to => Get.find();
}
