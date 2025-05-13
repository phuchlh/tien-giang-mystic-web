import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/simple_line_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/drawer_model.dart';
import '../../models/user_metadata_model.dart';
import '../../service/session_service.dart';
import '../../service/supabase_service.dart';
import '../../service/web_storage.dart';
import '../../utils/app_logger.dart';
import '../../utils/enum.dart';

class AuthController extends GetxController {
  final _isAuthenticated = false.obs;
  final _isLoading = false.obs;
  final RxBool isOpenMenu = false.obs;
  final aiClient = SupabaseService().getAIClient();
  final businessClient = SupabaseService().getBusinessClient();

  bool get isAuthenticated => _isAuthenticated.value;
  bool get isLoading => _isLoading.value;

  var isDrawerExpanded = false.obs;
  final Rxn<UserMetaModel> user = Rxn<UserMetaModel>();

  late List<DrawerModel> drawerItems;
  // final RxString selectedDrawerItem = ''.obs;
  final Rx<EDrawerTypeButton> selectedDrawerItem = EDrawerTypeButton.HOLD.obs;
  final Rx<DrawerModel> selectedDrawerItemModel = DrawerModel(
    typeButton: EDrawerTypeButton.HOLD,
    title: '',
    icon: '',
    isExpanded: false,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    // onCheckSession();
    drawerItems = [
      DrawerModel(
        typeButton: EDrawerTypeButton.PLACE,
        title: 'Địa điểm',
        icon: MaterialSymbols.location_on_outline_rounded,
        isExpanded: isDrawerExpanded.value,
      ),
      DrawerModel(
        typeButton: EDrawerTypeButton.HOLD,
        title: '',
        icon: "",
        isExpanded: isDrawerExpanded.value,
      ),
      DrawerModel(
        typeButton: EDrawerTypeButton.TOUR,
        title: 'Chuyến đi',
        icon: MaterialSymbols.route_outline,
        isExpanded: isDrawerExpanded.value,
      ),
      DrawerModel(
        typeButton: EDrawerTypeButton.HOLD,
        title: '',
        icon: "",
        isExpanded: isDrawerExpanded.value,
      ),
      DrawerModel(
        typeButton: EDrawerTypeButton.LOGOUT,
        title: 'Đăng xuất',
        icon: SimpleLineIcons.logout,
        isExpanded: isDrawerExpanded.value,
      ),
    ];
    businessClient.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      if (event == AuthChangeEvent.signedIn) {
        onCheckSession();
      } else if (event == AuthChangeEvent.signedOut) {
        user.value = null;
        _isAuthenticated.value = false;
      } else if (data.session?.user != null) {
        onCheckSession();
      }
    });
  }

  void toggleDrawer() {
    isDrawerExpanded.value = !isDrawerExpanded.value;
  }

  void onDrawerItemTap(EDrawerTypeButton type) {
    if (type == EDrawerTypeButton.HOLD) return;

    selectedDrawerItem.value =
        (selectedDrawerItem.value == type) ? EDrawerTypeButton.HOLD : type;
    selectedDrawerItemModel.value =
        drawerItems.firstWhere((item) => item.typeButton == type,
            orElse: () => DrawerModel(
                  typeButton: EDrawerTypeButton.HOLD,
                  title: '',
                  icon: '',
                  isExpanded: false,
                ));
  }

  void onCheckSession() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      user.value = UserMetaModel.fromMap(session.user.userMetadata ?? {});
      _isAuthenticated.value = true;
      await WebStorage.write("sessionToken", session.accessToken);
      await WebStorage.write("refreshToken", session.refreshToken ?? "");
    } else {}
  }

  Future<void> postSessionID() async {
    try {
      final ssID = await SessionService.getOrCreateSessionId();

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final response =
          await Supabase.instance.client.from('user_session').insert({
        'session_id': ssID,
        'user_id': user.id, // 🟢 Correct UUID from Supabase auth
        'created_at': DateTime.now().toIso8601String(),
      });

      if (response != null && response.error != null) {
        AppLogger.error('Error posting session ID: ${response.error!.message}');
        Get.snackbar(
          'Error',
          'Failed to post session ID. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        AppLogger.debug('Session ID posted successfully');
      }
    } catch (e) {
      AppLogger.error('Error posting session ID: $e');
      Get.snackbar(
        'Error',
        'Failed to post session ID. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void toggle() {
    if (_isAuthenticated.value) {
      isOpenMenu.value = !isOpenMenu.value;
    } else {
      signInWithGoogle();
    }
  }

  void close() => isOpenMenu.value = false;

  Future<void> signInWithGoogle() async {
    _isLoading.value = true;
    try {
      AppLogger.debug('Starting Google sign-in...');
      final response = await businessClient.auth.signInWithOAuth(
        OAuthProvider.google,
        // redirectTo: kIsWeb ? null : 'http://localhost:3000',
        authScreenLaunchMode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );

      if (!response) {
        AppLogger.error('Failed to start Google sign-in flow');
        _isLoading.value = false;
        Get.snackbar(
          'Error',
          'Failed to start Google sign-in',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error) {
      AppLogger.error('Google sign-in error: $error');
      _isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to sign in with Google. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> signOut() async {
    try {
      user.value = null;
      _isAuthenticated.value = false;
      _isLoading.value = false;
      await WebStorage.delete("sessionToken");
      await WebStorage.delete("refreshToken");
      await businessClient.auth.signOut();
    } catch (error) {
      AppLogger.error('Sign out error: $error');
      Get.snackbar(
        'Error',
        'Failed to sign out. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
