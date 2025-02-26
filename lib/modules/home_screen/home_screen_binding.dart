import 'package:get/get.dart';
import 'package:tien_giang_mystic/modules/home_screen/home_screen_controller.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeScreenController());
  }
}
