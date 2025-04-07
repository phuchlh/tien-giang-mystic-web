import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../map_screen_controller.dart';

class FloatingSearchField extends GetView<MapScreenController> {
  const FloatingSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.search,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm địa điểm tại Tiền Giang...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                onSubmitted: (value) {
                  // Handle search here
                  controller.handleSearch(value);
                },
              ),
            ),
            // Clear button
            Obx(() {
              if (controller.searchController.text.isNotEmpty) {
                return IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.clearSearch();
                  },
                );
              }
              return const SizedBox(width: 16);
            }),
          ],
        ),
      ),
    );
  }
}
