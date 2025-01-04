import 'package:get/get.dart';

import '../controllers/dosen_controller.dart';

class DosenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DosenController>(
      () => DosenController(),
    );
  }
}
