import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Page/Setting/theme/theme_light_drak.dart';
import 'theme/presentation/settings/widgets/primary_color_switcher.dart';

class ThemeApp extends StatefulWidget {
  const ThemeApp({super.key});

  @override
  State<ThemeApp> createState() => _ThemeAppState();
}

class _ThemeAppState extends State<ThemeApp> {
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
                  'Theme'.tr(),
                  style: TextStyle(fontSize: 18.sp),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
          ),
        ),
        onTap: () {
          vibrateForAhalfSeconds();
          editName(context);
        },
      ),
    );
  }
}

void editName(BuildContext context) {
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
                top: Radius.circular(20),
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Text('Theme Colors'.tr(),
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: 5.w, left: 2.w, right: 2.w, top: 2.w),
                        child: Text('Theme Light And Dark'.tr(),
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    ImageThemeSwitcher(),
                    SizedBox(height: 2.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: 5.w, left: 2.w, right: 2.w, top: 2.w),
                        child: Text('Theme Colors'.tr(),
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    PrimaryColorSwitcher(),
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
