import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../utils/gap.dart';
import '../../../utils/images.dart';

import '../map_screen_controller.dart';

class ExploreWidget extends GetView<MapScreenController> {
  const ExploreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 320,
        height: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Messages List and Typing Indicator
            Expanded(
              child: Container(
                color: Colors.grey[50],
                child: Stack(
                  children: [
                    // Messages
                    _buildMessagesList(),

                    // Typing Indicator
                    _buildTypingIndicator(),
                  ],
                ),
              ),
            ),

            // Input Area - Always at bottom
            _buildInputArea(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(Images.tgicon),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Trợ lý Tiền Giang",
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Đang hoạt động",
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove, color: Colors.grey[600], size: 20),
            onPressed: () => controller.toggleMinimized(),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
          const Gap(4),
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[600], size: 20),
            onPressed: () => Navigator.of(context).pop(),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          final message = controller.messages[index];
          final isUser = message['isUser'] as bool;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isUser) ...[
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage(Images.tgicon),
                  ),
                  const Gap(8),
                ],
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? Get.theme.primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: MarkdownBody(
                      data: message['text'] as String,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Obx(
        () => controller.isWaiting.value
            ? Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey[50],
                child: const Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    Gap(8),
                    Text(
                      "Đang trả lời...",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.promptController,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Nhập tin nhắn...",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) => controller.addUserInput(),
            ),
          ),
          const Gap(8),
          Container(
            decoration: BoxDecoration(
              color: context.theme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, size: 18, color: Colors.white),
              onPressed: () => controller.addUserInput(),
              constraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
