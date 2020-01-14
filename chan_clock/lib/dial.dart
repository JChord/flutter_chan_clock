import 'package:flutter/material.dart';

import 'utils.dart';

class DialPaint extends CustomPainter {
  double _topRadius = ScreenUtils.size(158);
  double _markRadius = ScreenUtils.size(6);

  double _dx = ScreenUtils.size(650);
  double _dy = ScreenUtils.size(184);

  Paint _markPaint;

  DialPaint() {
    _markPaint = Paint()
      ..color = Color(0xFF725E5E)
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // background rect
    Rect bgRect = Rect.fromLTWH(ScreenUtils.size(470), ScreenUtils.size(4),
        ScreenUtils.size(360), ScreenUtils.size(630));
    RRect rRect =
        RRect.fromRectAndRadius(bgRect, Radius.circular(ScreenUtils.size(172)));
    canvas.drawRRect(
        rRect,
        Paint()
          ..color = Color(0xFFDFC97B)
          ..isAntiAlias = true);

    // Top circle
    canvas.drawCircle(
        Offset(_dx, _dy),
        _topRadius,
        Paint()
          ..color = Color(0xFF36231E)
          ..isAntiAlias = true
          ..style = PaintingStyle.fill);

    // 4 marks circle
    canvas.drawCircle(Offset(_dx, _dy - _topRadius + _markRadius * 2),
        _markRadius, _markPaint);
    canvas.drawCircle(Offset(_dx + _topRadius - _markRadius * 2, _dy),
        _markRadius, _markPaint);
    canvas.drawCircle(Offset(_dx, _dy + _topRadius - _markRadius * 2),
        _markRadius, _markPaint);
    canvas.drawCircle(Offset(_dx - _topRadius + _markRadius * 2, _dy),
        _markRadius, _markPaint);

    // // Bottom circle
    canvas.drawCircle(
        Offset(_dx, ScreenUtils.size(470)),
        ScreenUtils.size(92),
        Paint()
          ..color = Color(0xFF856E2F)
          ..isAntiAlias = true
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
