import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tien_giang_mystic/themes/colors_theme.dart';
import 'package:tien_giang_mystic/utils/images.dart';

import 'main_binding.dart';
import 'main_controller.dart';
import 'modules/chat_screen/chat_screen_page.dart';
import 'modules/home_screen/home_screen_page.dart';
import 'modules/profile_screen/profile_screen_page.dart';
import 'route/app_page.dart';
import 'utils/responsive.dart';

Future<void> main() async {
  // await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tien Giang Mystic',
      getPages: AppPages.pages,
      // home: MainScreen(),
      initialBinding: MainBinding(),
      home: Builder(
        builder: (context) {
          Get.put(Responsive(context), permanent: true);
          return MainScreen();
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  final MainController controller = Get.put(MainController());
  final responsive = Get.find<Responsive>();
  final PersistentTabController _tabController =
      PersistentTabController(initialIndex: 0);

  MainScreen({super.key});

  List<Widget> _buildScreens() {
    return [
      HomeScreenPage(),
      ChatScreenPage(),
      ProfileScreenPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: ImageIcon(
          AssetImage(Images.menuUnactive),
        ),
        activeColorPrimary: ThemeColor.blue1,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(
          AssetImage(Images.chatUnactive),
        ),
        activeColorPrimary: ThemeColor.blue1,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(
          AssetImage(Images.profileUnactive),
        ),
        activeColorPrimary: ThemeColor.blue1,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _tabController,
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarStyle: NavBarStyle.style3,
      navBarHeight: responsive.width * 0.14,
    );
  }
}
