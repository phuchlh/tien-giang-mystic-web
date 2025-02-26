import 'package:get/get.dart';
import 'package:tien_giang_mystic/modules/login_screen/login_screen_controller.dart';

class LoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginScreenController());
  }
}
