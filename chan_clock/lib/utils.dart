import 'package:flutter/material.dart';

// scale screen size
class ScreenUtils {
  static MediaQueryData _mediaQuery;
  static double _ratio;

  static init(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);

    bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandScape) {
      _ratio = _mediaQuery.size.height / 648;
    } else {
      _ratio = _mediaQuery.size.width / 1080;
    }
  }

  static size(number) {
    return number * _ratio;
  }
}
