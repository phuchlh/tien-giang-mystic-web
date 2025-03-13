import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/page_model.dart';
import 'modules/explore_screen/map_screen_page.dart';
import 'modules/home_screen/home_screen_page.dart';
import 'modules/profile_screen/profile_screen_page.dart';

class MainController extends GetxController {
  MainController();

  List<PageModel> tabTitles = [
    PageModel.home(shouldShowAppBar: false),
    PageModel.explorer(),
    PageModel.profile(),
  ];

  List<Widget> tabPages = [
    HomeScreenPage(),
    MapScreenPage(),
    ProfileScreenPage(),
  ];

  late final currentPage = tabTitles[1].obs;
  late final currentIndex = 1.obs;

  void changePage(int index) {
    currentPage.value = tabTitles[index];
    currentIndex.value = index;
  }
}
