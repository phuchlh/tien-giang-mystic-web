import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:latlong2/latlong.dart';
import 'package:tien_giang_mystic/models/place_model.dart';
import 'package:tien_giang_mystic/modules/map_screen/widgets/dialog_detail.dart';
import 'package:tien_giang_mystic/utils/constant.dart';
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
              color: Color(0xFFf1f3f5),
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
      default:
        return const SizedBox.shrink();
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
    return GestureDetector(
      onTap: () {
        controller.animatedMapMove(
          LatLng(
            place.latitude ?? Constant.TIEN_GIANG_LATITUDE,
            place.longitude ?? Constant.TIEN_GIANG_LONGITUDE,
          ),
          16.0,
        );
        controller.loadSpecificLocationData(place);
        showDialog(
          context: context,
          builder: (context) => DialogDetail(),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
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
              _RowText(
                icon: Iconify(
                  MaterialSymbols.location_on_outline_rounded,
                  color: context.theme.colorScheme.primary,
                  size: k24,
                ),
                content: place.address ?? '',
              ),
              const SizedBox(height: 6),
              _RowText(
                icon: Iconify(
                  MaterialSymbols.timer_outline_rounded,
                  color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                  size: k24,
                ),
                content: place.openCloseHour ?? '',
              ),
              const SizedBox(height: 6),
              _RowText(
                icon: Iconify(
                  MaterialSymbols.local_activity_outline_rounded,
                  color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                  size: k24,
                ),
                content: place.ticket ?? '',
              ),
              const SizedBox(height: 6),
              Text(
                place.visitTime ?? '',
                style: context.textTheme.bodySmall
                    ?.copyWith(color: Colors.black54),
              ),
            ],
          ),
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

class _RowText extends StatelessWidget {
  final Widget icon;
  final String content;
  const _RowText({
    super.key,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        Gap(k8),
        Expanded(
          child: Text(
            content,
            maxLines: 2,
            style:
                context.textTheme.bodyMedium?.copyWith(color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
