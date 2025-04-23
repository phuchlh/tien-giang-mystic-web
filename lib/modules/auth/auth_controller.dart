import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tien_giang_mystic/service/web_storage.dart';

import '../../models/user_metadata_model.dart';
import '../../service/supabase_service.dart';
import '../../utils/app_logger.dart';

class AuthController extends GetxController {
  final _isAuthenticated = false.obs;
  final _isLoading = false.obs;
  final RxBool isOpenMenu = false.obs;
  final aiClient = SupabaseService().getAIClient();
  final businessClient = SupabaseService().getBusinessClient();

  bool get isAuthenticated => _isAuthenticated.value;
  bool get isLoading => _isLoading.value;
  final Rxn<UserMetaModel> user = Rxn<UserMetaModel>();

  @override
  void onInit() {
    super.onInit();
    // onCheckSession();
    print("onInit");
    businessClient.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        onCheckSession();
        print("User signed in");
      } else if (event == AuthChangeEvent.signedOut) {
        user.value = null;
        _isAuthenticated.value = false;
        print("User signed out");
      }
      print("Auth state changed: $event");
    });
  }

  void onCheckSession() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      user.value = UserMetaModel.fromMap(session.user.userMetadata ?? {});

      _isAuthenticated.value = true;
      await WebStorage.write("sessionToken", session.accessToken);
      await WebStorage.write("refreshToken", session.refreshToken ?? "");
    } else {
      print('No session found');
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
        redirectTo: kIsWeb ? null : 'http://localhost:3000',
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
