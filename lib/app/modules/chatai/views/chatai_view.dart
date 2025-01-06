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
      appBar: AppBar(title: Text("Chat AI")),
      body: Obx(() {
        return Column(
          children: [
            // Chat Messages Display
            Expanded(
              child: ListView.builder(
                itemCount: controller.isLoading.value
                    ? controller.messages.length + 1 // Tambahkan pesan dummy saat mengetik
                    : controller.messages.length,
                itemBuilder: (context, index) {
                  // Cek apakah ini adalah pesan dummy (server sedang mengetik)
                  if (index == controller.messages.length && controller.isLoading.value) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SpinKitThreeBounce(
                          color: Colors.grey,
                          size: 20.0,
                        ),
                      ),
                    );
                  }

                  final message = controller.messages[index];
                  final isUser = message['isUser'] ?? false;

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message['text'] ?? '',
                        style: TextStyle(color: isUser ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Step Logic
            if (controller.currentStep.value == 0) ...[
              // Step 0: Select Category
              Text("Pilih kategori:", style: TextStyle(fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => controller.handleButtonPress("Mengatasi Masalah"),
                    child: Text("Mengatasi Masalah"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => controller.handleButtonPress("Motivasi"),
                    child: Text("Motivasi"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => controller.handleButtonPress("Kesehatan"),
                    child: Text("Kesehatan"),
                  ),
                ],
              ),
            ] else if (controller.currentStep.value < 6) ...[
              // Other Steps: Input Field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textEditingController, // Attach controller
                          decoration: const InputDecoration(
                            hintText: 'Ketik jawaban Anda...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              controller.handleButtonPress(value);
                              textEditingController.clear(); // Clear input field
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.orange),
                        onPressed: () {
                          final value = textEditingController.text.trim();
                          if (value.isNotEmpty) {
                            controller.handleButtonPress(value);
                            textEditingController.clear(); // Clear input field
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Restart Chat
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => controller.restartChat(),
                    child: Text("Mulai Ulang"),
                  ),
                ],
              ),
            ],
          ],
        );
      }),
    );
  }
}
