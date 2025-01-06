import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final cName = TextEditingController();
  final cEmail = TextEditingController();
  final cPass = TextEditingController();
  final cConfirmPass = TextEditingController();

  void onClose() {
    cName.dispose();
    cEmail.dispose();
    cPass.dispose();
    cConfirmPass.dispose();
    super.onClose();
  }
}
