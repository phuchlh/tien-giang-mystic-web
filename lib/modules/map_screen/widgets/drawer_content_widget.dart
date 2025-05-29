import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:latlong2/latlong.dart';

import '../../../components/animated_status_widget.dart';
import '../../../models/bookmark_tour_model.dart';
import '../../../models/place_model.dart';
import '../../../utils/constant.dart';
import '../../../utils/enum.dart';
import '../../../utils/gap.dart';
import '../../../utils/images.dart';
import '../../auth/auth_controller.dart';
import '../map_screen_controller.dart';
import 'dialog_detail.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleWidget(title: title),
        Gap(k10),
        Expanded(
          child: Obx(() {
            final listBookmark = controller.listDetailPlaceBookmark;
            switch (controller.statusPlaceBookmark.value) {
              case EStatusPlaceBookmark.LOADING:
                return AnimatedStatusWidget(
                  animated: Images.loading,
                  message: 'Đang tải...',
                );
              case EStatusPlaceBookmark.ERROR:
                return AnimatedStatusWidget(
                  animated: Images.noData,
                  message: 'Đã xảy ra lỗi, vui lòng thử lại',
                );
              case EStatusPlaceBookmark.EMPTY:
                return AnimatedStatusWidget(
                  animated: Images.noData,
                  message: 'Chưa có địa điểm nào được lưu',
                );
              case EStatusPlaceBookmark.SUCCESS:
                return ListView.builder(
                  itemCount: listBookmark.length,
                  itemBuilder: (_, index) {
                    final place = listBookmark[index];
                    return _PlaceBookmarkItem(place: place);
                  },
                );
              case EStatusPlaceBookmark.HOLD:
                return const Center(
                  child: Text('Vui lòng thử lại'),
                );
            }
          }),
        ),
      ],
    );
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
        Expanded(
          child: Obx(() {
            switch (controller.statusTourBookmark.value) {
              case EStatusTourBookmark.LOADING:
                return AnimatedStatusWidget(
                  animated: Images.loading,
                  message: 'Đang tải...',
                );
              case EStatusTourBookmark.ERROR:
                return AnimatedStatusWidget(
                  animated: Images.noData,
                  message: 'Đã xảy ra lỗi, vui lòng thử lại',
                );
              case EStatusTourBookmark.EMPTY:
                return AnimatedStatusWidget(
                  animated: Images.noData,
                  message: 'Chưa có địa điểm nào được lưu',
                );
              case EStatusTourBookmark.SUCCESS:
                return ListView.builder(
                  itemCount: controller.listTourBookmark.length,
                  itemBuilder: (_, index) {
                    final tour = controller.listTourBookmark[index];
                    return _TourBookmarkItem(place: tour);
                  },
                );
              case EStatusTourBookmark.HOLD:
                return const Center(
                  child: Text('Vui lòng thử lại'),
                );
            }
          }),
        ),
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

class _TourBookmarkItem extends GetView<MapScreenController> {
  final BookmarkTourModel place;
  const _TourBookmarkItem({super.key, required this.place});
  @override
  Widget build(BuildContext context) {
    final placeName = controller.joinPlaceName(place.jsonLocation ?? []);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              imageUrl: 'https://i.imgur.com/EC4eUSz.jpeg',
              width: k150,
              height: k150,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Gap(k10),
            Expanded(
              child: Column(
                children: [
                  Text(
                    placeName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconTextRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IconTextRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
