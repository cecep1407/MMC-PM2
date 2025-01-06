import 'package:get/get.dart';

import '../controllers/chatai_controller.dart';

class ChataiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChataiController>(
      () => ChataiController(),
    );
  }
}
