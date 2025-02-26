import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tien_giang_mystic/modules/login_screen/login_screen_controller.dart';
import 'package:tien_giang_mystic/themes/colors_theme.dart';

class LoginScreenPage extends StatelessWidget {
  const LoginScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginScreenController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(title: Text('Browse')),
        body: Center(
          child: Container(
            child: Text(Get.find<LoginScreenController>().title.value),
          ),
        ),
      ),
    );
  }
}
