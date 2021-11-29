import 'package:flutter/material.dart';

class RipplePainter extends CustomPainter {

  final double animation;
  final bool isLeft;

  RipplePainter(this.animation, this.isLeft);

  @override
  void paint(Canvas canvas, Size size) {
    Color myColor = Colors.white10;

    Paint firstPaint = Paint();
    firstPaint.color = myColor.withOpacity(1 - animation.clamp(0.0, 1.0));

    canvas.drawCircle(Offset(isLeft ? 0 : size.width, size.height / 2), size.height * animation, firstPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}