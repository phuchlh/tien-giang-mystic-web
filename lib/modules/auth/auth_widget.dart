import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../utils/gap.dart';
import '../../utils/images.dart';
import 'auth_controller.dart';

class AuthWidget extends GetView<AuthController> {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(() {
              if (controller.isLoading) {
                return const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }
              return Row(
                children: [
                  GreetingWidget(isLogin: controller.isAuthenticated),
                ],
              );
            }),
          ),
          Gap(k8),
          AuthButton(),
        ],
      ),
    );
  }
}

class AuthButton extends GetView<AuthController> {
  const AuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoggedIn = controller.isAuthenticated;

      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: GestureDetector(
            onTap:
                isLoggedIn ? controller.signOut : controller.signInWithGoogle,
            child: Row(
              children: [
                Icon(isLoggedIn ? Icons.logout : Icons.login),
                Gap(k8),
                Text(
                  isLoggedIn ? "Đăng xuất" : "Đăng nhập ngay",
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class GreetingWidget extends GetView<AuthController> {
  final bool isLogin;
  const GreetingWidget({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        isLogin
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: controller.user.value?.picture ?? "",
                  width: k32,
                  height: k32,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => FirstNameAvatar(
                      firstName: controller.user.value?.fullName ?? ""),
                ),
              )
            : Image.asset(
                Images.tgicon,
                width: k32,
                height: k32,
              ),
        Gap(k8),
        Text(
          isLogin
              ? "Xin chào ${controller.user.value?.fullName ?? ""} "
              : 'Chào mừng đến với Tiền Giang Mystic',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class FirstNameAvatar extends StatelessWidget {
  final String firstName;
  const FirstNameAvatar({super.key, required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: k32,
      height: k32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.theme.primaryColor,
      ),
      child: Center(
        child: Text(
          firstName.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) =>
      oldDelegate.color != color;
}
