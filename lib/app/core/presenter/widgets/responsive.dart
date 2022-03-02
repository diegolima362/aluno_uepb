import 'package:flutter/material.dart';

class ResponsiveSize {
  final BuildContext? context;

  ResponsiveSize(this.context);

  Size size(BuildContext c) => MediaQuery.of(context ?? c).size;

  double h(BuildContext c) => size(c).height;

  double w(BuildContext c) => size(c).width;

  bool darkMode(BuildContext c) =>
      Theme.of(context ?? c).brightness == Brightness.dark;
}
