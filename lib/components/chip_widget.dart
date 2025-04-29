import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tien_giang_mystic/utils/gap.dart';

class ChipWidget extends StatelessWidget {
  final List<String> listLabel;
  const ChipWidget({super.key, required this.listLabel});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: k8,
      runSpacing: k10,
      children: listLabel.map((e) {
        return Chip(
          label: Text(e),
          labelStyle: TextStyle(
            color: context.theme.colorScheme.onSecondaryFixed,
          ),
          backgroundColor:
              context.theme.colorScheme.inversePrimary.withAlpha(100),
          shape: StadiumBorder(
            side: BorderSide(
              color: context.theme.colorScheme.inversePrimary
                  .withAlpha(100), // Đổi sang màu bạn muốn
              width: 1.5,
            ),
          ),
        );
      }).toList(),
    );
  }
}
