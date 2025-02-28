import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tien_giang_mystic/modules/chat_screen/chat_screen_controller.dart';

class ChatScreenPage extends GetView<ChatScreenController> {
  const ChatScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Chat Screen'),
    );
  }
}
