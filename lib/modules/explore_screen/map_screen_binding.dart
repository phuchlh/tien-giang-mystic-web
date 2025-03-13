import 'package:get/get.dart';

import 'map_screen_controller.dart';

class MapScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MapScreenController());
  }
}
