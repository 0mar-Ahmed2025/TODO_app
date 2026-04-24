// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';

enum NavigatorType { push, pushReplacement, pushAndRemoveUntil, pop }

abstract class MyNavigator {
  static goto(
    BuildContext? context,
    Widget screen, {
    NavigatorType type = NavigatorType.push,
  }) {
    var pageRoute = MaterialPageRoute(builder: (_) => screen);
    switch (type) {
      case NavigatorType.pop:
        return Navigator.pop(context!, pageRoute);
      case NavigatorType.push:
        return Navigator.push(context!, pageRoute);
      case NavigatorType.pushReplacement:
        return Navigator.pushReplacement(context!, pageRoute);
      case NavigatorType.pushAndRemoveUntil:
        return Navigator.pushAndRemoveUntil(
          context!,
          pageRoute,
          (route) => false,
        );
    }
  }
}
