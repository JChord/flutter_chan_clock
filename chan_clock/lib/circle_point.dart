import 'package:flutter/material.dart';

import 'utils.dart';

class CirclePoint extends CustomPainter {
  Paint _borderPaint;
  Paint _fillLargePaint;
  Paint _fillSmallPaint;

  CirclePoint() {
    _borderPaint = Paint()
      ..color = Color(0xFFF9E9B5)
      ..style = PaintingStyle.fill;

    _fillLargePaint = Paint()
      ..color = Color(0xFFB59D49)
      ..style = PaintingStyle.fill;

    _fillSmallPaint = Paint()
      ..color = Color(0xFFDFC97B)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Offset offset = Offset(ScreenUtils.size(650), ScreenUtils.size(184));

    canvas.drawCircle(offset, ScreenUtils.size(22), _borderPaint);
    canvas.drawCircle(offset, ScreenUtils.size(20), _fillLargePaint);
    canvas.drawCircle(offset, ScreenUtils.size(12), _borderPaint);
    canvas.drawCircle(offset, ScreenUtils.size(10), _fillSmallPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
