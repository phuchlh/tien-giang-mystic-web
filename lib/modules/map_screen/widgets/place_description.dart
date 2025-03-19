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
            padding: EdgeInsets.symmetric(horizontal: k14, vertical: k10),
            child: SingleChildScrollView(
              controller: scrollController,
              child: ReadMoreText(
                controller.placeDetail.value.description ?? "",
                trimLines: 5,
                colorClickableText: context.theme.primaryColor,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Xem thêm',
                trimExpandedText: 'Thu gọn',
                style: TextStyle(
                  fontSize: 16,
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
