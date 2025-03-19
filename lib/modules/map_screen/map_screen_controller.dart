import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/news_model.dart';
import '../../models/place_model.dart';
import '../../service/serper_service.dart';
import '../../utils/constant.dart';
import '../../utils/enum.dart';
import 'widgets/explore_widget.dart';

class MapScreenController extends GetxController
    with GetSingleTickerProviderStateMixin, GetTickerProviderStateMixin {
  // static final SupabaseController supabaseController =
  //     Get.find<SupabaseController>();
  // static final SupabaseClient supabaseAI = supabaseController.tgMysticAI;
  final supabase = Supabase.instance.client;

  // controllers
  final MapController mapController = MapController();
  final PanelController panelController = PanelController();
  ScrollController? scrollController;
  late TabController tabController;
  // final AuthController authController = Get.find<AuthController>();

  // observables
  final List<PlaceModel> listPlace = <PlaceModel>[].obs;
  final Rx<PlaceModel> placeDetail = PlaceModel().obs;
  late Rx<SlidingStatus> slidingStatus;
  late Rx<DataLoadingStatus> dataLoadingStatus;
  late Rx<GetImageStatus> getImageStatus;
  List<String> listImages = <String>[].obs;
  List<News> listSearch = <News>[].obs;

  final TextEditingController promptController = TextEditingController();
  final RxList<String> suggestions = <String>[].obs;

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
    Tab(text: "Hình ảnh"),
    Tab(text: "Tin tức"),
  ];

  final _serperService = SerperService();

  @override
  void onInit() {
    super.onInit();
    _loadLocationData();
    slidingStatus = SlidingStatus.hide.obs;
    tabController = TabController(length: 3, vsync: this);
    dataLoadingStatus = DataLoadingStatus.pending.obs;
    getImageStatus = GetImageStatus.pending.obs;
    // authController.signInAsGuest();
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
        .select('id, place_name, latitude, longitude, place_image_folder');
    if (locationData.isNotEmpty) {
      listPlace
          .assignAll(locationData.map((e) => PlaceModel.fromJson(e)).toList());
    }
  }

  Future<void> loadSpecificLocationData(PlaceModel pm) async {
    dataLoadingStatus.value = DataLoadingStatus.loading;
    getImageStatus.value = GetImageStatus.loading;

    final List singleLocation =
        await supabase.from('place_destination').select().eq('id', pm.id ?? 0);
    if (singleLocation.isNotEmpty) {
      placeDetail.value = PlaceModel.fromJson(singleLocation.first);
      dataLoadingStatus.value = DataLoadingStatus.loaded;
      listImages =
          await getImagesFromFolder('place_image', pm.placeImageFolder ?? "");
      await getNewsFromSerper(pm.placeName ?? "");
    } else {
      dataLoadingStatus.value = DataLoadingStatus.error;
    }
  }

  Future<void> getNewsFromSerper(String location) async {
    try {
      final response =
          await _serperService.fetchSearch('địa điểm $location ở Tiền Giang');
      if (response.isNotEmpty) {
        listSearch.assignAll(response);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<List<String>> getImagesFromFolder(
      String bucketName, String folderPath) async {
    try {
      final response =
          await supabase.storage.from(bucketName).list(path: folderPath);

      if (response.isEmpty) {
        getImageStatus.value = GetImageStatus.loaded;
        return [];
      } else {
        final projectURL = dotenv.env['SUPABASE_URL_TIEN_GIANG_MYSTIC'];

        final List<String> listImgs = response
            .where((item) =>
                item.name.endsWith(".jpg") ||
                item.name.endsWith(".jpeg") ||
                item.name.endsWith(".png") ||
                item.name.endsWith(".webp"))
            .map((item) =>
                "$projectURL/storage/v1/object/public/$bucketName/$folderPath/${item.name}")
            .toList();

        getImageStatus.value = GetImageStatus.loaded;

        return listImgs;
      }
    } catch (e) {
      print("Error: $e");
      getImageStatus.value = GetImageStatus.error;
      return [];
    }
  }

  void showImage(int index) {
    Get.dialog(
      Dialog(
        child: Image.network(
          listImages[index],
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void showExploreDialog() {
    Get.dialog(
      Dialog(
        child: ExploreWidget(),
      ),
    );
  }

  void generateSuggestions() {
    String prompt = promptController.text.trim();
    if (prompt.isNotEmpty) {
      suggestions.assignAll([
        "$prompt - Đề xuất 1",
        "$prompt - Đề xuất 2",
        "$prompt - Đề xuất 3",
        "$prompt - Đề xuất 4",
      ]);
    }
  }
}
