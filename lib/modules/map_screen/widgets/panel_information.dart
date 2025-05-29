import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../../../utils/gap.dart';
import '../map_screen_controller.dart';
import 'news_tab.dart';
import 'place_description.dart';
import 'place_image.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import '../../../components/chip_widget.dart';

class PanelInformation extends GetView<MapScreenController> {
  final ScrollController scrollController;
  const PanelInformation({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapScreenController>(
      builder: (controller) => Padding(
        padding: EdgeInsets.symmetric(
          vertical: k16,
        ),
        child: Obx(
          () {
            final isBookmarked = controller.isOnBookmarkList(
              controller.placeDetail.value.id ?? "",
            );
            final listLabel = controller.onSplitPlaceLabel(
              controller.placeDetail.value.placeLabel ?? "",
            );
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: k24, vertical: k14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.placeDetail.value.placeName ?? '',
                              style: context.textTheme.titleLarge?.copyWith(
                                color: context.theme.colorScheme.scrim,
                              ),
                              maxLines: 2,
                            ),
                            Gap(k10),
                            _RowText(
                              icon: Iconify(
                                MaterialSymbols.location_on_outline_rounded,
                                color: context.theme.colorScheme.primary,
                                size: k26,
                              ),
                              content:
                                  controller.placeDetail.value.address ?? '',
                            ),
                            Gap(k8),
                            _RowText(
                              icon: Iconify(
                                MaterialSymbols.timer_outline_rounded,
                                color: context.theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                                size: k26,
                              ),
                              content:
                                  controller.placeDetail.value.openCloseHour ??
                                      '',
                            ),
                            Gap(k8),
                            ChipWidget(
                              listLabel: listLabel,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.onPostBookmarkPlace(
                            locationID: controller.placeDetail.value.id ?? "",
                          );
                        },
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked
                              ? context.theme.colorScheme.primary
                              : context.theme.colorScheme.scrim,
                          size: k30,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(k4),
                TabBar(
                  tabs: controller.tabsData,
                  controller: controller.tabController,
                ),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      PlaceDescription(
                        scrollController: scrollController,
                      ),
                      PlaceImage(
                        scrollController: scrollController,
                      ),
                      NewsTab(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RowText extends StatelessWidget {
  final Widget icon;
  final String content;
  const _RowText({
    super.key,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        Gap(k8),
        Expanded(
          child: Text(
            content,
            maxLines: 2,
            style: context.textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }
}
