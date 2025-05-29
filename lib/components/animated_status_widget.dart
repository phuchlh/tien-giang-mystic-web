import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tien_giang_mystic/utils/enum.dart';
import 'package:tien_giang_mystic/utils/gap.dart';
import 'package:tien_giang_mystic/utils/images.dart';

class AnimatedStatusWidget extends StatelessWidget {
  final String animated;
  final String message;

  const AnimatedStatusWidget(
      {super.key, required this.animated, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            animated,
            width: k100,
            height: k100,
            fit: BoxFit.cover,
          ),
          Gap(k8),
          Text(
            message,
            style:
                context.textTheme.bodyMedium?.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
