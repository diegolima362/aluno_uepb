import 'dart:math';

import 'package:flutter/material.dart';

class CustomCircularProgress extends CustomPainter {
  final Color valueColor;
  final double arcSize;

  final double value;

  CustomCircularProgress({
    required this.valueColor,
    required this.value,
    required this.arcSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s1 = arcSize;
    final s2 = arcSize * 1.5;
    const strokeWidth = 15.0;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawArc(
      Rect.fromCenter(center: center, width: s1, height: s1),
      radian(140),
      radian(260),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black12
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth,
    );

    canvas.saveLayer(
      Rect.fromCenter(center: center, width: s2, height: s2),
      Paint(),
    );

    final gradient = SweepGradient(
      startAngle: 1.25 * pi / 2,
      endAngle: 5.5 * pi / 2,
      tileMode: TileMode.repeated,
      colors: [
        valueColor.withAlpha(125),
        valueColor,
      ],
    );

    canvas.drawArc(
      Rect.fromCenter(center: center, width: s1, height: s1),
      radian(140),
      radian(260 * value),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..shader = gradient
            .createShader(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
        ..strokeWidth = strokeWidth,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  double radian(double degree) => degree * pi / 180;
}
