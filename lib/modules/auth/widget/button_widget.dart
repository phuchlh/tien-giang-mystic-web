import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../utils/gap.dart';
import '../auth_controller.dart';

class ButtonWidget extends GetView<AuthController> {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  const ButtonWidget(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: k4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: k24),
              Gap(k8),
              Text(
                text,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: k16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
