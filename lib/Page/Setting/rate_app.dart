import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RateApp extends StatefulWidget {
  const RateApp({super.key});

  @override
  State<RateApp> createState() => _RateAppState();
}

class _RateAppState extends State<RateApp> {
  // final InAppReview inAppReview = InAppReview.instance;

  // void _rateApp() async {
  //   try {
  //     bool isAvailable = await inAppReview.isAvailable();
  //     print('Is review available? $isAvailable');

  //     if (isAvailable) {
  //       inAppReview.requestReview();
  //       print('Review requested');
  //     }
  //     // else {
  //     //   // If in-app review is not available, it will open the Google Play Store or Apple App Store page for the app
  //     //   inAppReview.openStoreListing(
  //     //       appStoreId: Platform.isIOS ? '' : 'com.tientruong.todosnap');
  //     //   print('Opened store listing');
  //     // }
  //   } catch (e) {
  //     print('Error requesting review: $e');
  //   }
  // }

// https://play.google.com/store/apps/details?id=com.tientruong.todosnap&showAllReviews=true
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
                Container(
                  width: 75.w,
                  child: Text(
                    'Rate App 5 Stars'.tr(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
          ),
        ),
        onTap: () => LaunchReview.launch(
          androidAppId: "com.tientruong.todosnap",
          // iOSAppId: "585027354",
        ),
      ),
    );
  }
}
