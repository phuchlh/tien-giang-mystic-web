import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/enum.dart';
import '../../../utils/gap.dart';
import '../../../utils/images.dart';
import '../map_screen_controller.dart';
import 'news_card.dart';

class NewsTab extends GetView<MapScreenController> {
  const NewsTab({super.key});

  // News news = News(
  //   date: "2021-10-10",
  //   position: 1,
  //   source: "Mực Tím",
  //   title: "THPT Nguyễn Đình Chiểu",
  //   link: "https://www.google.com",
  //   snippet:
  //       "THPT Nguyễn Đình Chiểu là một trường trung học phổ thông tại thành phố Mỹ Tho, tỉnh Tiền Giang, Việt Nam.",
  //   imageUrl:
  //       "https://gamek.mediacdn.vn/zoom/320_200/133514250583805952/2021/6/24/photo-1-16245000005922003764148.jpg",
  // );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapScreenController>(
      builder: (controller) {
        return Obx(
          () {
            if (controller.dataLoadingStatus.value ==
                DataLoadingStatus.loading) {
              return Center(
                child: Lottie.asset(
                  Images.loading,
                  width: k50 * 4.5,
                  height: k50 * 4.5,
                ),
              );
            }
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0.1,
                  mainAxisSpacing: .2,
                  childAspectRatio: 1.7,
                ),
                itemCount: controller.listSearch.length,
                // itemCount: 10,
                itemBuilder: (context, index) {
                  return NewsCard(
                    news: controller.listSearch[index],
                  );
                });
          },
        );
      },
    );
  }
}
