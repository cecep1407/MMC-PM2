import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/controllers/auth_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final cAuth =  Get.put(AuthController()); 

  @override
  Widget build(BuildContext context) {
     final cEmail = TextEditingController();
  final cPass = TextEditingController();
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA), // Background warna pastel abu-abu lembut
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              height: 240,
              decoration: BoxDecoration(
                color: Color(0xFFD4E7FE), // Warna pastel biru lembut
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/MMC_logo.png", // Logo MMC AI
                        height: 80,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MMC AI",
                            style: TextStyle(
                              color: Color(0xFF24476F), // Biru tua pastel
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Solusi Cerdas Anda",
                            style: TextStyle(
                              color: Color(0xFF74B3CE), // Biru pastel lembut
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

             // Login Form
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Selamat Datang",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF24476F), // Biru tua pastel
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Masuk untuk melanjutkan",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF748A9D), // Abu pastel lembut
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: cEmail,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email, color: Color(0xFF74B3CE)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: cPass,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF74B3CE)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      cAuth.login(
                          cEmail.text, cPass.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF74B3CE), // Biru pastel
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Teks putih
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.RESET_PASSWORD);
                      },
                      child: Text(
                        "Lupa Password?",
                        style: TextStyle(color: Color(0xFF24476F)), // Biru tua
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum punya akun?",
                        style: TextStyle(
                          color: Color(0xFF748A9D), // Abu pastel lembut
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.REGISTER); // Navigasi ke halaman register
                        },
                        child: Text(
                          "Daftar Sekarang",
                          style: TextStyle(
                            color: Color(0xFF74B3CE), // Biru pastel lembut
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Developed by MMC",
                      style: TextStyle(
                        color: Color(0xFF748A9D), // Abu pastel lembut
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}