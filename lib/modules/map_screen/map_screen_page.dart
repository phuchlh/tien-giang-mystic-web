import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:tien_giang_mystic/models/place_model.dart';

import '../../utils/constant.dart';
import '../../utils/enum.dart';
import '../../utils/gap.dart';
import '../../utils/images.dart';
import 'map_screen_controller.dart';
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
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 40,
                            height: 40,
                            point: controller.initialPosition,
                            child: const Icon(Icons.location_pin,
                                color: Colors.red),
                          ),
                        ],
                      ),
                      Obx(() {
                        if (controller.listPlace.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return MarkerLayer(
                          markers: controller.listPlace
                              .map(
                                (e) => Marker(
                                  width: k50,
                                  height: k50,
                                  point: LatLng(
                                    e.latitude ?? Constant.TIEN_GIANG_LATITUDE,
                                    e.longitude ??
                                        Constant.TIEN_GIANG_LONGITUDE,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.animatedMapMove(
                                        LatLng(
                                          e.latitude ??
                                              Constant.TIEN_GIANG_LATITUDE,
                                          e.longitude ??
                                              Constant.TIEN_GIANG_LONGITUDE,
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
                              .toList(),
                        );
                      }),
                    ],
                  ),
                ),

                // check isShowTextfield to show or hide the textfield

                Obx(() {
                  if (controller.isShowTextfield.value) {
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
                                  hintText:
                                      "Bạn muốn khám phá những đâu tại Tiền Giang...",
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
                                onSubmitted: (value) {
                                  controller.addUserInput();
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: context.theme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  controller.addUserInput();
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),

                Obx(() {
                  switch (controller.placeGeneratedStatus.value) {
                    case EPlaceGenerated.HOLD:
                      return SizedBox.shrink();
                    case EPlaceGenerated.GENERATED:
                      return Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Container(
                          height: Get.height * 0.5,
                          padding: const EdgeInsets.all(8),
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
                            behavior: ScrollConfiguration.of(context).copyWith(
                              dragDevices: {
                                PointerDeviceKind.touch,
                                PointerDeviceKind.mouse, // Enable mouse drag
                              },
                              scrollbars: true, // Hiển thị thanh cuộn
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.listPlaceGenerated.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: Get.width * 0.3,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: _PlaceCard(
                                      placeItem:
                                          controller.listPlaceGenerated[index]),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                  }
                }),

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
            Text(placeItem.placeName ?? "",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: listLabel.map((e) {
                return Chip(
                  label: Text(e),
                  labelStyle: TextStyle(
                    color: context.theme.colorScheme.onSecondaryFixed,
                  ),
                  backgroundColor:
                      context.theme.colorScheme.inversePrimary.withAlpha(100),
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: context.theme.colorScheme.inversePrimary
                          .withAlpha(100), // Đổi sang màu bạn muốn
                      width: 1.5,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 8),
            Text("📍 ${placeItem.address}",
                style: TextStyle(color: Colors.grey[700])),
            Text("🕒 Open: ${placeItem.openCloseHour}",
                style: TextStyle(color: Colors.grey[700])),
            Text("⏱️ Visit Time: ${placeItem.visitTime}",
                style: TextStyle(color: Colors.grey[700])),
            Text("📞 ${placeItem.phoneNumber}",
                style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.remove_red_eye, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text('${placeItem.viewNumber}'),
                SizedBox(width: 16),
                Icon(Icons.favorite_border, size: 16, color: Colors.redAccent),
                SizedBox(width: 4),
                Text('${placeItem.likeNumber}'),
              ],
            ),
            Gap(k8),
            // display placeItem.description and make sure it is within the limits of the card
            Text(
              placeItem.description ?? "",
              maxLines: 9,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
