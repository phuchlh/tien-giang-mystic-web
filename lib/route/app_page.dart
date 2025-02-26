import 'package:get/get.dart';
import 'package:tien_giang_mystic/modules/chat_screen/chat_screen_binding.dart';
import 'package:tien_giang_mystic/modules/chat_screen/chat_screen_page.dart';
import 'package:tien_giang_mystic/modules/home_screen/home_screen_binding.dart';
import 'package:tien_giang_mystic/modules/home_screen/home_screen_page.dart';
import 'package:tien_giang_mystic/modules/login_screen/login_screen_binding.dart';
import 'package:tien_giang_mystic/modules/login_screen/login_screen_page.dart';
import 'package:tien_giang_mystic/modules/profile_screen/profile_screen_binding.dart';
import 'package:tien_giang_mystic/modules/profile_screen/profile_screen_page.dart';
import 'package:tien_giang_mystic/route/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreenPage(),
      binding: HomeScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => ChatScreenPage(),
      binding: ChatScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreenPage(),
      binding: ProfileScreenBinding(),
    ),
  ];
}
