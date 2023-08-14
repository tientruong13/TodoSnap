import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/component/todo_badge.dart';

import 'icon_picker.dart';

class IconPickerBuilder extends StatelessWidget {
  final IconData iconData;
  final ValueChanged<IconData> action;
  final Color highlightColor;

  IconPickerBuilder({
    required this.iconData,
    required this.action,
    required Color highlightColor,
  }) : this.highlightColor = highlightColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // borderRadius: BorderRadius.circular(50.0),

      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Container(
                padding: EdgeInsets.only(
                    left: 3.w, right: 3.w, top: 3.w, bottom: 3.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select an icon'.tr(),
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2.w),
                    SingleChildScrollView(
                      child: IconPicker(
                        currentIconData: iconData,
                        onIconChanged: action,
                        highlightColor: highlightColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: TodoBadge(
        id: 'id',
        codePoint: iconData.codePoint,
        color: highlightColor,
        outlineColor: highlightColor,
        size: 10.w,
      ),
    );
  }
}
