import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/page_model.dart';
import 'modules/map_screen/map_screen_page.dart';
import 'modules/profile_screen/profile_screen_page.dart';

class MainController extends GetxController {
  MainController();

  List<PageModel> tabTitles = [
    PageModel.explorer(shouldShowAppBar: false),
    PageModel.profile(),
  ];

  List<Widget> tabPages = [
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
