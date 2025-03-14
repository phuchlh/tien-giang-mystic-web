import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tien_giang_mystic/modules/map_screen/map_screen_controller.dart';
import 'package:tien_giang_mystic/modules/map_screen/widgets/panel_information.dart';
import 'package:tien_giang_mystic/utils/responsive.dart';

class PanelWidget extends GetView<MapScreenController> {
  const PanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Get.find<Responsive>();
    return GetBuilder<MapScreenController>(
      builder: (controller) => Column(
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
          Expanded(child: PanelInformation()),
        ],
      ),
    );
  }
}
