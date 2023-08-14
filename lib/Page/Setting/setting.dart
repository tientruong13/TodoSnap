import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Page/Setting/change_name.dart';
import 'package:task_app/Page/Setting/contact_support.dart';
import 'package:task_app/Page/Setting/date_style/date_style.dart';
import 'package:task_app/Page/Setting/language.dart';
import 'package:task_app/Page/Setting/language/language_provider.dart';
import 'package:task_app/Page/Setting/rate_app.dart';
import 'package:task_app/Page/Setting/privacy_policy.dart';
import 'package:task_app/Page/Setting/share_app.dart';
import 'package:task_app/Page/Setting/theme.dart';
import 'package:task_app/widget/animated_bottom_to_top_widget.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';
import 'package:task_app/widget/color.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
          return Stack(children: [
            Positioned(
              top: -20.w,
              right: -10.w,
              child: Icon(
                Ionicons.cog,
                size: 80.w,
                color: iconBackgroundColor(context),
              ),
            ),
            Positioned(
              bottom: -5.w,
              left: -20.w,
              child: Hero(
                tag: 'Setting',
                child: Material(
                  type: MaterialType.transparency,
                  child: Icon(
                    Ionicons.settings,
                    size: 100.w,
                    color: iconBackgroundColor(context),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OpacytiWidget(
                  number: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 3.w),
                    child: IconButton(
                      onPressed: () {
                        vibrateForAhalfSeconds();
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Ionicons.chevron_back,
                        size: 6.w,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 5.w,
                      bottom: 15.w,
                    ),
                    child: OpacytiWidget(
                      number: 1,
                      child: Text(
                        'Settings'.tr(),
                        style: TextStyle(
                            fontSize: 22.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Column(
                    children: [
                      BottomToTopWidget(index: 2, child: ChangeName()),
                      BottomToTopWidget(index: 3, child: Languages()),
                      BottomToTopWidget(index: 4, child: ThemeApp()),
                      BottomToTopWidget(index: 5, child: DateStyle()),
                      BottomToTopWidget(index: 6, child: ShareApp()),
                      BottomToTopWidget(index: 7, child: RateApp()),
                      BottomToTopWidget(index: 8, child: PrivacyPolicy()),
                      BottomToTopWidget(index: 9, child: ContactSupport()),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
                bottom: 3.w,
                left: 40.w,
                child: Text(
                  'Version 1.2',
                  style: TextStyle(fontSize: 16.sp),
                )),
          ]);
        }),
      ),
    );
  }
}
