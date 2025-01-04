import 'package:get/get.dart';

import '../controllers/mahasiswa_controller.dart';

class MahasiswaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MahasiswaController>(
      () => MahasiswaController(),
    );
  }
}
