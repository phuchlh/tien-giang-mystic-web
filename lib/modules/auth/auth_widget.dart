import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../utils/gap.dart';
import 'auth_controller.dart';

class AuthWidget extends GetView<AuthController> {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: Container(
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
            return AuthButton(isLogin: false);
          }),
        ),
      ),
    );
  }
}

class AuthButton extends GetView<AuthController> {
  final bool isLogin;
  const AuthButton({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      clipBehavior: Clip.none,
      children: [
        // Nút chính (auth button)
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: controller.toggle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isLogin
                    ? Lottie.asset(
                        'assets/lottie/login.json',
                        height: 32,
                        width: 32,
                      )
                    : Icon(
                        Icons.person,
                        color: context.theme.dividerColor,
                        size: 32,
                      ),
                const SizedBox(width: 8),
                Text(
                  isLogin ? "Xin chào Phúc" : 'Đăng nhập ngay',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Dropdown menu
        Positioned(
          top: 48,
          left: 0,
          child: Obx(() {
            return AnimatedOpacity(
              opacity: controller.isOpenMenu.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: AnimatedScale(
                scale: controller.isOpenMenu.value ? 1.0 : 0.9,
                duration: const Duration(milliseconds: 250),
                child: Visibility(
                  visible: controller.isOpenMenu.value,
                  child: Column(
                    children: [
                      CustomPaint(
                        size: const Size(20, 10),
                        painter: _TrianglePainter(color: Colors.teal[400]!),
                      ),
                      Material(
                        color: context.theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: k4, horizontal: k6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: controller.isAuthenticated
                                ? controller.buttonWithLogin
                                : controller.buttonWithoutLogin,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Icon(icon, color: Colors.white, size: 24),
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
