import 'package:casier_app/features/pos/presentation/controllers/pos_controller.dart';
import 'package:get/get.dart';

class PosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosController>(() => PosController());
  }
}
