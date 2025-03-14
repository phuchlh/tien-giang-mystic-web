import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:tien_giang_mystic/modules/map_screen/map_screen_controller.dart';
import 'package:tien_giang_mystic/utils/responsive.dart';

class PanelInformation extends GetView<MapScreenController> {
  const PanelInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Get.find<Responsive>();
    return GetBuilder<MapScreenController>(
      builder: (controller) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: res.spacing(0), vertical: res.spacing(0.03)),
        child: Obx(
          () {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.placeDetail.value.placeName ?? '',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.theme.colorScheme.scrim,
                  ),
                ),
                SizedBox(
                  height: res.height * 0.01,
                ),
                Text(
                  "Giá vé: ${controller.placeDetail.value.ticket ?? ''}",
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  controller.placeDetail.value.placeLabel ?? '',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  controller.placeDetail.value.openCloseHour ?? '',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(
                  height: res.height * 0.01,
                ),
                TabBar(
                  tabs: controller.tabsData,
                  controller: controller.tabController,
                ),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: controller.tabViews,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
