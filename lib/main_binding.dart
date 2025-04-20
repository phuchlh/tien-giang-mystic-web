import 'package:get/get.dart';

import 'modules/auth/auth_controller.dart';
import 'modules/detail_location/detail_location_controller.dart';
import 'modules/map_screen/map_screen_controller.dart';
import 'modules/profile_screen/profile_screen_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<MainController>(() => MainController());
    // Get.lazyPut<ExploreScreenController>(() => ExploreScreenController());
    // Get.lazyPut<HomeScreenController>(() => HomeScreenController());
    // Get.lazyPut<ProfileScreenController>(() => ProfileScreenController());
    Get.put(MapScreenController());
    Get.put(ProfileScreenController());
    Get.put(AuthController());
    Get.lazyPut<DetailLocationController>(() => DetailLocationController(), fenix: true);
  }
}
