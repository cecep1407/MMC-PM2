import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChataiController extends GetxController {
  final messages = <Map<String, dynamic>>[].obs;

  // State Management
  final isInputEnabled = true.obs;
  final currentStep = 0.obs;
  final selectedCategory = ''.obs;
  var isLoading = false.obs; // Tambahkan ini

  // User Data
  final userData = {
    'name': 'julius',
    'age': '24',
    'education': '',
    'goal': '',
    'healthIssues': '',
    'height': '',
    'keahlian': '',
    'pengalaman': '',
    'weight': '',
  }.obs;

  // Google Generative AI
  late final GenerativeModel model;

  final questions = [
    "Pilih kategori: Mengatasi Masalah, Motivasi, atau Kesehatan",
    "Apakah saran ini untuk Anda? (Ya/Tidak)",
  ];

  @override
  void onInit() {
    super.onInit();

    // Initialize Google Generative AI
    model = GenerativeModel(
      model: 'gemini-1.5-flash', // Sesuaikan model yang ingin digunakan
      apiKey:
          'AIzaSyANXT8yWyVRXa99ypFSpN_nGBWqii2tGtw', // Ganti dengan API Key Anda
    );

    // Pertanyaan pertama
    messages.add({'text': questions[currentStep.value], 'isUser': false});
  }

  @override
  void onClose() {
    super.onClose();
  }

  void handleButtonPress(String userInput) {
    // Tambahkan pesan pengguna berdasarkan tombol yang ditekan
    messages.add({'text': userInput, 'isUser': true});

    if (currentStep.value == 0) {
      selectedCategory.value = userInput;
      currentStep.value++;
      if (selectedCategory.value.toLowerCase() == 'mengatasi masalah') {
        // Tambahkan logika untuk menampilkan animasi loading
        isLoading.value = true;

        messages.add({
          'text': "Jelaskan Masalah Apa yang sedang anda hadapi (Secara Rinci)",
          'isUser': false
        });
        // Tambahkan logika untuk menampilkan animasi loading
        isLoading.value = false;
        currentStep.value = 5;
      } else if (selectedCategory.value.toLowerCase() == 'motivasi') {
        // Tambahkan logika untuk menampilkan animasi loading
        isLoading.value = true;
        messages.add(
            {'text': "Cita-cita apa yang ingin anda capai?", 'isUser': false});
        // Tambahkan logika untuk menampilkan animasi loading
        isLoading.value = false;
        currentStep.value = 2;
      } else {
        isLoading.value = true;

        messages.add({'text': "Berapa Tinggi badan anda?", 'isUser': false});
        currentStep.value = 2;
        // Tambahkan logika untuk menampilkan animasi loading
        isLoading.value = false;
      }
    } else {
      processUserInput(userInput);
    }
  }

  // void collectUserDataForSelf() {
  //   if(selectedCategory.value.toLowerCase() == 'mengatasi masalah'){
  //     messages.add({'text': "Masalah Apa yang sedang anda hadapi?", 'isUser': false});
  //   currentStep.value = 4;
  //   }else if(selectedCategory.value.toLowerCase() == 'motivasi'){
  //     messages.add({'text': "Cita-cita apa yang ingin anda capai?", 'isUser': false});
  //   currentStep.value = 2;
  //   } else{
  //     messages.add({'text': "Cita-cita apa yang ingin anda capai?", 'isUser': false});
  //     currentStep.value = 2;
  //   }
  // }

  // void collectUserDataForOther() {
  //   messages.add({'text': "Siapa nama orang tersebut?", 'isUser': false});
  //   currentStep.value = 2;
  // }

  void processUserInput(String input) {
    if (currentStep.value == 2) {
      if (selectedCategory.value.toLowerCase() == 'motivasi') {
        userData['goal'] = input;
        isLoading.value = true;
        messages
            .add({'text': "Apa pendidikan terakhir Anda?", 'isUser': false});
        isLoading.value = false;

        currentStep.value = 3;
      } else if (selectedCategory.value.toLowerCase() == 'kesehatan') {
        userData['height'] = input;
        isLoading.value = true;
        messages.add({'text': "Berapa Berat badan Anda?", 'isUser': false});
        isLoading.value = false;
        currentStep.value = 3;
      }
    } else if (currentStep.value == 3) {
      if (selectedCategory.value.toLowerCase() == 'motivasi') {
        userData['education'] = input;
        isLoading.value = true;
        messages.add({'text': "Sebutkan keahlian/hobi anda!", 'isUser': false});
        isLoading.value = false;
        currentStep.value = 4;
      } else if (selectedCategory.value.toLowerCase() == 'kesehatan') {
        userData['weight'] = input;
        isLoading.value = true;
        messages.add({'text': "Masalah kesehatan apa yang Anda hadapi?",'isUser': false});
        isLoading.value = false;
        currentStep.value = 5;
      }
    } else if (currentStep.value == 4) {
      if (selectedCategory.value.toLowerCase() == 'motivasi') {
        userData['keahlian'] = input;
        isLoading.value = true;
        messages.add({'text': "Sebutkan pengalaman anda", 'isUser': false});
        isLoading.value = false;
        currentStep.value = 5;
      }
    } else if (currentStep.value == 5) {
      if (selectedCategory.value.toLowerCase() == 'kesehatan') {
        userData['healthIssues'] = input;
      } else if (selectedCategory.value.toLowerCase() == 'motivasi') {
        userData['pengalaman'] = input;
      } else {
        userData['goal'] = input;
      }
      isInputEnabled.value = false;
      generateAdvice();
      currentStep.value = 6;
    }
  }

  void generateAdvice() async {
    String inputData;
    String prompt = '';

    if (selectedCategory.value.toLowerCase() == 'mengatasi masalah') {
      inputData = '''
      Nama: ${userData['name']}
      Umur: ${userData['age']}
      Masalah: ${userData['goal']}
      ''';
      prompt =
          "Berdasarkan data berikut, berikan solusi terbaik untuk masalah yang dihadapi:\n$inputData";
    } else if (selectedCategory.value.toLowerCase() == 'motivasi') {
      inputData = '''
      Nama: ${userData['name']}
      Umur: ${userData['age']}
      Pendidikan: ${userData['education']}
      Cita-cita: ${userData['goal']}
      Keahlian: ${userData['keahlian']}
      Pengalaman: ${userData['pengalaman']}
      ''';
      prompt =
          "Berdasarkan data berikut, berikan saran terbaik untuk mencapai cita-cita:\n$inputData";
    } else if (selectedCategory.value.toLowerCase() == 'kesehatan') {
      inputData = '''
      Nama: ${userData['name']}
      Umur: ${userData['age']}
      Tinggi: ${userData['height']}
      Berat: ${userData['weight']}
      Masalah Kesehatan: ${userData['healthIssues']}
      ''';
      prompt =
          "Berdasarkan data berikut, berikan saran kesehatan terbaik:\n$inputData";
    }

    try {
      isLoading.value = true;
      final response = await model.generateContent([Content.text(prompt)]);
      final candidates = response.candidates;
      final content = candidates.isNotEmpty
          ? candidates.first.text
          : 'Tidak ada respons dari AI';

      messages.add({'text': content, 'isUser': false});
      isLoading.value = false;

      // currentStep.value = 100;
    } catch (e) {
      messages.add({'text': 'Terjadi kesalahan: $e', 'isUser': false});
    }
  }

  void restartChat() {
    messages.clear();
    currentStep.value = 0;
    isInputEnabled.value = true;
    messages.add({'text': questions[currentStep.value], 'isUser': false});
  }
}
