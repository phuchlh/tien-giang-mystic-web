import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tien_giang_mystic/modules/home_screen/home_screen_controller.dart';
import 'package:tien_giang_mystic/utils/images.dart';
import 'package:tien_giang_mystic/utils/responsive.dart';
import 'package:tien_giang_mystic/themes/colors_theme.dart';

class HomeScreenPage extends GetView<HomeScreenController> {
  const HomeScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Get.find<Responsive>();

    return GetBuilder<HomeScreenController>(
      builder: (controller) => Scaffold(
        backgroundColor: const Color(0xFFE5F3FF), // Light blue background
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.backgroundTG1),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main heading
                  Text(
                    'Where do\nyou want\nto be?',
                    style: TextStyle(
                      fontSize: responsive.fontSize.extraLarge,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Options
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: responsive.spacing(0.2),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.placesData.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            return _buildOptionButton(
                              controller.placesData[index].category,
                              [Color(0xFFFFFFFF), Color(0xFFCCCCCC)],
                              Colors.black,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
      String text, List<Color> gradientColors, Color textColor) {
    return Container(
      width: Get.width * 0.4, // 40% of screen width
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
