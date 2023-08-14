import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';
import 'package:task_app/widget/animated_top_to_bottom_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
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
                  'Privacy Policy'.tr(),
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
                  type: PageTransitionType.fade,
                  child: PrivacyPolicyWebPage()));
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => PrivacyPolicyWebPage()));
        },
      ),
    );
  }
}

class PrivacyPolicyWebPage extends StatelessWidget {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith(
              'https://sites.google.com/view/privacy-template/home')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(
        Uri.parse('https://sites.google.com/view/privacy-template/home'));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 235, 230, 230),
          body: Column(
            children: [
              TopToBottomWidget(
                index: 0,
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
                        "Privacy Policy".tr(),
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: OpacytiWidget(
                  number: 1,
                  child: WebViewWidget(controller: controller),
                ),
              ),
            ],
          )),
    );
  }
}
