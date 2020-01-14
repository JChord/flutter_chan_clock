import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'utils.dart';

class OverCirclePaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(ScreenUtils.size(536), ScreenUtils.size(362),
        ScreenUtils.size(230), ScreenUtils.size(230));
    final startAngle = -math.pi;
    final sweepAngle = math.pi;
    canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        Paint()
          ..color = Color(0xFFDFC97B)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 16);

    canvas.drawCircle(
        Offset(ScreenUtils.size(650), ScreenUtils.size(470)),
        ScreenUtils.size(94),
        Paint()
          ..color = Color(0xFFF8E6AA)
          ..isAntiAlias = true
          ..strokeWidth = ScreenUtils.size(2)
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
