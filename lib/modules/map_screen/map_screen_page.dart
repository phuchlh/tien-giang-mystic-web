import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart' as lottie;

import '../../components/confirm_dialog.dart';
import '../../models/place_model.dart';
import '../../utils/constant.dart';
import '../../utils/enum.dart';
import '../../utils/gap.dart';
import '../../utils/images.dart';
import '../auth/auth_controller.dart';
import '../auth/auth_widget.dart';
import 'map_screen_controller.dart';
import 'widgets/panel_information.dart';
import '../../components/chip_widget.dart';

class MapScreenPage extends GetView<MapScreenController> {
  const MapScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GetBuilder<MapScreenController>(
          builder: (controller) => Scaffold(
            extendBody: true,
            body: Stack(
              children: [
                SizedBox(
                  child: FlutterMap(
                    mapController: controller.mapController,
                    options: MapOptions(
                      initialCenter: controller.initialPosition,
                      initialZoom: 12.0,
                      maxZoom: 100.0,
                      minZoom: 10.0,
                      cameraConstraint: CameraConstraint.containCenter(
                        bounds: LatLngBounds.fromPoints(
                            controller.tienGiangBoundary),
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      Obx(() {
                        if (controller.listPlace.isEmpty) {
                          return const SizedBox.shrink();
                        } else {
                          return _MarkerPlace();
                        }
                      }),
                    ],
                  ),
                ),
                AuthWidget(),
                _SearchTextField(),
                _PlaceCardPanel(),
                Obx(() {
                  if (controller.isProcessing.value) {
                    // show loading with lottie and black background
                    return Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: lottie.Lottie.asset(
                          Images.loading,
                          width: k50 * 4.5,
                          height: k50 * 4.5,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                })
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchTextField extends GetView<MapScreenController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isShowTextfield.value) return const SizedBox.shrink();

      return Positioned(
        bottom: 30,
        left: 300,
        right: 300,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.promptController,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Bạn muốn khám phá những đâu tại Tiền Giang...",
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => controller.addUserInput(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  onPressed: controller.addUserInput,
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _PlaceCardPanel extends GetView<MapScreenController> {
  @override
  Widget build(BuildContext context) {
    final authControl = Get.find<AuthController>();
    return Obx(() {
      if (controller.placeGeneratedStatus.value != EPlaceGenerated.GENERATED) {
        return const SizedBox.shrink();
      }

      return Stack(
        children: [
          Positioned(
              bottom: 10,
              left: -10,
              right: -10,
              child: Obx(
                () {
                  return AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: context.theme.cardColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                tooltip: controller.isShowPlaceCard.value
                                    ? "Ẩn"
                                    : "Mở",
                                onPressed: () {
                                  controller.togglePlaceCard();
                                },
                                icon: Icon(controller.isShowPlaceCard.value
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up),
                                color: context.iconColor,
                              ),
                            ),
                            Gap(k8),
                            Container(
                              decoration: BoxDecoration(
                                color: context.theme.cardColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                tooltip: "Thích",
                                onPressed: controller.onPostLikeTourGenerated,
                                icon: Icon(Icons.favorite_border),
                                color: context.iconColor,
                              ),
                            ),
                            Gap(k8),
                            Container(
                              decoration: BoxDecoration(
                                color: context.theme.cardColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                tooltip: "Đóng",
                                onPressed: () {
                                  Get.dialog(
                                    ConfirmDialog(
                                      title: 'Thông báo',
                                      content: 'Bạn muốn hủy tour này?',
                                      onConfirm: () {
                                        // Perform your close logic here
                                        controller.clearGeneratedPlaces();
                                      },
                                      onCancel: () {},
                                    ),
                                    barrierDismissible: false,
                                  );
                                },
                                icon: Icon(Icons.close),
                                color: context.iconColor,
                              ),
                            ),
                          ],
                        ),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              // 🧾 Scrollable Container
                              Expanded(
                                child: Container(
                                  height: Get.height * 0.268,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(context)
                                        .copyWith(
                                      dragDevices: {
                                        PointerDeviceKind.touch,
                                        PointerDeviceKind.mouse,
                                      },
                                      scrollbars: true,
                                    ),
                                    child: ListView.builder(
                                      controller: controller.scrollController,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          controller.listPlaceGenerated.length,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          width: Get.width * 0.25,
                                          child: _PlaceCard(
                                            placeItem: controller
                                                .listPlaceGenerated[index],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
          Positioned(
              top: 60,
              right: 20,
              child: SizedBox(
                width: k50,
                height: k50,
                child: SpeedDial(
                  direction: SpeedDialDirection.down,
                  icon: Icons.settings,
                  activeIcon: Icons.close,
                  backgroundColor: context.theme.primaryColor,
                  foregroundColor: context.theme.colorScheme.onPrimary,
                  overlayColor: context.theme.colorScheme.onPrimary,
                  overlayOpacity: 0.3,
                  childrenButtonSize: const Size(50, 50),
                  children: [
                    SpeedDialChild(
                      label: "Thuyết minh",
                      child: Iconify(Ph.speaker_high_light),
                      onTap: () {
                        controller.generateTextToSpeech(
                            controller.messageGenerated.value);
                      },
                    ),
                    SpeedDialChild(
                      label: "Đọc nội dung",
                      child: Iconify(Ph.book_open_light),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => _MarkdownDialog(),
                        );
                      },
                    ),
                  ],
                ),
              )),
        ],
      );
    });
  }
}

class _ButtonSlide extends GetView<MapScreenController> {
  final EButtonClickType type;
  const _ButtonSlide({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final icon = type == EButtonClickType.NEXT
        ? Icons.arrow_forward_ios
        : Icons.arrow_back_ios_new;
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: context.iconColor),
        onPressed: () => {
          controller.onClickButton(type),
        },
      ),
    );
  }
}

class _DialogDetail extends GetView<MapScreenController> {
  @override
  Widget build(Object context) {
    return GetBuilder<MapScreenController>(
      builder: (controller) {
        return Obx(() {
          if (controller.dataLoadingStatus.value == DataLoadingStatus.loading) {
            return Center(
              child: lottie.Lottie.asset(
                Images.loading,
                width: k50 * 4.5,
                height: k50 * 4.5,
              ),
            );
          }

          if (controller.dataLoadingStatus.value == DataLoadingStatus.error) {
            return const Center(
              child: Text("Error"),
            );
          }

          final scrollController = ScrollController();

          return Dialog(
            child: SizedBox(
              height: Get.height * 0.7,
              width: Get.height * 0.7,
              child: PanelInformation(
                scrollController: scrollController,
              ),
            ),
          );
        });
      },
    );
  }
}

class _PlaceCard extends GetView<MapScreenController> {
  final PlaceModel placeItem;
  const _PlaceCard({required this.placeItem});

  @override
  Widget build(BuildContext context) {
    final listLabel = controller.onSplitPlaceLabel(
      placeItem.placeLabel ?? "",
    );
    return Card(
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip(
                  message: placeItem.placeName ?? "",
                  child: Text(
                    placeItem.placeName ?? "",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 8),
                ChipWidget(listLabel: listLabel),
              ],
            ),
            Gap(k20),
            _TitleWidget(
              content: placeItem.address ?? "Chưa cập nhật",
              prefixIcon: "📍",
            ),
            _TitleWidget(
              content: placeItem.openCloseHour ?? "Chưa cập nhật",
              prefixIcon: "🕒",
            ),
            _TitleWidget(
              content: placeItem.visitTime ?? "Chưa cập nhật",
              prefixIcon: "🕒",
            ),
            _TitleWidget(
              content: placeItem.phoneNumber ?? "Chưa cập nhật",
              prefixIcon: "📞",
            ),
            Gap(k8),
            Row(
              children: [
                Icon(Icons.remove_red_eye, size: 16, color: Colors.grey),
                Gap(k4),
                Text('${placeItem.viewNumber}'),
                Gap(k16),
                Icon(Icons.favorite_border, size: 16, color: Colors.redAccent),
                Gap(k4),
                Text('${placeItem.likeNumber}'),
              ],
            ),
            Gap(k8),
          ],
        ),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  final String content;
  final String prefixIcon;
  const _TitleWidget(
      {super.key, required this.content, required this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Text(
      "$prefixIcon $content",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.theme.colorScheme.onSecondaryFixed,
      ),
    );
  }
}

class _MarkerPlace extends GetView<MapScreenController> {
  const _MarkerPlace({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<PlaceModel> places =
          controller.placeGeneratedStatus.value == EPlaceGenerated.GENERATED
              ? controller.listPlaceGenerated
              : controller.listPlace;

      final markers = places
          .where((e) => e.latitude != null && e.longitude != null)
          .map(
            (e) => Marker(
              width: k50,
              height: k50,
              point: LatLng(
                e.latitude ?? Constant.TIEN_GIANG_LATITUDE,
                e.longitude ?? Constant.TIEN_GIANG_LONGITUDE,
              ),
              child: GestureDetector(
                onTap: () {
                  controller.animatedMapMove(
                    LatLng(
                      e.latitude ?? Constant.TIEN_GIANG_LATITUDE,
                      e.longitude ?? Constant.TIEN_GIANG_LONGITUDE,
                    ),
                    16.0,
                  );
                  controller.loadSpecificLocationData(e);
                  showDialog(
                    context: context,
                    builder: (context) => _DialogDetail(),
                  );
                },
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.blue,
                ),
              ),
            ),
          )
          .toList();

      return MarkerLayer(markers: markers);
    });
  }
}

class _MarkdownDialog extends GetView<MapScreenController> {
  const _MarkdownDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Obx(
                  () => Markdown(
                    // copyable
                    selectable: true,
                    data: controller.messageGenerated.value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
