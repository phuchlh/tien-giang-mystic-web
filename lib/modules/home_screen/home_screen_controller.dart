import 'package:get/get.dart';

import '../../models/place_model.dart';
import '../../route/app_routes.dart';
import '../../utils/images.dart';

class HomeScreenController extends GetxController {
  static HomeScreenController get to => Get.find();

  var currentIndex = 0.obs;
  final title = 'Home Screen'.obs;

  final pages = <String>[AppRoutes.chat, AppRoutes.profile];

  List<PlaceModel> listPlaces = [
    PlaceModel(
      id: 1,
      image: Images.tgicon,
      title: 'Cai Be Floating Market',
      location: 'Cai Be, Tien Giang',
    ),
    PlaceModel(
      id: 2,
      image: Images.tgicon,
      title: 'Cai Be Floating Market',
      location: 'Cai Be, Tien Giang',
    ),
    PlaceModel(
      id: 3,
      image: Images.tgicon,
      title: 'Cai Be Floating Market',
      location: 'Cai Be, Tien Giang',
    ),
    PlaceModel(
      id: 4,
      image: Images.tgicon,
      title: 'Cai Be Floating Market',
      location: 'Cai Be, Tien Giang',
    ),
    PlaceModel(
      id: 5,
      image: Images.tgicon,
      title: 'Cai Be Floating Market',
      location: 'Cai Be, Tien Giang',
    ),
    PlaceModel(
      id: 6,
      image: Images.tgicon,
      title: 'Cai Be Floating Market',
      location: 'Cai Be, Tien Giang',
    ),
  ];

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

  String getTimeNow() {
    final now = DateTime.now();
    final hour = now.hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  void onClickViewMore() {
    Get.toNamed(AppRoutes.detailLocation);
  }
}
