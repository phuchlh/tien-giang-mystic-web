import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tien_giang_mystic/components/box_gap.dart';
import 'package:tien_giang_mystic/modules/home_screen/components/list_title_location.dart';
import 'home_screen_controller.dart';
import '../../utils/images.dart';
import '../../utils/responsive.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class HomeScreenPage extends GetView<HomeScreenController> {
  const HomeScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Get.find<Responsive>();

    return GetBuilder<HomeScreenController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: KeyboardDismisser(
            gestures: [
              GestureType.onTap,
              GestureType.onPanUpdateDownDirection,
            ],
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header với hình nền và Avatar
                  Stack(
                    children: [
                      Container(
                        height: Get.height * 0.43,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Images.backgroundTG1),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 280,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.getTimeNow(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: responsive.fontSize.small + 3,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Bạn đang có dự định gì?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: responsive.fontSize.extraLarge,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Search Box
                  Padding(
                    padding: EdgeInsets.all(responsive.spacing(0.03)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Where are you going?',
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),

                  // Top Destination
                  ListLocationTitle(
                    title: "Điểm đến hàng đầu",
                    subTitle: "Xem tất cả",
                    listLocation: controller.topDestinations,
                  ),
                  BoxGap(
                    gapHeight: responsive.width * 0.1,
                  ),
                  ListLocationTitle(
                    title: "Điểm đến hàng đầu",
                    subTitle: "Xem tất cả",
                    listLocation: controller.topDestinations,
                  ),
                  BoxGap(
                    gapHeight: responsive.width * 0.1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
