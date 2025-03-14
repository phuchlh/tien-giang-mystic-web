import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:tien_giang_mystic/modules/map_screen/map_screen_controller.dart';
import 'package:tien_giang_mystic/utils/responsive.dart';

class PlaceDescription extends GetView<MapScreenController> {
  const PlaceDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Get.find<Responsive>();
    return GetBuilder<MapScreenController>(
      builder: (controller) => Obx(
        () {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: res.spacing(0.03)),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: res.spacing(0.2), top: res.spacing(0.03)),
              controller: controller.scrollController,
              child: ReadMoreText(
                controller.placeDetail.value.description ?? "",
                trimLines: 3,
                colorClickableText: context.theme.primaryColor,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Xem thêm',
                trimExpandedText: 'Thu gọn',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 16.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
