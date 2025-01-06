import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final cName = TextEditingController();
  final cEmail = TextEditingController();
  final cDob = Rx<DateTime>(DateTime.now()); // Gunakan Rx<DateTime>
  final cPass = TextEditingController();
  final cConfirmPass = TextEditingController();

  // Fungsi untuk mengubah tanggal lahir
  void setDob(DateTime date) {
    cDob.value = date;
  }

  @override
  void onClose() {
    cName.dispose();
    cEmail.dispose();
    cPass.dispose();
    cConfirmPass.dispose();
    super.onClose();
  }
}
