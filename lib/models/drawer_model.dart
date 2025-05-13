import 'package:flutter/material.dart';
import 'package:tien_giang_mystic/utils/enum.dart';

class DrawerModel {
  EDrawerTypeButton typeButton;
  String title;
  String icon;
  bool isExpanded;

  DrawerModel({
    required this.typeButton,
    required this.title,
    required this.icon,
    required this.isExpanded,
  });
}
