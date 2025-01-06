import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chatai_controller.dart';

class ChataiView extends StatelessWidget {
  ChataiView({super.key});

  final ChataiController controller = Get.put(ChataiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isUser = message['isUser'] as bool;
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.orange : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:  buildFormattedText(message['text'] as String, isUser),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) => controller.sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.orange),
                  onPressed: controller.sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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

