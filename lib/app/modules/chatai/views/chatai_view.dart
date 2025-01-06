import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chatai_controller.dart';

class ChataiView extends GetView<ChataiController> {
  const ChataiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChataiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ChataiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
