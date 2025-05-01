import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tien_giang_mystic/utils/gap.dart';

class ChipWidget extends StatelessWidget {
  final List<String> listLabel;
  const ChipWidget({super.key, required this.listLabel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: listLabel.map((e) {
          return Padding(
            padding: EdgeInsets.only(right: k6),
            child: Chip(
              labelPadding: const EdgeInsets.all(0),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              label: Text(e),
              labelStyle: TextStyle(
                color: context.theme.colorScheme.onSecondaryFixed,
                fontSize: 14,
              ),
              backgroundColor:
                  context.theme.colorScheme.inversePrimary.withAlpha(100),
              shape: StadiumBorder(
                side: BorderSide(
                  color:
                      context.theme.colorScheme.inversePrimary.withAlpha(100),
                  width: 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
