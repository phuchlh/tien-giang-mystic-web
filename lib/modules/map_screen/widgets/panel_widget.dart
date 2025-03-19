import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/enum.dart';
import '../../../utils/responsive.dart';
import '../map_screen_controller.dart';
import 'panel_information.dart';

class PanelWidget extends GetView<MapScreenController> {
  final ScrollController scrollController;
  const PanelWidget({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final res = Get.find<Responsive>();
    return GetBuilder<MapScreenController>(
      builder: (controller) {
        return Column(
          children: [
            SizedBox(
              height: res.height * 0.01,
            ),
            Center(
              child: GestureDetector(
                onTap: controller.togglePanel,
                child: Container(
                  width: res.width * 0.1,
                  height: res.height * 0.01,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.slidingStatus.value ==
                    SlidingStatus.showDetail) {
                  return PanelInformation(
                    scrollController: scrollController,
                  );
                } else if (controller.slidingStatus.value ==
                    SlidingStatus.showCommon) {
                  return Container(
                    child: Center(
                      child: Text("Common"),
                    ),
                  );
                }
                return Container(
                  child: Center(
                    child: Text("Default"),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
