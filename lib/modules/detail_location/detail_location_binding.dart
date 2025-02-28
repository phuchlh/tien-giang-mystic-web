import 'package:get/get.dart';
import 'package:tien_giang_mystic/modules/detail_location/detail_location_controller.dart';

class DetailLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailLocationController());
  }
}
