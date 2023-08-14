import 'package:flutter/material.dart';

class CreateText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final dynamic fontWeight;
  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;

  CreateText(
      {Key? key,
      required this.text,
      this.fontSize,
      this.color,
      this.fontWeight,
      this.maxLines,
      this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text(
        text,
        maxLines: maxLines,
        textAlign: textAlign,
        style:
            TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color),
      ),
    );
  }
}
