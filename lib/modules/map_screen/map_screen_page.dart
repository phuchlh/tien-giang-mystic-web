import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tien_giang_mystic/modules/map_screen/widgets/panel_widget.dart';
import 'package:tien_giang_mystic/utils/constant.dart';
import 'package:tien_giang_mystic/utils/responsive.dart';

import 'map_screen_controller.dart';

class MapScreenPage extends GetView<MapScreenController> {
  const MapScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Get.find<Responsive>();
    return GetBuilder<MapScreenController>(
      builder: (controller) => SizedBox(
        child: SlidingUpPanel(
          controller: controller.panelController,
          maxHeight: res.height * 0.7,
          minHeight: res.height * 0.2,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          parallaxEnabled: true,
          parallaxOffset: 0.5,
          panelBuilder: (scrollController) {
            controller.scrollController ??= scrollController;
            return PanelWidget();
          },
          body: FlutterMap(
            mapController: controller.mapController,
            options: MapOptions(
                initialCenter: controller.initialPosition,
                initialZoom: 16.0,
                maxZoom: 100.0,
                minZoom: 10.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                ),
                onTap: (tapPosition, point) {
                  print("Tapped: $point");
                },
                cameraConstraint: CameraConstraint.containCenter(
                    bounds:
                        LatLngBounds.fromPoints(controller.tienGiangBoundary))),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 40,
                    height: 40,
                    point: controller.initialPosition,
                    child: Icon(Icons.location_pin, color: Colors.red),
                  ),
                ],
              ),
              if (controller.listPlace != [])
                Obx(() {
                  if (controller.listPlace.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return MarkerLayer(
                    markers: controller.listPlace
                        .map((e) => Marker(
                              width: 40,
                              height: 40,
                              point: LatLng(
                                e.latitude ?? Constant.TIEN_GIANG_LATITUDE,
                                e.longitude ?? Constant.TIEN_GIANG_LONGITUDE,
                              ),
                              child: IconButton(
                                onPressed: () => {
                                  controller.animatedMapMove(
                                      LatLng(
                                          e.latitude ??
                                              Constant.TIEN_GIANG_LATITUDE,
                                          e.longitude ??
                                              Constant.TIEN_GIANG_LONGITUDE),
                                      16.0),
                                  print("Tapped: ${e.placeName}"),
                                  controller
                                      .loadSpecificLocationData(e.id ?? ""),
                                },
                                icon: Icon(
                                  Icons.location_pin,
                                  color: Colors.blue,
                                  size: res.width * 0.05,
                                ),
                              ),
                            ))
                        .toList(),
                  );
                })
            ],
          ),
        ),
      ),
    );
  }
}
