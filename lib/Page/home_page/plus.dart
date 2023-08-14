import 'package:flutter/material.dart';

class BoxShadowPainter extends CustomPainter {
  final BoxShadow boxShadow;

  BoxShadowPainter(this.boxShadow);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = boxShadow.toPaint();
    final rect = Offset.zero & size;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(BoxShadowPainter oldDelegate) {
    return boxShadow != oldDelegate.boxShadow;
  }
}
