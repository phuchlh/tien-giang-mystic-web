import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tien_giang_mystic/utils/images.dart';

import '../../../models/place_model.dart';
import '../../../route/app_routes.dart';
import '../../../utils/responsive.dart';

class ListLocationTitle extends StatelessWidget {
  final String title;
  final String? subTitle;
  final List<PlaceModel> listLocation;
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
    return Column(
      children: [
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
                  color: context.theme.colorScheme.secondary,
                ),
              ),
              if (subTitle != null)
                TextButton(
                  onPressed: onClickSubtitle,
                  child: Text(
                    subTitle ?? "",
                    style: TextStyle(
                      fontSize: responsive.fontSize.small + 2,
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                )
            ],
          ),
        ),

        // Card List
        Container(
          // color: Colors.redAccent,
          padding: EdgeInsets.symmetric(vertical: responsive.spacing(0.01)),
          child: SizedBox(
            height: responsive.height * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listLocation.length,
              itemBuilder: (context, index) {
                final place = listLocation[index];
                return _buildTopDestinationCard(place, context);
              },
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildTopDestinationCard(PlaceModel place, BuildContext context) {
  final responsive = Get.find<Responsive>();
  return GestureDetector(
    onTap: () => Get.toNamed(AppRoutes.detailLocation),
    child: Card(
      color: context.theme.colorScheme.onPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              place.image,
              height: responsive.width * 0.43,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  place.location,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.theme.colorScheme.secondary,
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
