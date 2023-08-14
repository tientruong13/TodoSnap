import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Page/Setting/date_style/date_style_select.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';

class DateStyle extends StatefulWidget {
  const DateStyle({super.key});

  @override
  State<DateStyle> createState() => _DateStyleState();
}

class _DateStyleState extends State<DateStyle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.w),
      child: GestureDetector(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date Style'.tr(),
                  style: TextStyle(fontSize: 18.sp),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
          ),
        ),
        onTap: () {
          vibrateForAhalfSeconds();
          selectDateStyle(context);
        },
      ),
    );
  }
}

void selectDateStyle(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 1.w,
            right: 1.w,
          ),
          child: Container(
            height: 65.h,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.w, bottom: 3.w),
                      child: OpacytiWidget(
                        number: 1,
                        child: Text(
                          'Select Date Style'.tr(),
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(child: SelectDateStyle())
                  ],
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}
