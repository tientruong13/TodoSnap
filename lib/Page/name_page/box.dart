import 'package:flutter/material.dart';

//Copy this CustomPainter code to the Bottom of the File
class BoxName extends CustomPainter {
  final Color color;
  BoxName({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.7785598, 0);
    path_0.lineTo(size.width * 0.2214946, 0);
    path_0.cubicTo(size.width * 0.09917120, 0, 0, size.height * 0.1459800, 0,
        size.height * 0.3260400);
    path_0.lineTo(0, size.height * 0.6739600);
    path_0.cubicTo(0, size.height * 0.8540200, size.width * 0.09917120,
        size.height, size.width * 0.2214946, size.height);
    path_0.lineTo(size.width * 0.3391848, size.height);
    path_0.cubicTo(
        size.width * 0.3604891,
        size.height,
        size.width * 0.3777582,
        size.height * 0.9745800,
        size.width * 0.3777582,
        size.height * 0.9432200);
    path_0.lineTo(size.width * 0.3777582, size.height * 0.8184400);
    path_0.cubicTo(
        size.width * 0.3777582,
        size.height * 0.8109600,
        size.width * 0.3780707,
        size.height * 0.8035800,
        size.width * 0.3786685,
        size.height * 0.7963400);
    path_0.cubicTo(
        size.width * 0.3860734,
        size.height * 0.7073600,
        size.width * 0.4375815,
        size.height * 0.6384400,
        size.width * 0.5000408,
        size.height * 0.6384400);
    path_0.cubicTo(
        size.width * 0.5624864,
        size.height * 0.6384400,
        size.width * 0.6140082,
        size.height * 0.7073600,
        size.width * 0.6214130,
        size.height * 0.7963400);
    path_0.cubicTo(
        size.width * 0.6220109,
        size.height * 0.8035800,
        size.width * 0.6223234,
        size.height * 0.8109600,
        size.width * 0.6223234,
        size.height * 0.8184400);
    path_0.lineTo(size.width * 0.6223234, size.height * 0.9436400);
    path_0.cubicTo(
        size.width * 0.6223234,
        size.height * 0.9747600,
        size.width * 0.6394701,
        size.height * 1.000000,
        size.width * 0.6606114,
        size.height * 1.000000);
    path_0.lineTo(size.width * 0.7785734, size.height * 1.000000);
    path_0.cubicTo(
        size.width * 0.9008967,
        size.height * 1.000000,
        size.width * 1.000068,
        size.height * 0.8540200,
        size.width * 1.000068,
        size.height * 0.6739600);
    path_0.lineTo(size.width * 1.000068, size.height * 0.3260400);
    path_0.cubicTo(size.width * 1.000054, size.height * 0.1459800,
        size.width * 0.9008832, 0, size.width * 0.7785598, 0);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = color;
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
