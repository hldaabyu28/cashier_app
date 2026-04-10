import 'package:get/get.dart';

class AuthService extends GetxService {
  final RxnString _token = RxnString();
  
  String? get token => _token.value;
  
  void setToken(String? value) {
    _token.value = value;
  }
  
  bool get isAuthenticated => _token.value != null;

  static AuthService get to => Get.find();
}
