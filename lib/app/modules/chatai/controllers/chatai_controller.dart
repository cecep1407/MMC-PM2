import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChataiController extends GetxController {
  // List untuk menyimpan pesan
  final messages = <Map<String, dynamic>>[].obs;

  // TextEditingController untuk mengelola input teks
  final textEditingController = TextEditingController();

  // Inisialisasi model
  late final GenerativeModel model;

  // Variabel untuk menyimpan data pengguna
  final userData = {
    'name': '',
    'age': '',
    'education': '',
    'goal': '',
  }.obs;

  // Variabel untuk melacak tahap pertanyaan
  final currentStep = 0.obs;

  final questions = [
    'Halo! Siapa nama kamu?',
    'Berapa umur kamu?',
    'Apa pendidikan terakhir kamu?',
    'Apa cita-cita kamu?'
  ];

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi model dengan API Key
    model = GenerativeModel(
      model: 'gemini-1.5-flash', // Sesuaikan dengan model yang ingin digunakan
      apiKey: 'AIzaSyANXT8yWyVRXa99ypFSpN_nGBWqii2tGtw', // Ganti dengan API Key Anda
    );

    // Mulai dengan pertanyaan pertama
    messages.add({'text': questions[currentStep.value], 'isUser': false});
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }

  // Fungsi untuk mengirim pesan
  void sendMessage() async {
    final userInput = textEditingController.text.trim();
    if (userInput.isEmpty) return;

    // Tambahkan pesan pengguna ke daftar pesan
    messages.add({'text': userInput, 'isUser': true});
    textEditingController.clear();

    // Simpan data berdasarkan tahapan
    if (currentStep.value < questions.length) {
      switch (currentStep.value) {
        case 0:
          userData['name'] = userInput;
          break;
        case 1:
          userData['age'] = userInput;
          break;
        case 2:
          userData['education'] = userInput;
          break;
        case 3:
          userData['goal'] = userInput;
          break;
      }

      // Pindah ke tahap berikutnya
      currentStep.value++;

      if (currentStep.value < questions.length) {
        // Tampilkan pertanyaan berikutnya
        messages.add({'text': questions[currentStep.value], 'isUser': false});
      } else {
        // Jika semua pertanyaan selesai, panggil API Gemini untuk memberikan saran
        final inputData = '''
          Nama: ${userData['name']}
          Umur: ${userData['age']}
          Pendidikan: ${userData['education']}
          Cita-cita: ${userData['goal']}
        ''';

        try {
          final response = await model.generateContent([Content.text('Tulis Ulang Biodata tersebut dan berikan saran terbaik untuk meraih cita cita'+inputData)]);
          final candidates = response.candidates;
          final content = candidates.isNotEmpty ? candidates.first.text : 'Tidak ada respons dari AI';

          messages.add({'text': content, 'isUser': false});
        } catch (e) {
          messages.add({'text': 'Terjadi kesalahan: $e', 'isUser': false});
        }
      }
    }
  }
}
