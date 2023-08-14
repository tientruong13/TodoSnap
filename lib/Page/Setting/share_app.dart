import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/widget/animated_bottom_to_top_widget.dart';
import 'package:task_app/widget/font_size.dart';

class ShareApp extends StatefulWidget {
  const ShareApp({super.key});

  @override
  State<ShareApp> createState() => _ShareAppState();
}

class _ShareAppState extends State<ShareApp> {
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
                    'Share App With Friends'.tr(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
          ),
        ),
        onTap: () async {
          await showShareOptions(context);
          // await Share.share(
          //     'ToDo Snap: https://play.google.com/store/apps/details?id=com.tientruong.todosnap');
        },
      ),
    );
  }
}

Future showShareOptions(BuildContext context) async {
  return await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
            // borderRadius: BorderRadius.vertical(
            //   top: Radius.elliptical(200, 70),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomToTopWidget(
              index: 1,
              child: ListTile(
                leading: Icon(
                  Ionicons.qr_code,
                  size: 6.w,
                ),
                title: Text(
                  'Scan QR code'.tr(),
                  style: TextStyleUtils.title,
                ),
                onTap: () {
                  vibrateForAhalfSeconds();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return QRCode();
                      });
                },
              ),
            ),
            BottomToTopWidget(
              index: 2,
              child: ListTile(
                leading: Icon(
                  Ionicons.link,
                  size: 6.w,
                ),
                title: Text(
                  'Share Link'.tr(),
                  style: TextStyleUtils.title,
                ),
                onTap: () async {
                  vibrateForAhalfSeconds();
                  await Share.share(
                      'ToDo Snap: https://play.google.com/store/apps/details?id=com.tientruong.todosnap');
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

class QRCode extends StatelessWidget {
  const QRCode({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomToTopWidget(
      index: 1,
      child: Center(
        child: Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.w),
              ),
              elevation: 10,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.w)),
                child: Image.asset('assets/qrcode.png'),
              ),
            )),
      ),
    );
  }
}
