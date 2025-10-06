import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/theme/app_text.dart';
import 'package:casier_app/core/widgets/my_button.dart';
import 'package:casier_app/core/widgets/my_input.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyButton(text: "Hello", onPressed: (){}, isLoading: false, color: AppColor.secondary, icon: Icons.login,),
          Text("Login Page", style: AppTextStyle.heading1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyInput(controller: TextEditingController()),
          )
        ],
      )
    );
  }
}