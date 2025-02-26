import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tien_giang_mystic/models/place_model.dart';
import 'package:tien_giang_mystic/modules/login_screen/login_screen_binding.dart';
import 'package:tien_giang_mystic/modules/login_screen/login_screen_page.dart';
import 'package:tien_giang_mystic/modules/profile_screen/profile_screen_binding.dart';
import 'package:tien_giang_mystic/modules/profile_screen/profile_screen_page.dart';
import 'package:tien_giang_mystic/route/app_routes.dart';

class HomeScreenController extends GetxController {
  static HomeScreenController get to => Get.find();

  var currentIndex = 0.obs;
  final title = 'Home Screen'.obs;

  final pages = <String>[AppRoutes.chat, AppRoutes.profile];

  void changePage(int index) {
    currentIndex.value = index;
    Get.toNamed(pages[index], id: 1);
  }

  @override
  void onInit() {
    super.onInit();
    onCheckStartingUp();
  }

  void onCheckStartingUp() {
    print('Starting up');
  }

  final placesData = [
    PlaceModel(
        id: 1,
        category: "Du lịch sinh thái",
        icon: "assets/icons/ecotourism.svg"),
    PlaceModel(
        id: 2,
        category: "Di tích lịch sử",
        icon: "assets/icons/historical.svg"),
    PlaceModel(id: 3, category: "Tôn giáo", icon: "assets/icons/religious.svg"),
    PlaceModel(
        id: 4, category: "Vườn trái cây", icon: "assets/icons/orchard.svg"),
    PlaceModel(
        id: 5,
        category: "Làng nghề thủ công",
        icon: "assets/icons/handicraft.svg"),
    PlaceModel(id: 6, category: "lễ hội", icon: "assets/icons/festival.svg"),
    PlaceModel(
        id: 7,
        category: "Địa điểm khảo cổ",
        icon: "assets/icons/archaeology.svg"),
    PlaceModel(
        id: 8, category: "Khu tưởng niệm", icon: "assets/icons/memorial.svg"),
  ];
}
