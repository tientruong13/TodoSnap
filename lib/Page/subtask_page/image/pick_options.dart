import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/widget/animated_bottom_to_top_widget.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';
import 'package:task_app/widget/font_size.dart';
import 'package:http/http.dart' as http;

enum ExtendedImageSource {
  gallery,
  camera,
  internet,
}

Future<ExtendedImageSource?> showImageOptions(BuildContext context) async {
  return await showModalBottomSheet<ExtendedImageSource>(
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
                  Ionicons.images,
                  size: 6.w,
                ),
                title: Text(
                  'Gallery'.tr(),
                  style: TextStyleUtils.title,
                ),
                onTap: () {
                  vibrateForAhalfSeconds();
                  Navigator.pop(context, ExtendedImageSource.gallery);
                },
              ),
            ),
            BottomToTopWidget(
              index: 2,
              child: ListTile(
                leading: Icon(
                  Ionicons.camera,
                  size: 6.w,
                ),
                title: Text(
                  'Camera'.tr(),
                  style: TextStyleUtils.title,
                ),
                onTap: () {
                  vibrateForAhalfSeconds();
                  Navigator.pop(context, ExtendedImageSource.camera);
                },
              ),
            ),
            BottomToTopWidget(
              index: 3,
              child: ListTile(
                leading: Icon(
                  Ionicons.globe,
                  size: 6.w,
                ),
                title: Text(
                  'Internet'.tr(),
                  style: TextStyleUtils.title,
                ),
                onTap: () {
                  vibrateForAhalfSeconds();
                  Navigator.pop(context, ExtendedImageSource.internet);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<String?> showUrlInputBox(BuildContext context) async {
  String url = '';
  String? errorMessage;

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          Future<bool> isValidImage(String url) async {
            try {
              if (!(url.startsWith('http://') || url.startsWith('https://'))) {
                url = 'http://' + url;
              }
              var uri = Uri.parse(url);
              final response = await http.get(uri);
              await PaintingBinding.instance
                  .instantiateImageCodec(response.bodyBytes);
              return true;
            } catch (e) {
              return false;
            }
          }

          return BottomToTopWidget(
            index: 1,
            child: SimpleDialog(
              contentPadding: EdgeInsets.only(top: 1.w),
              titlePadding: EdgeInsets.all(2.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              title: OpacytiWidget(
                number: 1,
                child: Padding(
                  padding: EdgeInsets.only(top: 2.w, bottom: 1.w),
                  child: Text(
                    'Link Website Of Image'.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              children: [
                OpacytiWidget(
                  number: 1,
                  child: SizedBox(
                    width: 80.w,
                    height: 14.h,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 4.w, right: 4.w, top: 1.w, bottom: 1.w),
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) async {
                              url = value;
                              final result = await isValidImage(url);
                              // ignore: unnecessary_null_comparison
                              if (result == null) {
                                setState(() {
                                  errorMessage = 'No image at this link'.tr();
                                });
                              } else {
                                setState(() {
                                  errorMessage = null;
                                });
                              }
                            },
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              hintText: "Enter Link Here".tr(),
                              border: InputBorder.none,
                            ),
                            style: TextStyleUtils.addTaskandSubtask,
                          ),
                          SizedBox(
                            height: 2.h,
                            child: errorMessage != null
                                ? Text(
                                    errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),
                          TextButton(
                            onPressed: () async {
                              vibrateForAhalfSeconds();
                              if (await isValidImage(url)) {
                                Navigator.of(context).pop(url);
                              } else {
                                setState(() {
                                  errorMessage = 'No image at this link'.tr();
                                });
                              }
                            },
                            child: Text(
                              'Save'.tr(),
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    },
  );
}

// Future<String?> showUrlInputBox(BuildContext context) async {
//   String url = '';
//   return showDialog<String>(
//     context: context,
//     builder: (BuildContext context) {
//       return BottomToTopWidget(
//         index: 1,
//         child: SimpleDialog(
//           contentPadding: EdgeInsets.only(top: 1.w),
//           titlePadding: EdgeInsets.all(2.w),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           title: OpacytiWidget(
//             number: 1,
//             child: Padding(
//               padding: EdgeInsets.only(top: 2.w, bottom: 1.w),
//               child: Text(
//                 'Input Image URL'.tr(),
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//           children: [
//             OpacytiWidget(
//               number: 1,
//               child: SizedBox(
//                 width: 80.w,
//                 height: 12.h,
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                       left: 4.w, right: 4.w, top: 1.w, bottom: 1.w),
//                   child: Column(
//                     children: [
//                       TextField(
//                         onChanged: (value) {
//                           url = value;
//                         },
                      
//                         enableSuggestions: false,
//                         decoration: InputDecoration(
//                           hintText: "Enter URL here",
//                           border: InputBorder.none,
//                         ),
//                         style: TextStyleUtils.addTaskandSubtask,
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           vibrateForAhalfSeconds();
//                           Navigator.of(context).pop(url);
//                         },
//                         child: Text(
//                           'Save'.tr(),
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
//     },
//   );
// }
