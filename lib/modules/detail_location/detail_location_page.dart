import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tien_giang_mystic/modules/detail_location/detail_location_controller.dart';
import 'package:tien_giang_mystic/themes/colors_theme.dart';
import 'package:tien_giang_mystic/utils/images.dart';

class DetailLocationPage extends GetView<DetailLocationController> {
  const DetailLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          // SliverAppBar với hình ảnh và chuyển đổi title động
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Get.back(id: 1);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.black),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                Images.tgicon,
                fit: BoxFit.cover,
              ),
            ),
            title: Obx(
              () => AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: controller.isTitleVisible.value
                    ? Text(
                        'Venice',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ),
          ),

          // Nội dung bên dưới
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Venice',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Veneto Region, Italy',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(Icons.share, color: Colors.grey),
                      SizedBox(width: 10),
                      Icon(Icons.bookmark_border, color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Venice, known as the "Floating City," is a captivating destination unlike any other. With its intricate network of canals, romantic gondolas, and stunning architecture, Venice exudes a unique charm and enchantment. Lose yourself in the labyrinthine streets, adorned with beautiful bridges and vibrant piazzas. Explore iconic landmarks like St. Mark\'s Square, the Doge\'s Palace, and the Rialto Bridge..., Venice, known as the "Floating City," is a captivating destination unlike any other. With its intricate network of canals, romantic gondolas, and stunning architecture, Venice exudes a unique charm and enchantment. Lose yourself in the labyrinthine streets, adorned with beautiful bridges and vibrant piazzas. Explore iconic landmarks like St. Mark\'s Square, the Doge\'s Palace, and the Rialto Bridge..., Venice, known as the "Floating City," is a captivating destination unlike any other. With its intricate network of canals, romantic gondolas, and stunning architecture, Venice exudes a unique charm and enchantment. Lose yourself in the labyrinthine streets, adorned with beautiful bridges and vibrant piazzas. Explore iconic landmarks like St. Mark\'s Square, the Doge\'s Palace, and the Rialto Bridge..., Venice, known as the "Floating City," is a captivating destination unlike any other. With its intricate network of canals, romantic gondolas, and stunning architecture, Venice exudes a unique charm and enchantment. Lose yourself in the labyrinthine streets, adorned with beautiful bridges and vibrant piazzas. Explore iconic landmarks like St. Mark\'s Square, the Doge\'s Palace, and the Rialto Bridge..., Venice, known as the "Floating City," is a captivating destination unlike any other. With its intricate network of canals, romantic gondolas, and stunning architecture, Venice exudes a unique charm and enchantment. Lose yourself in the labyrinthine streets, adorned with beautiful bridges and vibrant piazzas. Explore iconic landmarks like St. Mark\'s Square, the Doge\'s Palace, and the Rialto Bridge...,',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Read more',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
