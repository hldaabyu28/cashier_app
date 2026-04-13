import 'package:casier_app/core/services/cart_service.dart';
import 'package:casier_app/core/services/category_service.dart';
import 'package:casier_app/core/services/discount_service.dart';
import 'package:casier_app/core/services/tax_service.dart';
import 'package:casier_app/core/services/transaction_service.dart';
import 'package:casier_app/features/pos/presentation/controllers/pos_controller.dart';
import 'package:get/get.dart';

class PosBinding extends Bindings {
  @override
  void dependencies() {
    // Register services first (PosController depends on these)
    Get.lazyPut<CartService>(() => CartService());
    Get.lazyPut<TransactionService>(() => TransactionService());
    Get.lazyPut<DiscountService>(() => DiscountService());
    Get.lazyPut<TaxService>(() => TaxService());
    Get.lazyPut<CategoryService>(() => CategoryService());

    // Register controller
    Get.lazyPut<PosController>(() => PosController());
  }
}
