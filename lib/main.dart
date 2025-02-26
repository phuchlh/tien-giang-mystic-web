import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tien_giang_mystic/main_binding.dart';
import 'package:tien_giang_mystic/main_controller.dart';
import 'package:tien_giang_mystic/modules/chat_screen/chat_screen_page.dart';
import 'package:tien_giang_mystic/modules/home_screen/home_screen_page.dart';
import 'package:tien_giang_mystic/modules/login_screen/login_screen_binding.dart';
import 'package:tien_giang_mystic/modules/login_screen/login_screen_page.dart';
import 'package:tien_giang_mystic/modules/profile_screen/profile_screen_page.dart';
import 'package:tien_giang_mystic/route/app_page.dart';
import 'package:tien_giang_mystic/route/app_routes.dart';
import 'package:tien_giang_mystic/themes/colors_theme.dart';
import 'package:tien_giang_mystic/utils/responsive.dart';

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
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.chat),
        title: ("Chat"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: Colors.blue,
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
    );
  }
}
