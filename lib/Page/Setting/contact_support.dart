import 'package:task_app/Functions/option/vibration.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ContactSupport extends StatefulWidget {
  const ContactSupport({super.key});

  @override
  State<ContactSupport> createState() => _ContactSupportState();
}

class _ContactSupportState extends State<ContactSupport> {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'ti3n3t@gmail.com  ',
      query: encodeQueryParameters(<String, String>{
        'subject': 'App Support - ToDo Snap App',
      }),
    );
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
                  Container(
                    width: 75.w,
                    child: Text(
                      'Contact Support'.tr(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right)
                ],
              ),
            ),
          ),
          onTap: () {
            vibrateForAhalfSeconds();
            launchUrl(emailLaunchUri);
          }),
    );
  }
}
