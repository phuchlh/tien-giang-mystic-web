import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart' as lottie;

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
            floatingActionButton: FloatingActionButton(
              onPressed: () => controller.showExploreDialog(context),
              child: const Icon(Icons.chat_bubble_outline),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            body: SizedBox(
              child: FlutterMap(
                mapController: controller.mapController,
                options: MapOptions(
                  initialCenter: controller.initialPosition,
                  initialZoom: 12.0,
                  maxZoom: 100.0,
                  minZoom: 10.0,
                  cameraConstraint: CameraConstraint.containCenter(
                    bounds:
                        LatLngBounds.fromPoints(controller.tienGiangBoundary),
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
                        child:
                            const Icon(Icons.location_pin, color: Colors.red),
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
                                e.longitude ?? Constant.TIEN_GIANG_LONGITUDE,
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
