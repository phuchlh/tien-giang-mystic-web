import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:tien_giang_mystic/route/app_routes.dart';
import 'package:tien_giang_mystic/themes/colors_theme.dart';
import 'package:tien_giang_mystic/utils/responsive.dart';

class ListLocationTitle extends StatelessWidget {
  final String title;
  final String? subTitle;
  final List listLocation;
  final VoidCallback? onClickSubtitle;
  const ListLocationTitle({
    super.key,
    required this.title,
    this.subTitle = "",
    required this.listLocation,
    this.onClickSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Get.find<Responsive>();
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: responsive.fontSize.large,
                fontWeight: FontWeight.bold,
                color: ThemeColor.grey1,
              ),
            ),
            if (subTitle != null)
              TextButton(
                onPressed: onClickSubtitle,
                child: Text(
                  subTitle ?? "",
                  style: TextStyle(
                    fontSize: responsive.fontSize.small + 2,
                    color: ThemeColor.blue1,
                  ),
                ),
              )
          ],
        ),
      ),
      const SizedBox(height: 15),

      // Card List
      SizedBox(
        height: 250,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listLocation.length,
          itemBuilder: (context, index) {
            final place = listLocation[index];
            return _buildTopDestinationCard(
              place['image'] ?? "",
              place['title'] ?? "",
              place['location'] ?? "",
            );
          },
        ),
      ),
    ]);
  }
}

Widget _buildTopDestinationCard(String image, String title, String location) {
  final responsive = Get.find<Responsive>();
  return GestureDetector(
    onTap: () => Get.toNamed(AppRoutes.detailLocation, id: 1),
    child: Container(
      width: responsive.width * 0.44,
      margin: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              image,
              height: responsive.width * 0.43,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
