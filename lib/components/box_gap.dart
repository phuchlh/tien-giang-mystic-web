import 'package:flutter/material.dart';

class BoxGap extends StatelessWidget {
  final double gapHeight;
  final double gapWidth;
  const BoxGap({super.key, this.gapHeight = 0.0, this.gapWidth = 0.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: gapHeight,
      width: gapWidth,
    );
  }
}
