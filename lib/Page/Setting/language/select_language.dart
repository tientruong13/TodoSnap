import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Page/Setting/language/language_provider.dart';
import 'package:task_app/widget/animated_bottom_to_top_widget.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';
import 'package:task_app/widget/animated_top_to_bottom_widget.dart';
import 'package:task_app/widget/color.dart';

class LanguageSelection extends StatefulWidget {
  @override
  _LanguageSelectionState createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  late LanguageProvider languageProvider;

  @override
  void initState() {
    super.initState();
    languageProvider = Provider.of<LanguageProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          TopToBottomWidget(
            index: 1,
            child: Container(
              height: 8.h,
              width: 100.w,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6.w),
                  bottomRight: Radius.circular(6.w),
                ),
              ),
              child: OpacytiWidget(
                number: 1,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        vibrateForAhalfSeconds();
                        Navigator.pop(context);
                      },
                      icon: Icon(Ionicons.chevron_back),
                    ),
                    Text(
                      'Select Language'.tr(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: languageProvider.languages.length,
              itemBuilder: (context, index) {
                final language = languageProvider.languages[index];
                return BottomToTopWidget(
                  index: index,
                  child: Container(
                    color: languageProvider.currentLanguageCode == language.code
                        ? Colors.white
                        : Colors.transparent,
                    child: ListTile(
                      title: Text(
                        language.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: languageProvider.currentLanguageCode ==
                                  language.code
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: languageProvider.currentLanguageCode ==
                                  language.code
                              ? Colors.blue
                              : accentColor(
                                  context), // You can choose any color here
                        ),
                      ),
                      trailing:
                          languageProvider.currentLanguageCode == language.code
                              ? Icon(
                                  Icons.check,
                                  color: Colors.blue,
                                  size: 6.w,
                                )
                              : null,
                      onTap: () {
                        vibrateForAhalfSeconds();
                        languageProvider.changeLanguage(context, language.code);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      )),
    );
  }
}
