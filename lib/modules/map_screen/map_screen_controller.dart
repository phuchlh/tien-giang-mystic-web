// ignore_for_file: no_leading_underscores_for_local_identifiers, constant_identifier_names, unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tien_giang_mystic/components/confirm_dialog.dart';
import 'package:tien_giang_mystic/models/bookmark_place_model.dart';
import 'package:tien_giang_mystic/models/bookmark_tour_model.dart';
import 'package:tien_giang_mystic/models/label_model.dart';
import 'package:tien_giang_mystic/models/place_response_model.dart';
import 'package:tien_giang_mystic/utils/app_logger.dart';
import 'package:uuid/uuid.dart';

import '../../models/news_model.dart';
import '../../models/place_model.dart';
import '../../models/response_message_model.dart';
import '../../modules/auth/auth_controller.dart';
import '../../service/env_services.dart';
import '../../service/n8n_service.dart';
import '../../service/serper_service.dart';
import '../../service/session_service.dart';
import '../../service/supabase_service.dart';
import '../../utils/constant.dart';
import '../../utils/enum.dart';

class MapScreenController extends GetxController
    with GetSingleTickerProviderStateMixin, GetTickerProviderStateMixin {
  // Storage keys for temporary data
  static const String TEMP_CHAT_RESPONSE_KEY = 'temp_chat_response';
  static const String TEMP_CHAT_ID_KEY = 'temp_chat_id';
  static const String TEMP_GENERATED_PLACES_KEY = 'temp_generated_places';

  final aiClient = SupabaseService().getAIClient();
  final businessClient = SupabaseService().getBusinessClient();
  final AuthController authController = Get.find<AuthController>();

  // controllers
  final MapController mapController = MapController();
  final PanelController panelController = PanelController();
  final ScrollController scrollController = ScrollController();
  late TabController tabController;

  html.AudioElement? _audioPlayer;

  // observables
  final List<PlaceModel> listPlace = <PlaceModel>[].obs;
  final List<PlaceModel> listFilter = <PlaceModel>[].obs;
  final RxList<BookmarkPlace> listPlaceBookmarked = <BookmarkPlace>[].obs;
  final Rx<PlaceModel> placeDetail = PlaceModel().obs;
  late Rx<SlidingStatus> slidingStatus;
  late Rx<DataLoadingStatus> dataLoadingStatus;
  late Rx<GetImageStatus> getImageStatus;
  List<String> listImages = <String>[].obs;
  List<News> listSearch = <News>[].obs;
  Rx<bool> isShowTextfield = false.obs;
  List<PlaceModel> listPlaceGenerated = <PlaceModel>[].obs;
  final Rx<EPlaceGeneratedStatus> placeGeneratedStatus =
      EPlaceGeneratedStatus.HOLD.obs;
  final RxBool isShowPlaceCard = true.obs;
  final RxBool isShowDescription = true.obs;
  final Rx<EPlayType> playType = EPlayType.INIT.obs;
  final RxList<LabelModel> labels = <LabelModel>[].obs;
  final Rx<LabelModel> selectedLabel = LabelModel().obs;
  final List<PlaceModel> listDetailPlaceBookmark = <PlaceModel>[].obs;
  final List<BookmarkTourModel> listTourBookmark = <BookmarkTourModel>[].obs;
  final Rx<EStatusTourBookmark> statusTourBookmark =
      EStatusTourBookmark.HOLD.obs;
  final Rx<EStatusPlaceBookmark> statusPlaceBookmark =
      EStatusPlaceBookmark.HOLD.obs;

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

  final String OPEN_AI_API_KEY = Env.openAIAPIKey;

  final _serperService = SerperService();

  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxBool isProcessing = false.obs;
  Rx<String> chatID = ''.obs;

  RxList<Map<String, dynamic>> listMsgs = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;

  final RxBool isMinimized = false.obs;

  final TextEditingController searchController = TextEditingController();
  Rx<String> messageGenerated = "".obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocationData();
    _initLabelStream();
    getLabel();
    slidingStatus = SlidingStatus.hide.obs;
    tabController = TabController(length: 3, vsync: this);
    dataLoadingStatus = DataLoadingStatus.pending.obs;
    getImageStatus = GetImageStatus.pending.obs;

    // Check for stored data on init
    _checkStoredData();

    // React to auth state changes
    ever(authController.user, (user) async {
      if (user != null) {
        await onLoginSuccess();
      }
    });
    getBookmarkPlace();
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
    promptController.dispose();
    searchController.dispose();
  }

  Future<void> getLabel() async {
    try {
      final response = await aiClient.from('labels').select('*');

      if (response.isNotEmpty) {
        labels.assignAll(response.map((e) => LabelModel.fromJson(e)).toList());
      } else {
        labels.clear();
      }

      if (response.isNotEmpty) {
        labels.assignAll(response.map((e) => LabelModel.fromJson(e)).toList());
      } else {
        labels.clear();
      }
    } catch (e) {
      AppLogger.error('Error fetching labels: $e');
    }
  }

  void _initLabelStream() {
    aiClient
        .channel('public:labels')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'labels',
          callback: (payload) {
            final eventType = payload.eventType;
            final record = payload.newRecord;

            switch (eventType) {
              case PostgresChangeEvent.insert:
                labels.add(LabelModel.fromJson(record));
                break;
              case PostgresChangeEvent.update:
                final updated = LabelModel.fromJson(record);
                if (updated.isActive == true) {
                  labels.add(updated);
                } else {
                  labels.removeWhere((label) => label.id == updated.id);
                }
                break;
              case PostgresChangeEvent.delete:
                final deletedId = payload.oldRecord['id'];
                labels.removeWhere((label) => label.id == deletedId);
                break;
              default:
                break;
            }
          },
        )
        .subscribe();
  }

  void onSelectLabel(LabelModel label) {
    if (label.id == selectedLabel.value.id) {
      placeGeneratedStatus.value = EPlaceGeneratedStatus.HOLD;
      selectedLabel.value = LabelModel();
      return;
    } else {
      placeGeneratedStatus.value = EPlaceGeneratedStatus.FILTERED;

      final labelText = (label.labelName ?? "").toLowerCase();
      final filteredList = listPlace.where((place) {
        final placeLabel = place.placeLabel ?? "";
        final splitLabels = onSplitPlaceLabel(placeLabel);

        return splitLabels.any(
          (item) => item.toLowerCase().contains(labelText),
        );
      }).toList();

      listFilter.assignAll(filteredList);
      selectedLabel.value = label;
    }
  }

  Future<void> getBookmarkPlace() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        AppLogger.error('User not logged in');
        return;
      }

      final response = await businessClient
          .from('saved_locations')
          .select()
          .eq('user_id', user.id);

      if (response.isNotEmpty) {
        listPlaceBookmarked
            .assignAll(response.map((e) => BookmarkPlace.fromJson(e)).toList());
      } else {
        listPlaceBookmarked.clear();
      }
    } catch (e) {
      AppLogger.error('Error fetching bookmark place: $e');
    }
  }

  bool isOnBookmarkList(String placeID) {
    return listPlaceBookmarked.any((place) => place.locationId == placeID);
  }

  void togglePlaceCard() => isShowPlaceCard.value = !isShowPlaceCard.value;
  void toggleDescription() =>
      isShowDescription.value = !isShowDescription.value;

  void onClickButton(EButtonClickType type) {
    if (type == EButtonClickType.NEXT) {
      scrollController.animateTo(
        scrollController.offset + Get.width * 0.3,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (type == EButtonClickType.BACK) {
      scrollController.animateTo(
        scrollController.offset - Get.width * 0.3,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
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
    final List locationData = await aiClient.from('place_destination').select(
        'id, place_name, latitude, longitude, place_image_folder, place_label');
    if (locationData.isNotEmpty) {
      listPlace
          .assignAll(locationData.map((e) => PlaceModel.fromJson(e)).toList());
    }
  }

  Future<void> loadSpecificLocationData(PlaceModel pm) async {
    dataLoadingStatus.value = DataLoadingStatus.loading;
    getImageStatus.value = GetImageStatus.loading;

    final List singleLocation =
        await aiClient.from('place_destination').select().eq('id', pm.id ?? 0);
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
      AppLogger.error('Error fetching news: $e');
    }
  }

  Future<List<String>> getImagesFromFolder(
      String bucketName, String folderPath) async {
    try {
      final response =
          await aiClient.storage.from(bucketName).list(path: folderPath);

      if (response.isEmpty) {
        getImageStatus.value = GetImageStatus.loaded;
        return [];
      } else {
        final projectURL = Env.aiURL;

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

  void addUserInput() async {
    try {
      final userInput = promptController.text.trim();
      if (userInput.isEmpty) {
        isShowTextfield.value = true;
        return;
      }

      final ssID = await SessionService.getOrCreateSessionId();
      final chatId = Uuid().v4();
      isShowTextfield.value = false;
      isProcessing.value = true;

      messages.add({
        'text': userInput,
        'isUser': true,
      });
      promptController.clear();

      var data = {
        'chatInput': userInput,
        'sessionID': ssID,
        'chatID': chatId,
      };

      try {
        final response =
            await N8NService.postWithToken(EN8NWebhookType.PROD, data, "token");
        Logger().i('Webhook response: ${response.data}');
        if (response.statusCode == 200) {
          isProcessing.value = false;
          final responseData = ResponseMessage.fromJson(response.data);
          listPlaceGenerated = await getDataGenerated(chatId);
          final chatResponse = responseData.data ?? "Không có dữ liệu trả về";
          messageGenerated.value = chatResponse;

          // Save temporary data for non-logged in users
          await saveTemporaryData(
            chatResponse: chatResponse,
            chatId: chatId,
          );

          messages.add({
            'text': chatResponse,
            'isUser': false,
          });
        } else {
          _handleError('Webhook failed with status: ${response.statusCode}');
        }
      } on DioException catch (e) {
        String errorMessage;
        if (e.type == DioExceptionType.connectionError) {
          errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra internet.';
        } else if (e.type == DioExceptionType.connectionTimeout) {
          errorMessage = 'Hết thời gian kết nối. Vui lòng thử lại.';
        } else {
          errorMessage = 'Lỗi không xác định: ${e.message}';
        }
        _handleError(errorMessage);
        Logger().e('DioException: $e');
      }
    } catch (e) {
      Logger().e('Error in addUserInput: $e');
      _handleError('Có lỗi xảy ra khi xử lý yêu cầu của bạn');
    }
  }

  Future<List<PlaceModel>> getDataGenerated(String chatID) async {
    try {
      final response = await aiClient
          .from('message_filter_place')
          .select()
          .eq('chat_id', chatID);

      if (response.isNotEmpty) {
        final placeData = PlaceResponse.fromJson(response.first);
        if (placeData.listData != null) {
          placeGeneratedStatus.value = EPlaceGeneratedStatus.GENERATED;
          isLoading.value = false;

          final _listDataGenerated = placeData.listData ?? [];

          await saveTemporaryData(generatedPlaces: _listDataGenerated);

          return _listDataGenerated;
        }
      }
      return [];
    } catch (e) {
      Logger().e('Error in getDataGenerated: $e');
    }
    return [];
  }

  // Check and restore stored data on app init
  Future<void> _checkStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasStoredData = prefs.containsKey(TEMP_GENERATED_PLACES_KEY);

      if (hasStoredData) {
        isShowTextfield.value = false;

        final tempData = await getTemporaryData();

        // Restore generated places if available
        if (tempData['generatedPlaces'] != null) {
          final places = tempData['generatedPlaces'] as List<PlaceModel>;
          listPlaceGenerated = places;
          placeGeneratedStatus.value = EPlaceGeneratedStatus.GENERATED;
          Logger().i('Restored generated places from storage');
        }

        // Restore chat response if available
        if (tempData['chatResponse'] != null) {
          messageGenerated.value = tempData['chatResponse'];
          messages.add({
            'text': tempData['chatResponse'],
            'isUser': false,
          });
          Logger().i('Restored chat response from storage');
        }

        // Clear storage if user is already logged in
        if (authController.isAuthenticated) {
          await clearTemporaryData();
          Logger().i('Cleared temporary storage as user is authenticated');
        }
      } else {
        isShowTextfield.value = true;
      }
    } catch (e) {
      Logger().e('Error checking stored data: $e');
    }
  }

  // Handle successful login
  Future<void> onLoginSuccess() async {
    try {
      final tempData = await getTemporaryData();

      // Restore generated places if available
      if (tempData['generatedPlaces'] != null) {
        final places = tempData['generatedPlaces'] as List<PlaceModel>;
        listPlaceGenerated = places;
        placeGeneratedStatus.value = EPlaceGeneratedStatus.GENERATED;
        Logger().i('Restored generated places after login');
      }

      // Restore chat response if available
      if (tempData['chatResponse'] != null) {
        messageGenerated.value = tempData['chatResponse'];
        // Prevent duplicate messages
        if (!messages.any((m) => m['text'] == tempData['chatResponse'])) {
          messages.add({
            'text': tempData['chatResponse'],
            'isUser': false,
          });
        }
        Logger().i('Restored chat response after login');
      }

      // Clear temporary storage after successful restoration
      await clearTemporaryData();
      Logger().i('Cleared temporary storage after login restoration');
    } catch (e) {
      Logger().e('Error handling login success: $e');
    }
  }

  // Save temporary data for non-logged in users
  Future<void> saveTemporaryData({
    String? chatResponse,
    String? chatId,
    List<PlaceModel>? generatedPlaces,
  }) async {
    if (await isUserLoggedIn()) {
      Logger().i('User is logged in, skipping temporary storage');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      if (chatResponse != null && chatResponse.isNotEmpty) {
        await prefs.setString(TEMP_CHAT_RESPONSE_KEY, chatResponse);
        Logger().i('Saved chat response to temporary storage');
      }

      if (chatId != null && chatId.isNotEmpty) {
        await prefs.setString(TEMP_CHAT_ID_KEY, chatId);
        Logger().i('Saved chat ID to temporary storage');
      }

      if (generatedPlaces != null && generatedPlaces.isNotEmpty) {
        final placesJson =
            generatedPlaces.map((place) => place.toJson()).toList();
        await prefs.setString(
            TEMP_GENERATED_PLACES_KEY, json.encode(placesJson));
        Logger().i('Saved generated places to temporary storage');
      }
    } catch (e) {
      Logger().e('Error saving temporary data: $e');
    }
  }

  // Get stored temporary data
  Future<Map<String, dynamic>> getTemporaryData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final chatResponse = prefs.getString(TEMP_CHAT_RESPONSE_KEY);
      final chatId = prefs.getString(TEMP_CHAT_ID_KEY);
      final placesJson = prefs.getString(TEMP_GENERATED_PLACES_KEY);

      List<PlaceModel>? generatedPlaces;
      if (placesJson != null) {
        final List<dynamic> decodedPlaces = json.decode(placesJson);
        generatedPlaces =
            decodedPlaces.map((json) => PlaceModel.fromJson(json)).toList();
      }

      return {
        'chatResponse': chatResponse,
        'chatId': chatId,
        'generatedPlaces': generatedPlaces,
      };
    } catch (e) {
      Logger().e('Error getting temporary data: $e');
      return {};
    }
  }

  // Clear temporary storage
  Future<void> clearTemporaryData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(TEMP_CHAT_RESPONSE_KEY);
      await prefs.remove(TEMP_CHAT_ID_KEY);
      await prefs.remove(TEMP_GENERATED_PLACES_KEY);
      Logger().i('Cleared all temporary storage');
    } catch (e) {
      Logger().e('Error clearing temporary data: $e');
    }
  }

  // Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    return authController.isAuthenticated;
  }

  void _handleError(String errorMessage) {
    isShowTextfield.value = true;
    isProcessing.value = false;
    messages.add({
      'text': errorMessage,
      'isUser': false,
    });
  }

  void toggleMinimized() {
    isMinimized.value = !isMinimized.value;
  }

  void closeChat() {
    isShowTextfield.value = false;
    // Add any additional cleanup needed
  }

  void handleSearch(String value) {
    // Implement search logic here
    // For example:
    // searchLocations(value);
  }

  void clearSearch() {
    // Clear search results
    // Reset map or markers if needed
  }

  List<String> onSplitPlaceLabel(String placeLabel) {
    final List<String> splitPlaceLabel = placeLabel.split(',');
    if (splitPlaceLabel.length > 1) {
      return splitPlaceLabel;
    } else {
      return [placeLabel];
    }
  }

  Future<void> handleTTS(String text) async {
    try {
      switch (playType.value) {
        case EPlayType.INIT:
          playType.value = EPlayType.GENERATING;
          await generateTextToSpeech(text);
          break;

        case EPlayType.GENERATING:
          // Ignore, still loading
          break;

        case EPlayType.PLAY:
          _audioPlayer?.pause();
          playType.value = EPlayType.PAUSE;
          break;

        case EPlayType.PAUSE:
          _audioPlayer?.play();
          playType.value = EPlayType.PLAY;
          break;

        case EPlayType.STOP:
          _audioPlayer?.pause();
          _audioPlayer?.currentTime = 0;
          playType.value = EPlayType.INIT;
          break;
      }
    } catch (e) {
      print('handleTTS error: $e');
      playType.value = EPlayType.INIT;
    }
  }

  Future<void> generateTextToSpeech(String text) async {
    final String apiKey = Env.elevenLabKey;
    final String voiceId = 'xPEfmymXC4WdBxGMznS7';
    final String modelId = 'eleven_turbo_v2_5';

    final Uri url =
        Uri.parse('https://api.elevenlabs.io/v1/text-to-speech/$voiceId');

    final headers = {
      'xi-api-key': apiKey,
      'Content-Type': 'application/json',
      'Accept': 'audio/mpeg',
    };

    final body = jsonEncode({
      'text': text,
      'model_id': modelId,
      'voice_settings': {
        'stability': 0.5,
        'similarity_boost': 0.75,
        'speed': 0.9,
      },
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final blob = html.Blob([response.bodyBytes], 'audio/mpeg');
        final audioUrl = html.Url.createObjectUrlFromBlob(blob);

        // Dispose old player
        _audioPlayer?.pause();
        _audioPlayer?.remove();

        _audioPlayer = html.AudioElement()
          ..src = audioUrl
          ..autoplay = true;

        _audioPlayer!.onEnded.listen((event) {
          playType.value = EPlayType.STOP;
        });

        await _audioPlayer!.play();
        playType.value = EPlayType.PLAY;
      } else {
        print('TTS failed: ${response.statusCode} - ${response.body}');
        playType.value = EPlayType.INIT;
      }
    } catch (e) {
      print('TTS generation error: $e');
      playType.value = EPlayType.INIT;
    }
  }

  Future<void> onPostLikeTourGenerated() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      print('User: $user');
      if (user == null) {
        Get.dialog(
          ConfirmDialog(
            title: 'Thông báo',
            content: 'Bạn cần đăng nhập để thực hiện chức năng này',
            onConfirm: () {
              final authController = Get.find<AuthController>();
              authController.signInWithGoogle();
              Get.back();
            },
          ),
          barrierDismissible: false,
        );
        return;
      }
      final response = await businessClient.from("likes").insert({
        'user_id': user.id,
        'json_location': listPlaceGenerated.map((e) => e.toJson()).toList(),
        'created_at': DateTime.now().toIso8601String(),
      });
      if (response != null && response.error != null) {
        AppLogger.error(
            'Error posting like tour generated: ${response.error!.message}');
        Get.snackbar(
          'Error',
          'Failed to post like tour. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        AppLogger.debug('Like tour generated posted successfully');
        Get.snackbar(
          'Success',
          'Tour liked successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      AppLogger.error('Error posting like tour generated: $e');
    }
  }

  Future<void> onPostBookmarkPlace({
    required String locationID,
  }) async {
    try {
      final bookmarked = isOnBookmarkList(locationID);
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        Get.dialog(
          ConfirmDialog(
            title: 'Thông báo',
            content: 'Bạn cần đăng nhập để thực hiện chức năng này',
            onConfirm: () {
              final authController = Get.find<AuthController>();
              authController.signInWithGoogle();
              Get.back();
            },
          ),
          barrierDismissible: false,
        );
      }
      if (!bookmarked) {
        final response = await businessClient.from("saved_locations").insert({
          'user_id': user?.id,
          'location_id': locationID,
        });
        if (response != null && response.error != null) {
          AppLogger.error(
              'Error posting bookmark place: ${response.error!.message}');
          Get.snackbar(
            'Error',
            'Failed to bookmark place. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          AppLogger.debug('Place bookmarked successfully');
          Get.snackbar(
            'Success',
            'Place bookmarked successfully!',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        getBookmarkPlace();
      } else {
        final response = await businessClient
            .from("saved_locations")
            .delete()
            .eq('user_id', user?.id ?? "")
            .eq('location_id', locationID);
        if (response != null && response.error != null) {
          print('Error deleting bookmark place: ${response.error!.message}');
        } else {
          listPlaceBookmarked
              .removeWhere((place) => place.locationId == locationID);
        }
      }
    } catch (e) {
      AppLogger.error('Error posting bookmark place: $e');
    }
  }

  void clearGeneratedPlaces() {
    listPlaceGenerated.clear();
    placeGeneratedStatus.value = EPlaceGeneratedStatus.HOLD;
    messageGenerated.value = "";
    isShowTextfield.value = true;
    isProcessing.value = false;
    chatID.value = '';
    promptController.clear();
    // clear local tour
    clearTemporaryData();
  }

  Future<void> onGetBookmarkPlace() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        AppLogger.error('User not logged in');
        return;
      }
      statusPlaceBookmark.value = EStatusPlaceBookmark.LOADING;

      final listPlace = await businessClient
          .from('saved_locations')
          .select('created_at, locations (*)')
          .eq('user_id', user.id);

      if (listPlace.isNotEmpty) {
        statusPlaceBookmark.value = EStatusPlaceBookmark.SUCCESS;
        listDetailPlaceBookmark.assignAll(
            listPlace.map((e) => PlaceModel.fromJson(e['locations'])).toList());
      } else if (listPlace.isEmpty) {
        statusPlaceBookmark.value = EStatusPlaceBookmark.EMPTY;
        AppLogger.info("No bookmark place found");
      }
    } catch (e) {
      AppLogger.error('Error fetching bookmark place: $e');
      statusPlaceBookmark.value = EStatusPlaceBookmark.ERROR;
    }
  }

  Future<void> onGetBookmarkTour() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        AppLogger.error('User not logged in');
        return;
      }
      statusTourBookmark.value = EStatusTourBookmark.LOADING;
      final listTour = await businessClient
          .from('likes')
          .select('json_location')
          .eq('user_id', user.id);

      if (listTour.isNotEmpty) {
        statusTourBookmark.value = EStatusTourBookmark.SUCCESS;
        listTourBookmark.assignAll(
            listTour.map((e) => BookmarkTourModel.fromJson(e)).toList());
      } else if (listPlace.isEmpty) {
        statusTourBookmark.value = EStatusTourBookmark.EMPTY;
      }
    } catch (e) {
      statusTourBookmark.value = EStatusTourBookmark.ERROR;
    }
  }

  String joinPlaceName(List<PlaceModel> places) {
    return places.map((place) => place.placeName).join(' - ');
  }
}
