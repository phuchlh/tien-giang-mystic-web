import 'package:get/get.dart';
import 'package:tien_giang_mystic/modules/profile_screen/profile_screen_controller.dart';

class ProfileScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileScreenController());
  }
}
