import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Page/Setting/language/select_language.dart';

class Languages extends StatefulWidget {
  const Languages({super.key});

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
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
                  'Languages'.tr(),
                  style: TextStyle(fontSize: 18.sp),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
          ),
        ),
        onTap: () {
          vibrateForAhalfSeconds();
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: LanguageSelection()));
        },
      ),
    );
  }
}
