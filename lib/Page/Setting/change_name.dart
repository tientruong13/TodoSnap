import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Page/name_page/name_notifier.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({super.key});

  @override
  State<ChangeName> createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
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
                  'Change Name'.tr(),
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
  bool validate = false;
  String newName = '';
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        final nameProvider = Provider.of<NameNotifier>(context);
        var name = nameProvider.name;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 1.w,
            right: 1.w,
          ),
          child: Container(
            height: 22.h,
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
                      padding: EdgeInsets.all(2.w),
                      child: Text(
                        'Change Your Name'.tr(),
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      initialValue: name,
                      onChanged: (value) {
                        String trimmedValue = value.trim();
                        name = trimmedValue;
                      },
                      autofocus: true,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(right: 15, left: 15),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 20),
                    ),
                    if (newName.isEmpty && validate == true)
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Please! Enter your name'.tr(),
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      )
                    else
                      Container(),
                    TextButton(
                      onPressed: () async {
                        vibrateForAhalfSeconds();
                        newName = name;
                        newName.isEmpty ? validate = true : validate = false;
                        if (newName.isNotEmpty) {
                          nameProvider.editName(newName);
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            validate = true;
                          });
                        }
                      },
                      child: Text(
                        'Save'.tr(),
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
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

// void editName(BuildContext context) {
//   bool validate = false;
//   String newName = '';

//   showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.transparent,
//     isScrollControlled: true,
//     builder: (context) {
//       return StatefulBuilder(builder: (context, setState) {
//         final nameProvider = Provider.of<NameNotifier>(context);
//         var name = nameProvider.name;
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 1.w,
//             right: 1.w,
//           ),
//           child: Container(
//             height: 22.h,
//             decoration: BoxDecoration(
//               color: Theme.of(context).canvasColor,
//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(30),
//               ),
//             ),
//             child: Container(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: Padding(
//                 padding: EdgeInsets.all(5.w),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.all(2.w),
//                       child: Text(
//                         'Change Your Name'.tr(),
//                         style: TextStyle(
//                             fontSize: 20.sp, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TextFormField(
//                       initialValue: name,
//                       onChanged: (value) {
//                         String trimmedValue = value.trim();
//                         name = trimmedValue;
//                       },
//                       autofocus: true,
//                       enableSuggestions: false,
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.only(right: 15, left: 15),
//                         border: InputBorder.none,
//                       ),
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     if (newName.isEmpty && validate == true)
//                       Container(
//                         alignment: Alignment.topLeft,
//                         child: Text(
//                           'Please! Enter your name'.tr(),
//                           style: TextStyle(
//                             color: Colors.red,
//                           ),
//                         ),
//                       )
//                     else
//                       Container(),
//                     TextButton(
//                       onPressed: () async {
//                         vibrateForAhalfSeconds();
//                         newName = name;
//                         newName.isEmpty ? validate = true : validate = false;
//                         if (newName.isNotEmpty) {
//                           nameProvider.editName(newName);
//                           Navigator.pop(context);
//                         } else {
//                           setState(() {
//                             validate = true;
//                           });
//                         }
//                       },
//                       child: Text(
//                         'Save'.tr(),
//                         style: TextStyle(
//                             fontSize: 18.sp, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       });
//     },
//   );
// }
