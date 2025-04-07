import 'package:get/get.dart';

import '../modules/detail_location/detail_location_binding.dart';
import '../modules/detail_location/detail_location_page.dart';
import '../modules/map_screen/map_screen_binding.dart';
import '../modules/map_screen/map_screen_page.dart';
import '../modules/profile_screen/profile_screen_binding.dart';
import '../modules/profile_screen/profile_screen_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.chat,
      page: () => MapScreenPage(),
      binding: MapScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreenPage(),
      binding: ProfileScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.detailLocation,
      page: () => DetailLocationPage(),
      binding: DetailLocationBinding(),
    )
  ];
}
