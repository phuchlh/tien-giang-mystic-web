import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../utils/gap.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String confirmText;
  final String cancelText;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.onCancel,
    this.confirmText = 'Đồng ý',
    this.cancelText = 'Hủy',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        content,
        style: context.textTheme.bodyMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly, // Center the buttons
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  onCancel?.call();
                  Get.back();
                },
                icon: Iconify(
                  MaterialSymbols.close_rounded,
                  size: k26,
                ),
                label: Text(
                  cancelText,
                  style: context.textTheme.labelLarge,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      context.theme.colorScheme.surfaceContainerLow,
                  foregroundColor: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  onConfirm();
                  Get.back();
                },
                icon: Iconify(
                  MaterialSymbols.check_small_rounded,
                  size: k26,
                ),
                label: Text(
                  confirmText,
                  style: context.textTheme.labelLarge,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.theme.colorScheme.inversePrimary,
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
