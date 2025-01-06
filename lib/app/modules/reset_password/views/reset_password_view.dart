import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/controllers/auth_controller.dart';
import 'package:myapp/app/modules/reset_password/controllers/reset_password_controller.dart';

class ResetPasswordView extends StatelessWidget {
  final cAuth = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    // Menggunakan controller GetX
    final ResetPasswordController controller =
        Get.put(ResetPasswordController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Lupa Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.cEmail,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                cAuth.resetPassword(controller.cEmail.text);
              },
              child: Text('Kirim Email Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
