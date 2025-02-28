import 'package:get/get.dart';
import 'package:tien_giang_mystic/main_controller.dart';
import 'package:tien_giang_mystic/modules/chat_screen/chat_screen_controller.dart';
import 'package:tien_giang_mystic/modules/detail_location/detail_location_controller.dart';
import 'package:tien_giang_mystic/modules/home_screen/home_screen_controller.dart';
import 'package:tien_giang_mystic/modules/profile_screen/profile_screen_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeScreenController>(() => HomeScreenController());
    Get.lazyPut<ChatScreenController>(() => ChatScreenController());
    Get.lazyPut<ProfileScreenController>(() => ProfileScreenController());
    Get.lazyPut<DetailLocationController>(() => DetailLocationController(),
        fenix: true);
  }
}
