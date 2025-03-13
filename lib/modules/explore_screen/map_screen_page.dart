import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'map_screen_controller.dart';

class MapScreenPage extends GetView<MapScreenController> {
  const MapScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapScreenController>(
      builder: (controller) => Scaffold(
        body: Center(
          child: Container(
            child: Text("Explorer"),
          ),
        ),
      ),
    );
  }
}
