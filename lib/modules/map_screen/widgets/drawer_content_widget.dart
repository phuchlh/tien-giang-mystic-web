import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:tien_giang_mystic/models/place_model.dart';
import 'package:tien_giang_mystic/utils/enum.dart';

import '../../../utils/gap.dart';
import '../../auth/auth_controller.dart';
import '../map_screen_controller.dart';

class DrawerContentWidget extends GetView<MapScreenController> {
  final String title;
  final EDrawerTypeButton typeDisplay;

  const DrawerContentWidget(
      {super.key, required this.title, required this.typeDisplay});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final authController = Get.find<AuthController>();
      final isExpanded = authController.isDrawerExpanded.value;

      return Positioned(
        top: 10,
        left: isExpanded ? k200 : k100,
        child: Container(
            decoration: BoxDecoration(
              color: context.theme.cardColor,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            width: Get.width * 0.25,
            height: Get.height * 0.45,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildPanelContent(
                typeDisplay,
                title,
              ),
            )),
      );
    });
  }

  Widget _buildPanelContent(EDrawerTypeButton typeDisplay, String title) {
    switch (typeDisplay) {
      case EDrawerTypeButton.HOLD:
        return const SizedBox.shrink();
      case EDrawerTypeButton.PLACE:
        return _PlaceBookmarkWidget(title: title);
      case EDrawerTypeButton.TOUR:
        return _TourBookmarkWidget(title: title);
    }
  }
}

class _TitleWidget extends GetView<MapScreenController> {
  final String title;
  const _TitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _PlaceBookmarkWidget extends GetView<MapScreenController> {
  final String title;
  const _PlaceBookmarkWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final listBookmark = controller.listDetailPlaceBookmark;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleWidget(title: title),
          Gap(k10),
          Expanded(
            child: ListView.builder(
              itemCount: listBookmark.length,
              itemBuilder: (_, index) {
                final place = listBookmark[index];
                return _PlaceBookmarkItem(place: place);
              },
            ),
          ),
        ],
      );
    });
  }
}

class _PlaceBookmarkItem extends GetView<MapScreenController> {
  final PlaceModel place;
  const _PlaceBookmarkItem({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              place.placeName ?? '',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    place.address ?? '',
                    style: context.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  place.openCloseHour ?? '',
                  style: context.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.confirmation_number,
                    size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  place.ticket ?? '',
                  style: context.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              place.visitTime ?? '',
              style:
                  context.textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _TourBookmarkWidget extends GetView<MapScreenController> {
  final String title;
  const _TourBookmarkWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleWidget(title: title),
        Gap(k10),
        Text("123123123123213123123"),
        Text("123123123123213123123"),
        Text("123123123123213123123"),
        Text("123123123123213123123"),
      ],
    );
  }
}
