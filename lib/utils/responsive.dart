import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;

  Responsive(this.context);

  double get width => MediaQuery.of(context).size.width;

  late final _FontSize fontSize = _FontSize(width);

  // Responsive Padding/Margin chỉ với hằng số
  double spacing(double percent) {
    return width * percent;
  }
}

class _FontSize {
  final double width;

  _FontSize(this.width);

  double get tiny => width < 320 ? 10 : 12;
  double get small => width < 480 ? 12 : 14;
  double get normal => width < 800 ? 16 : 18;
  double get large => width < 1200 ? 20 : 22;
  double get extraLarge => width < 1600 ? 24 : 28;
}
