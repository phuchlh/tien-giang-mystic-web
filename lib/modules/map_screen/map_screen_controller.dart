import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tien_giang_mystic/models/place_model.dart';
import 'package:tien_giang_mystic/modules/map_screen/widgets/place_description.dart';
import 'package:tien_giang_mystic/utils/enum.dart';

import '../../utils/constant.dart';

class MapScreenController extends GetxController
    with GetSingleTickerProviderStateMixin, GetTickerProviderStateMixin {
  final supabase = Supabase.instance.client;

  // controllers
  final MapController mapController = MapController();
  final PanelController panelController = PanelController();
  ScrollController? scrollController;
  late TabController tabController;

  // observables
  final List<PlaceModel> listPlace = <PlaceModel>[].obs;
  final Rx<PlaceModel> placeDetail = PlaceModel().obs;
  late Rx<SlidingStatus> slidingStatus;

  final LatLng initialPosition =
      LatLng(Constant.TIEN_GIANG_LATITUDE, Constant.TIEN_GIANG_LONGITUDE);

  final List<LatLng> tienGiangBoundary = [
    LatLng(10.2056, 105.8186), // Góc dưới trái
    LatLng(10.5906, 105.8186),
    LatLng(10.5906, 106.8017), // Góc trên phải
    LatLng(10.2056, 106.8017),
    LatLng(10.2056, 105.8186), // Đóng khung lại đường biên
  ];

  final List<int> arrDumb = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  final List<Tab> tabsData = [
    Tab(text: "Thông tin"),
    Tab(text: "Đánh giá"),
    Tab(text: "Hình ảnh"),
  ];

  final List<Widget> tabViews = [
    PlaceDescription(),
    Text("Đánh giá"),
    Text("Hình ảnh"),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadLocationData();
    slidingStatus = SlidingStatus.hide.obs;
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }

  void animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: mapController.camera.center.latitude,
        end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.camera.center.longitude,
        end: destLocation.longitude);
    final zoomTween =
        Tween<double>(begin: mapController.camera.zoom, end: destZoom);

    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void togglePanel() => panelController.isPanelOpen
      ? panelController.close()
      : panelController.open();

  Future<void> _loadLocationData() async {
    final List locationData = await supabase
        .from('place_destination')
        .select('id, place_name, latitude, longitude');
    if (locationData.isNotEmpty) {
      listPlace
          .assignAll(locationData.map((e) => PlaceModel.fromJson(e)).toList());
    }
  }

  Future<void> loadSpecificLocationData(String id) async {
    final List singleLocation =
        await supabase.from('place_destination').select().eq('id', id);
    if (singleLocation.isNotEmpty) {
      placeDetail.value = PlaceModel.fromJson(singleLocation.first);
      if (panelController.isPanelClosed) {
        togglePanel();
      }
    }
  }
}
