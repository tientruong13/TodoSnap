import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrimaryColorOption extends StatelessWidget {
  const PrimaryColorOption({
    Key? key,
    required this.color,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        key: Key('__${color.value}_color_option__'),
        padding: EdgeInsets.all(0.5.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).dividerColor
                : Colors.transparent,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: color,
          ),
        ),
      ),
    );
  }
}
