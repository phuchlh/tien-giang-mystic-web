import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:tien_giang_mystic/modules/map_screen/widgets/dialog_detail.dart';

import '../../components/chip_widget.dart';
import '../../components/confirm_dialog.dart';
import '../../models/place_model.dart';
import '../../utils/constant.dart';
import '../../utils/enum.dart';
import '../../utils/gap.dart';
import '../../utils/images.dart';
import '../auth/auth_controller.dart';
import '../auth/auth_widget.dart';
import 'map_screen_controller.dart';
import 'widgets/drawer_content_widget.dart';
import 'widgets/panel_information.dart';

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
                _InfoPlacePanel(),
                _ChipLabel(),
                Obx(() {
                  final authController = Get.find<AuthController>();
                  final isClicked = authController.selectedDrawerItem.value;

                  return isClicked == EDrawerTypeButton.HOLD
                      ? const SizedBox.shrink()
                      : DrawerContentWidget(
                          title: authController
                              .selectedDrawerItemModel.value.title,
                          typeDisplay: authController
                              .selectedDrawerItemModel.value.typeButton,
                        );
                }),
                Obx(() {
                  if (controller.isProcessing.value) {
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

class _ChipLabel extends GetView<MapScreenController> {
  const _ChipLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final labels = controller.labels;

      final isSelected = controller.selectedLabel.value;

      if (labels.isEmpty) {
        return const Text('No labels available');
      }

      return Positioned(
        top: 20,
        left: 0,
        right: 0,
        child: Align(
          alignment: Alignment.center,
          child: Wrap(
            spacing: 8.0,
            children: labels.map((label) {
              if (label.isActive == false) {
                return const SizedBox.shrink();
              }

              return ActionChip(
                onPressed: () => controller.onSelectLabel(label),
                label: Text(label.labelName ?? ""),
                backgroundColor: isSelected.id == label.id
                    ? context.theme.primaryColor.withAlpha(100).withBlue(250)
                    : context.theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected.id == label.id
                        ? Colors.transparent
                        : Colors.grey,
                    width: 0.2,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    });
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
    return Obx(() {
      if (controller.placeGeneratedStatus.value != EPlaceGenerated.GENERATED) {
        return const SizedBox.shrink();
      }

      return Positioned(
        bottom: 10,
        left: -10,
        right: -10,
        child: Obx(
          () {
            return Container(
              child: AnimatedSize(
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
                            tooltip:
                                controller.isShowPlaceCard.value ? "Ẩn" : "Mở",
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
                    controller.isShowPlaceCard.value
                        ? Row(
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
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class _InfoPlacePanel extends GetView<MapScreenController> {
  const _InfoPlacePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.placeGeneratedStatus.value !=
            EPlaceGenerated.GENERATED) {
          return const SizedBox.shrink();
        }
        return Positioned(
          right: 0,
          top: 40,
          child: Obx(() {
            return SizedBox(
              height: Get.height * 0.5,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topRight,
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.theme.cardColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              tooltip: controller.isShowDescription.value
                                  ? "Ẩn"
                                  : "Mở",
                              onPressed: () {
                                controller.toggleDescription();
                              },
                              icon: Icon(controller.isShowDescription.value
                                  ? Icons.keyboard_arrow_right
                                  : Icons.keyboard_arrow_left),
                              color: context.iconColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.theme.cardColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Obx(() {
                              final state = controller.playType.value;
                              String iconName;
                              switch (state) {
                                case EPlayType.PLAY:
                                  iconName = Ph.pause_circle_light;
                                  break;
                                case EPlayType.PAUSE:
                                  iconName = Ph.play_circle_light;
                                  break;
                                case EPlayType.GENERATING:
                                  iconName = Ph.spinner_light;
                                  break;
                                case EPlayType.STOP:
                                case EPlayType.INIT:
                                default:
                                  iconName = Ph.speaker_high_light;
                                  break;
                              }

                              return IconButton(
                                onPressed: () {
                                  controller.handleTTS(
                                      controller.messageGenerated.value);
                                },
                                icon: Iconify(iconName),
                                color: context.iconColor,
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    controller.isShowDescription.value
                        ? _MarkdownContainer()
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
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
                    builder: (context) => DialogDetail(),
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

class _MarkdownContainer extends GetView<MapScreenController> {
  const _MarkdownContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      height: Get.height * 0.5,
      width: Get.width * 0.35,
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
                  styleSheet: MarkdownStyleSheet(
                    h1: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.onSecondaryFixed,
                    ),
                    p: TextStyle(
                      fontSize: 16,
                      color: context.theme.colorScheme.onSecondaryFixed,
                    ),
                    a: TextStyle(
                      color: context.theme.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
