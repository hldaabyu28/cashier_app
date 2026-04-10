import 'package:casier_app/core/network/api_route.dart';
import 'package:casier_app/core/network/dio_config.dart';
import 'package:casier_app/core/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:casier_app/routes/app_routes.dart';

class AuthController extends GetxController {
  final TextEditingController loginUsernameController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController registerUsernameController = TextEditingController();
  final TextEditingController registerPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;

  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = DioConfig.setup(getToken: () async => AuthService.to.token);
  }

  @override
  void onClose() {
    loginUsernameController.dispose();
    loginPasswordController.dispose();
    registerUsernameController.dispose();
    registerPasswordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final username = loginUsernameController.text.trim();
    final password = loginPasswordController.text;

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Username and password cannot be empty',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final response = await _dio.post(
        ApiRoute.LOGIN,
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        if (resData['success'] == true) {
          final token = resData['data']['token'];
          AuthService.to.setToken(token);
          
          Get.snackbar('Success', resData['message'] ?? 'Login berhasil',
              backgroundColor: Colors.green, colorText: Colors.white);
          Get.offAllNamed(AppRoutes.pos);
        } else {
          Get.snackbar('Error', resData['message'] ?? 'Login failed',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', 'Failed to login. Please try again.',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error or unhandled exception.',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    final username = registerUsernameController.text.trim();
    final password = registerPasswordController.text;

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Username and password cannot be empty',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final response = await _dio.post(
        ApiRoute.REGISTER,
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        if (resData['success'] == true) {
          Get.snackbar('Success', resData['message'] ?? 'User berhasil dibuat',
              backgroundColor: Colors.green, colorText: Colors.white);
          
          // Clear registration fields
          registerUsernameController.clear();
          registerPasswordController.clear();
          
          Get.offAllNamed(AppRoutes.login);
        } else {
          Get.snackbar('Error', resData['message'] ?? 'Registration failed',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', 'Failed to register. Please try again.',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error or unhandled exception.',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
