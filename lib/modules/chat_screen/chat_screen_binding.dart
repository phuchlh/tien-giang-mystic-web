import 'package:get/get.dart';
import 'package:tien_giang_mystic/modules/chat_screen/chat_screen_controller.dart';

class ChatScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatScreenController());
  }
}
