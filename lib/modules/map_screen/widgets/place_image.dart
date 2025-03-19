import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/enum.dart';
import '../../../utils/gap.dart';
import '../../../utils/images.dart';
import '../map_screen_controller.dart';

class PlaceImage extends StatelessWidget {
  final ScrollController scrollController;
  const PlaceImage({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final MapScreenController controller = Get.find<MapScreenController>();

    return Obx(() {
      if (controller.getImageStatus.value == GetImageStatus.loading) {
        return Center(
          child: Lottie.asset(
            Images.loading,
            width: k50 * 4.5,
            height: k50 * 4.5,
          ),
        );
      }

      if (controller.getImageStatus.value == GetImageStatus.error) {
        return Center(child: Text("Lỗi khi tải hình ảnh"));
      }

      if (controller.listImages.isEmpty) {
        return Column(children: [
          LottieBuilder.asset(
            Images.noData,
            width: k50 * 4.5,
            height: k50 * 4.5,
          ),
          Gap(k4),
          Text(
            "Địa điểm chưa cập nhật hình ảnh",
            style: context.textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
        ]);
      }

      return SizedBox(
        height: 50,
        child: GridView.count(
          padding: const EdgeInsets.all(k12),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: controller.listImages
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    controller.showImage(controller.listImages.indexOf(e));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      e,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    });
  }
}
