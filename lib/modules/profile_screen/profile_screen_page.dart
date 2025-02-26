import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tien_giang_mystic/modules/profile_screen/profile_screen_controller.dart';

class ProfileScreenPage extends StatelessWidget {
  const ProfileScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileScreenController>(
      builder: (controller) => Scaffold(
        body: Center(
          child: Container(
            child: Text("Profile"),
          ),
        ),
      ),
    );
  }
}
