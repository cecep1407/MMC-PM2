import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class AuthController extends GetxController {
  //TODO: Implement AuthController
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get streamAuthStatus => auth.authStateChanges();

  void signup() {}
  void login(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      // Cetak nilai e.code ke konsol (untuk Debugging)
      print('Error Code: ${e.code}');
      print('Error Message: ${e.message}');
      // Tampilkan error melalui dialog(untuk debugging)
      Get.defaultDialog(
        title: "Proses Gagal",
        middleText: "Error Code: ${e.code}\nMessage: ${e.message}",
      );
      // if (e.code == 'invalid-email') {
      //   print('No user found for that email.');
      //   Get.defaultDialog(
      //     title: "Login Gagal",
      //     middleText: "User Tidak Ditemukan",
      //   );
      // } else if (e.code == 'invalid-credential') {
      //   print('Wrong password provided for that user.');
      //   Get.defaultDialog(
      //     title: "Login Gagal",
      //     middleText: "Password/Email salah",
      //   );
      // }
    }
  }

  void logout() async {
    await auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.defaultDialog(
        title: "Reset Password",
        middleText: "Cek email Anda untuk instruksi reset password.",
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan, coba lagi.';
      if (e.code == 'user-not-found') {
        message = 'Pengguna dengan email tersebut tidak ditemukan.';
      } else if (e.code == 'invalid-email') {
        message = 'Email yang Anda masukkan tidak valid.';
      }
      Get.defaultDialog(
        title: "Proses Gagal",
        middleText: message,
      );
    }
  }
}
