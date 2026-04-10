

import 'package:casier_app/features/auth/presentation/bindings/auth_binding.dart';
import 'package:casier_app/features/auth/presentation/pages/login_page.dart';
import 'package:casier_app/features/auth/presentation/pages/register_page.dart';
import 'package:casier_app/features/pos/presentation/bindings/pos_binding.dart';
import 'package:casier_app/features/pos/presentation/pages/pos_page.dart';
import 'package:casier_app/routes/app_routes.dart';
import 'package:get/get.dart';

class AppPage {
  static const initial = AppRoutes.login;

  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.pos,
      page: () => const PosPage(),
      binding: PosBinding(),
    ),
    
  ];
}