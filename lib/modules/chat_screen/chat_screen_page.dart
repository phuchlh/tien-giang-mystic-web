import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tien_giang_mystic/modules/chat_screen/chat_screen_controller.dart';

class ChatScreenPage extends StatelessWidget {
  const ChatScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatScreenController>(
      builder: (controller) => Scaffold(
        body: Center(
          child: Container(
            child: Text("Chat"),
          ),
        ),
      ),
    );
  }
}
