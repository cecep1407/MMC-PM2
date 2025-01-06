import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../controllers/chatai_controller.dart';

class ChataiView extends StatelessWidget {
  final ChataiController controller = Get.put(ChataiController());
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              // Chat Messages Display
              Expanded(
                child: Container(
                  color: Colors.grey[100], // Light background for messages
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: controller.isLoading.value
                        ? controller.messages.length + 1 // Include loading
                        : controller.messages.length,
                    itemBuilder: (context, index) {
                      // Show loading animation when typing
                      if (index == controller.messages.length &&
                          controller.isLoading.value) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const SpinKitThreeBounce(
                              color: Colors.grey,
                              size: 20.0,
                            ),
                          ),
                        );
                      }

                      final message = controller.messages[index];
                      final isUser = message['isUser'] ?? false;

                      return Align(
                        alignment:
                            isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: buildFormattedText(
                            message['text'] ?? '',
                            isUser,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Step Logic
              if (controller.currentStep.value == 0) ...[
                // Step 0: Select Category
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Pilih kategori:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryButton("Mengatasi Masalah"),
                      _buildCategoryButton("Motivasi"),
                      _buildCategoryButton("Kesehatan"),
                    ],
                  ),
                ),
              ] else if (controller.currentStep.value < 6) ...[
                // Other Steps: Input Field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            controller: textEditingController,
                            decoration: const InputDecoration(
                              hintText: 'Ketik jawaban Anda...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                controller.handleButtonPress(value);
                                textEditingController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          final value = textEditingController.text.trim();
                          if (value.isNotEmpty) {
                            controller.handleButtonPress(value);
                            textEditingController.clear();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Restart Chat
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () => controller.restartChat(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Mulai Ulang"),
                  ),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCategoryButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () => controller.handleButtonPress(text),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          backgroundColor: Colors.blue[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  // Fungsi untuk memformat teks
  Widget buildFormattedText(String text, bool isUser) {
    final boldRegex = RegExp(r'\*\*(.*?)\*\*'); // Pola untuk mencari **teks**

    final spans = <TextSpan>[];
    int start = 0;

    // Temukan semua bagian yang sesuai pola
    for (final match in boldRegex.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: TextStyle(color: isUser ? Colors.white : Colors.black),
        ));
      }
      spans.add(TextSpan(
        text: match.group(1), // Isi tanpa **
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isUser ? Colors.white : Colors.black,
        ),
      ));
      start = match.end;
    }

    // Tambahkan sisa teks setelah pencocokan terakhir
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: TextStyle(color: isUser ? Colors.white : Colors.black),
      ));
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: TextStyle(color: isUser ? Colors.white : Colors.black),
      ),
    );
  }
}
