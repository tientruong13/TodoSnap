// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum CheckStatus {
  checked,
  unchecked,
}

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.height,
    required this.width,
  }) : super(key: key);
  final bool value;
  final ValueChanged<bool> onChanged;
  final double height;
  final double width;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _checkBoxController;
  late bool _checked;
  late CheckStatus status;
  @override
  void initState() {
    _checkBoxController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _checkBoxController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  void _init() {
    _checked = widget.value;
    if (_checked) {
      status = CheckStatus.checked;
      _checkBoxController.forward();
    } else {
      status = CheckStatus.unchecked;
      _checkBoxController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!_checked),
      child: Lottie.asset(
        'assets/checkbox.json',
        height: widget.height,
        width: widget.width,
        controller: _checkBoxController,
      ),
    );
  }
}
