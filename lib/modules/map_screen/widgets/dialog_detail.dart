import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tien_giang_mystic/modules/map_screen/map_screen_controller.dart';
import 'package:tien_giang_mystic/modules/map_screen/widgets/panel_information.dart';
import 'package:tien_giang_mystic/utils/enum.dart';
import 'package:tien_giang_mystic/utils/gap.dart';
import 'package:tien_giang_mystic/utils/images.dart';

import 'package:lottie/lottie.dart' as lottie;

class DialogDetail extends GetView<MapScreenController> {
  const DialogDetail({super.key});

  @override
  Widget build(Object context) {
    return GetBuilder<MapScreenController>(
      builder: (controller) {
        return Obx(() {
          if (controller.dataLoadingStatus.value == DataLoadingStatus.loading) {
            return Center(
              child: lottie.Lottie.asset(
                Images.loading,
                width: k50 * 4.5,
                height: k50 * 4.5,
              ),
            );
          }

          if (controller.dataLoadingStatus.value == DataLoadingStatus.error) {
            return const Center(
              child: Text("Error"),
            );
          }

          final scrollController = ScrollController();

          return Dialog(
            child: SizedBox(
              height: Get.height * 0.7,
              width: Get.height * 0.7,
              child: PanelInformation(
                scrollController: scrollController,
              ),
            ),
          );
        });
      },
    );
  }
}
