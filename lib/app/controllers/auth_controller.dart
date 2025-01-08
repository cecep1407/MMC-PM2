import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class AuthController extends GetxController {
  //TODO: Implement AuthController
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get streamAuthStatus => auth.authStateChanges();
  @override
  void onInit() {
    super.onInit();
    print("[AuthController] Initialized");
  }

  void register(
    String name,
    String email,
    DateTime birthDate,
    String password,
    String confirmPassword,
  ) async {
    try {
      // Validasi jika ada kolom yang kosong
      if (name.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        Get.defaultDialog(
          title: "Pendaftaran Gagal",
          middleText: "Semua kolom harus diisi.",
        );
        return;
      }

      // Validasi password dan konfirmasi password
      if (password != confirmPassword) {
        Get.defaultDialog(
          title: "Pendaftaran Gagal",
          middleText: "Password dan konfirmasi password tidak cocok.",
        );
        return;
      }

      // Proses registrasi menggunakan Firebase Auth
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Setelah registrasi sukses, Anda bisa menambahkan informasi tambahan ke Firestore
      // seperti nama pengguna, email, dan tanggal lahir.
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Pengguna sudah terautentikasi
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'birthDate': birthDate
              .toIso8601String()
              .split('T')[0], // Menyimpan tanggal lahir
        });
      } else {
        // Pengguna belum terautentikasi
        Get.defaultDialog(
          title: "Login Diperlukan",
          middleText: "Anda harus login terlebih dahulu untuk melanjutkan.",
        );
      }

      // Pendaftaran berhasil, navigasi ke halaman login atau home
      Get.snackbar(
        "Pendaftaran Sukses",
        "Akun berhasil dibuat, silakan login.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Get.reset();
      // Reinisialisasi AuthController jika menggunakan Get.reset()
      // Get.put(AuthController());
      // Navigasi ke halaman login setelah pendaftaran berhasil
      // Get.delete<AuthController>();
      Get.offAllNamed(Routes.LOGIN);
    } on FirebaseAuthException catch (e) {
      // Tangani error yang mungkin terjadi selama registrasi
      if (e.code == 'email-already-in-use') {
        Get.defaultDialog(
          title: "Pendaftaran Gagal",
          middleText: "Email sudah digunakan, coba dengan email lain.",
        );
      } else if (e.code == 'weak-password') {
        Get.defaultDialog(
          title: "Pendaftaran Gagal",
          middleText:
              "Password terlalu lemah, gunakan password yang lebih kuat.",
        );
      } else {
        // Menampilkan error secara umum
        Get.defaultDialog(
          title: "Pendaftaran Gagal",
          middleText: "Terjadi kesalahan, coba lagi nanti.",
        );
      }
    }
  }

  // void login(String email, String password) async {
  //   try {
  //     final credential = await auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     Get.offAllNamed(Routes.HOME);
  //   } on FirebaseAuthException catch (e) {
  //     // Cetak nilai e.code ke konsol (untuk Debugging)
  //     // print('Error Code: ${e.code}');
  //     // print('Error Message: ${e.message}');
  //     // // Tampilkan error melalui dialog(untuk debugging)
  // Get.defaultDialog(
  //   title: "Proses Gagal",
  //   middleText: "Error Code: ${e.code}\nMessage: ${e.message}",
  // );
  // if (e.code == 'invalid-email') {
  //   print('No user found for that email.');
  //   Get.defaultDialog(
  //     title: "Login Gagal",
  //     middleText: "Format Email Salah",
  //   );
  // } else if (e.code == 'invalid-credential') {
  //   print('Wrong password provided for that user.');
  //   Get.defaultDialog(
  //     title: "Login Gagal",
  //     middleText: "Password/Email salah",
  //   );
  // }
  //   }
  // }

  // void logout() async {
  //   await auth.signOut();
  //   Get.offAllNamed(Routes.LOGIN);
  // }

  // State untuk menyimpan data user
  var currentUserData = {}.obs;

  // Fungsi untuk mengambil data user dari Firestore setelah login
  Future<void> loadUserData(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        currentUserData.value = snapshot.data()!;
      } else {
        Get.defaultDialog(
          title: "Error",
          middleText: "Data user tidak ditemukan.",
        );
      }
    } catch (e) {
      Get.defaultDialog(
        title: "Error",
        middleText: "Gagal memuat data user.",
      );
    }
  }

  // Fungsi login dengan data user dimuat
  void login(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ambil data user dari Firestore berdasarkan UID
      String uid = credential.user!.uid;
      // print('uiddddddd: ${uid}');
      await loadUserData(uid);

      // Navigasi ke halaman utama
      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      String message = "Login gagal.";
      if (e.code == 'invalid-email') {
        print('No user found for that email.');
        Get.defaultDialog(
          title: "Login Gagal",
          middleText: "Format Email Salah",
        );
      } else if (e.code == 'invalid-credential') {
        print('Wrong password provided for that user.');
        Get.defaultDialog(
          title: "Login Gagal",
          middleText: "Password/Email salah",
        );
      }
    }
  }

  // Fungsi logout
  void logout() async {
    await auth.signOut();
    currentUserData.clear(); // Bersihkan data user
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
