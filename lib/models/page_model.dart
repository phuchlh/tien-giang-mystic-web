import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PageModel extends Equatable {
  final String title;
  final String pageTitle;
  final Widget icon;
  final bool shouldShowAppBar;

  const PageModel._({
    required this.title,
    required this.pageTitle,
    required this.icon,
    required this.shouldShowAppBar,
  });

  const PageModel.home({
    String? title,
    String? pageTitle,
    String? icon,
    bool? shouldShowAppBar,
  }) : this._(
          title: title ?? 'Trang chủ',
          pageTitle: pageTitle ?? 'Trang chủ',
          icon: const Icon(Icons.explore_outlined),
          shouldShowAppBar: shouldShowAppBar ?? true,
        );

  const PageModel.explorer({
    String? title,
    String? pageTitle,
    String? icon,
    bool? shouldShowAppBar,
  }) : this._(
          title: title ?? 'Khám phá',
          pageTitle: pageTitle ?? 'Khám phá',
          icon: const Icon(Icons.map_outlined),
          shouldShowAppBar: shouldShowAppBar ?? true,
        );

  const PageModel.profile({
    String? title,
    String? pageTitle,
    String? icon,
    bool? shouldShowAppBar,
  }) : this._(
          title: title ?? 'Hồ sơ',
          pageTitle: pageTitle ?? 'Hồ sơ',
          icon: const Icon(Icons.person_outline),
          shouldShowAppBar: shouldShowAppBar ?? true,
        );

  @override
  List<Object?> get props => [title, pageTitle, icon];
}
