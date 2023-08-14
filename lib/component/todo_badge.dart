import 'package:flutter/material.dart';

class TodoBadge extends StatelessWidget {
  final int codePoint;
  final Color color;
  final String id;
  final double? size;

  TodoBadge({
    required this.codePoint,
    required this.color,
    required this.id,
    Color? outlineColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: id,
      child: Icon(
        IconData(
          codePoint,
          fontFamily: 'MaterialIcons',
        ),
        color: color,
        size: size,
      ),
    );
  }
}
