import 'package:casier_app/core/network/api_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioConfig {
  static final Dio _dio = Dio();
  static bool _isInitialized = false;

  // Base configuration for Dio
  static Dio setup({required Future<String?> Function() getToken}) {
    if (!_isInitialized) {
      _dio.options = BaseOptions(
        baseUrl: ApiRoute.BASE_URL,
        validateStatus: (status) => true,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
        headers: {
          'Accept': 'application/json',
        },
      );

      // Add Interceptors
      _dio.interceptors.addAll([
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // Fetch the token and add to headers
            final token = await getToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            if (kDebugMode) {
              print('Requesting: ${options.uri}');
            }
            return handler.next(options); // Continue the request
          },
          onResponse: (response, handler) {
            if (kDebugMode) {
              print('Response: ${response.statusCode} - ${response.data}');
            }
            return handler.next(response); // Continue to the response
          },
          onError: (error, handler) {
            if (kDebugMode) {
              print('Error: ${error.message} - ${error.response?.data}');
            }
            return handler.next(error); // Continue to the error
          },
        ),
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          compact: true,
          maxWidth: 90,
        )
      ]);
      _isInitialized = true;
    }

    return _dio;
  }
}
