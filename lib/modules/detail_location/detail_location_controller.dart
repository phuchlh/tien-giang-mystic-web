import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailLocationController extends GetxController {
  static DetailLocationController get to => Get.find();

  var isTitleVisible = false.obs;
  late ScrollController scrollController;

  @override
  void onInit() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset > 200) {
        isTitleVisible.value = true;
      } else {
        isTitleVisible.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
