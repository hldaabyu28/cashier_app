import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/theme/app_spacing.dart';
import 'package:casier_app/core/theme/app_text.dart';
import 'package:casier_app/core/widgets/my_button.dart';
import 'package:casier_app/core/widgets/my_input.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Stack(
        children: [
          Positioned(
            top: -150,
            left: -100,
            child: Column(
              children: [
                Container(
                  width: 400,
                  height: 400,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF152534),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(80),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1E2E3D),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Column(
                children: [
                  Text(
                    "Welcome Back",
                    style: AppTextStyle.heading1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Please login to your account",
                    style: AppTextStyle.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
        ],
      ),
      bottomSheet: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              MyInput(placeholder: "Username"),
              SizedBox(height: AppSpacing.md),
              MyInput.password(placeholder: "Password"),
              SizedBox(height: AppSpacing.lg),
              MyButton(
                text: "Login",
                onPressed: () {
                  Get.toNamed('/home');
                },
                isLoading: false,
                color: AppColor.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
