import 'package:flutter/material.dart';

class TopToBottomWidget extends StatefulWidget {
  final Widget child;
  final int index;

  const TopToBottomWidget({Key? key, required this.child, required this.index})
      : super(key: key);

  @override
  _TopToBottomWidgetState createState() => _TopToBottomWidgetState();
}

class _TopToBottomWidgetState extends State<TopToBottomWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: 200 * widget.index), () {
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
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _animation,
      builder: (ctx, child) {
        return Transform.translate(
          offset: Offset(0, (_animation.value - 1) * size.height),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
