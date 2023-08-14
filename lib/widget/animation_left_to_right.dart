// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';

class LeftToRightWidget extends StatefulWidget {
  LeftToRightWidget({
    Key? key,
    required this.index,
    required this.child,
  }) : super(key: key) {}
  final int index;
  final Widget child;

  @override
  State<LeftToRightWidget> createState() => _LeftToRightWidgetState();
}

class _LeftToRightWidgetState extends State<LeftToRightWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        _controller.forward();
      }
    });
    // var timer = Timer(Duration(milliseconds: 600), () {
    //   if (mounted) {
    //     _controller.forward();
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _animation,
      builder: (ctx, child) {
        return Transform.translate(
          offset: Offset(
              (size.width + widget.index * 100) * (_animation.value - 1), 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
