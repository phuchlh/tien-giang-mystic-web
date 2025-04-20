import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'widget/button_widget.dart';

class AuthController extends GetxController {
  final _googleSignIn = GoogleSignIn();
  final _isAuthenticated = false.obs;
  final _isLoading = false.obs;
  final RxBool isOpenMenu = false.obs;
  final Rxn<GoogleSignInAccount> _user = Rxn<GoogleSignInAccount>();

  bool get isAuthenticated => _isAuthenticated.value;
  bool get isLoading => _isLoading.value;
  GoogleSignInAccount? get user => _user.value;

  @override
  void onInit() {
    super.onInit();
    _checkCurrentUser();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      _user.value = account;
      _isAuthenticated.value = account != null;
    });
  }

  void toggle() {
    if (_isAuthenticated.value) {
      isOpenMenu.value = !isOpenMenu.value;
    } else {
      // do signin with google
    }
  }

  void close() => isOpenMenu.value = false;

  final List<ButtonWidget> buttonWithoutLogin = [
    ButtonWidget(
      text: 'Đăng nhập',
      icon: Icons.login,
      onPressed: () {},
    ),
  ];

  final List<ButtonWidget> buttonWithLogin = [
    ButtonWidget(
      text: 'Đăng xuất',
      icon: Icons.logout,
      onPressed: () {},
    ),
  ];

  Future<void> _checkCurrentUser() async {
    _isLoading.value = true;
    try {
      _user.value = await _googleSignIn.signInSilently();
      _isAuthenticated.value = _user.value != null;
    } catch (error) {
      print('Check current user error: $error');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signIn() async {
    if (_isLoading.value) return;

    _isLoading.value = true;
    try {
      final account = await _googleSignIn.signIn();
      _user.value = account;
      _isAuthenticated.value = account != null;
    } catch (error) {
      print('Sign in error: $error');
      Get.snackbar(
        'Error',
        'Failed to sign in with Google',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    if (_isLoading.value) return;

    _isLoading.value = true;
    try {
      await _googleSignIn.signOut();
      _user.value = null;
      _isAuthenticated.value = false;
    } catch (error) {
      print('Sign out error: $error');
      Get.snackbar(
        'Error',
        'Failed to sign out',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
