import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../../utils/gap.dart';
import '../../utils/images.dart';
import 'auth_controller.dart';

import 'package:iconify_flutter/icons/tabler.dart';

import 'package:iconify_flutter/icons/gis.dart';
import 'package:iconify_flutter/icons/simple_line_icons.dart';

class AuthWidget extends GetView<AuthController> {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Obx(() {
        final isExpanded = controller.isDrawerExpanded.value;
        final isLogin = controller.isAuthenticated;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isExpanded ? k200 : k60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: k10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.close : Icons.menu,
                    size: k24,
                  ),
                  onPressed: controller.toggleDrawer,
                  tooltip: isExpanded ? 'Đóng' : 'Mở',
                ),
                Gap(k10),
                _CircleImageWidget(),
                Gap(k20),
                ...(!isLogin
                    ? [
                        _DrawerItem(
                          icon: SimpleLineIcons.login,
                          label: 'Đăng nhập',
                          labelExpanded: 'Đăng nhập',
                          isExpanded: isExpanded,
                          onTap: controller.signInWithGoogle,
                        ),
                      ]
                    : [
                        _DrawerItem(
                          icon: Gis.bookmark_poi,
                          label: 'Địa điểm',
                          labelExpanded: 'Địa điểm đã lưu',
                          isExpanded: isExpanded,
                          onTap: () {
                            print("Địa điểm");
                          },
                        ),
                        Gap(k20),
                        _DrawerItem(
                          icon: Gis.route,
                          label: 'Chuyến đi',
                          labelExpanded: 'Chuyến đi đã lưu',
                          isExpanded: isExpanded,
                          onTap: () {
                            print("Địa điểm");
                          },
                        ),
                      ]),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _DrawerItem extends GetView<AuthController> {
  final String icon;
  final String label;
  final String labelExpanded;
  final bool isExpanded;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.isExpanded = false,
    this.labelExpanded = "",
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: isExpanded
            ? Row(
                children: [
                  Iconify(
                    icon,
                    color: null,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    isExpanded ? labelExpanded : label,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Iconify(
                    icon,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  Gap(k8),
                  Text(
                    isExpanded ? labelExpanded : label,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}

class _CircleImageWidget extends GetView<AuthController> {
  const _CircleImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isAuthenticated
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
            );
    });
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
