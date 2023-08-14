// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class OpacytiWidget extends StatefulWidget {
  final Widget child;
  final int number;

  const OpacytiWidget({
    Key? key,
    required this.child,
    required this.number,
  }) : super(key: key);

  @override
  _OpacytiWidgettState createState() => _OpacytiWidgettState();
}

class _OpacytiWidgettState extends State<OpacytiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // if (mounted) {
    //   _controller.forward();
    // }
    //delay 1
    Future.delayed(Duration(seconds: widget.number), () {
      if (mounted) {
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
