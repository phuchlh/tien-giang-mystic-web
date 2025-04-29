import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../../../utils/gap.dart';
import '../map_screen_controller.dart';

class PlaceDescription extends GetView<MapScreenController> {
  final ScrollController scrollController;
  const PlaceDescription({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapScreenController>(
      builder: (controller) => Obx(
        () {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: k24, vertical: k18),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Text(
                controller.placeDetail.value.description ?? "",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
