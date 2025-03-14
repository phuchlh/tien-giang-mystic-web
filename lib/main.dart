import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'main_binding.dart';
import 'main_controller.dart';
import 'route/app_page.dart';
import 'themes/theme.dart';
import 'utils/responsive.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  final String urlSupabase = dotenv.env['SUPABASE_URL_TIEN_GIANG_MYSTIC']!;
  final String anonKey = dotenv.env['ANON_KEY_TIEN_GIANG_MYSTIC']!;

  await Supabase.initialize(
    url: urlSupabase,
    anonKey: anonKey,
  );
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
      theme: MaterialTheme(TextTheme()).light(),
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

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _MainAppBar(),
      extendBody: true,
      body: Obx(() {
        return controller.tabPages[controller.currentIndex.value];
      }),
      bottomNavigationBar: Obx(() {
        return CurvedNavigationBar(
          index: controller.currentIndex.value,
          backgroundColor: Colors.transparent,
          color: context.theme.colorScheme.inversePrimary,
          buttonBackgroundColor: context.theme.colorScheme.inversePrimary,
          height: responsive.width * 0.14,
          items: controller.tabTitles.map((e) {
            return e.icon;
          }).toList(),
          onTap: controller.changePage,
        );
      }),
    );

    //  PersistentTabView(
    //   context,
    //   controller: _tabController,
    //   onItemSelected: controller.changePage,
    //   screens: [
    //     const ChatScreenPage(),
    //     const HomeScreenPage(),
    //     const ProfileScreenPage(),
    //   ],
    //   items: controller.tabTitles.map((e) {
    //     return PersistentBottomNavBarItem(
    //       icon: e.icon,
    //       title: e.title,
    //       activeColorPrimary: context.theme.colorScheme.primary,
    //       inactiveColorPrimary: Colors.grey,
    //     );
    //   }).toList(),
    //   backgroundColor: Colors.white,
    //   handleAndroidBackButtonPress: true,
    //   resizeToAvoidBottomInset: true,
    //   stateManagement: true,
    //   navBarStyle: NavBarStyle.style1,
    //   navBarHeight: responsive.width * 0.14,
    // ),
  }
}

class _MainAppBar extends GetView<MainController>
    implements PreferredSizeWidget {
  const _MainAppBar();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.currentPage.value.shouldShowAppBar) {
        return const SizedBox.shrink();
      }
      return AppBar(
        title: Text(controller.currentPage.value.pageTitle),
      );
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
