import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/component/colorpicker/color_picker_builder.dart';
import 'package:task_app/component/iconpicker/icon_picker_builder.dart';
import 'package:task_app/widget/animated_bottom_to_top_widget.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';
import 'package:task_app/widget/color_utils.dart';
import 'package:task_app/widget/font_size.dart';

import 'option/vibration.dart';

void createTask(BuildContext context) {
  TextEditingController textController = TextEditingController();
  late Color taskColor = ColorUtils.defaultColors[0];
  late IconData taskIcon = Icons.work;
  bool validate = false;
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          final taskProvider =
              Provider.of<TaskDataProvider>(context, listen: false);
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            height: 70.h,
            width: double.infinity,
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                      // borderRadius: BorderRadius.vertical(
                      //   top: Radius.elliptical(200, 70),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
                        child: OpacytiWidget(
                          number: 1,
                          child: Text(
                            'New List'.tr(),
                            style: TextStyleUtils.headingBottomSheet,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 90.w,
                        child: BottomToTopWidget(
                          index: 1,
                          child: TextFormField(
                              controller: textController,
                              cursorColor: taskColor,
                              autofocus: true,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                hintText: 'Add A New List'.tr(),
                                contentPadding:
                                    EdgeInsets.only(right: 15, left: 15),
                                border: InputBorder.none,
                              ),
                              style: TextStyleUtils.addTaskandSubtask),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      if (textController.text.isEmpty && validate == true)
                        Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              Text(
                                'Please! Enter your list.'.tr(),
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(),
                      BottomToTopWidget(
                        index: 2,
                        child: Container(
                          padding: EdgeInsets.only(left: 5.w, bottom: 1.w),
                          height: 6.h,
                          width: 100.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ColorPickerBuilder(
                                  color: taskColor,
                                  onColorChanged: (newColor) {
                                    vibrateForAhalfSeconds();
                                    setState(() => taskColor = newColor);
                                  }),
                              SizedBox(
                                width: 3.w,
                              ),
                              IconPickerBuilder(
                                  iconData: taskIcon,
                                  highlightColor: taskColor,
                                  action: (newIcon) {
                                    vibrateForAhalfSeconds();
                                    setState(() => taskIcon = newIcon);
                                  }),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          vibrateFor1Second();
                          if (textController.text.isNotEmpty) {
                            taskProvider.addTask(TaskModel(
                                title: textController.text,
                                codePoint: taskIcon.codePoint,
                                color: taskColor.value,
                                indexId: taskProvider.totalTasks));
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              validate = true;
                            });
                          }
                        },
                        child: BottomToTopWidget(
                          index: 3,
                          child: Container(
                            // padding: EdgeInsets.all(12),
                            height: 6.h,
                            width: 110.w,
                            decoration: BoxDecoration(color: taskColor),
                            child: Center(
                              child: Text(
                                '+',
                                style: TextStyleUtils.addButtom,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
      });
}

// class CreateTask extends StatefulWidget {
//   CreateTask({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<CreateTask> createState() => _CreateTaskState();
// }

// class _CreateTaskState extends State<CreateTask> {
//   late Color taskColor = ColorUtils.defaultColors[0];
//   late IconData taskIcon = Icons.work;
//   TextEditingController textController = TextEditingController();
//   bool validate = false;

//   @override
//   Widget build(BuildContext context) {
//     final taskProvider = Provider.of<TaskDataProvider>(context, listen: false);

//     return SimpleDialog(
//       contentPadding: EdgeInsets.only(top: 10),
//       // titlePadding: EdgeInsets.all(10),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20.0),
//       ),
//       title: Text(
//         'Add Task',
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//         textAlign: TextAlign.center,
//       ),
//       children: [
//         TextFormField(
//           controller: textController,
//           maxLines: null,
//           cursorColor: taskColor,
//           autofocus: true,
//           enableSuggestions: false,
//           decoration: InputDecoration(
//             contentPadding: EdgeInsets.only(right: 15, left: 15),
//             hintText: 'Add a new task',
//             border: InputBorder.none,
//           ),
//           style: TextStyle(fontSize: 20),
//         ),
//         SizedBox(
//           height: 5,
//         ),
//         Padding(
//           padding: const EdgeInsets.all(5.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text('Colors', style: TextStyle(fontWeight: FontWeight.bold)),
//                   Text(
//                     'Icons',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ColorPickerBuilder(
//                       color: taskColor,
//                       onColorChanged: (newColor) =>
//                           setState(() => taskColor = newColor)),
//                   IconPickerBuilder(
//                       iconData: taskIcon,
//                       highlightColor: taskColor,
//                       action: (newIcon) => setState(() => taskIcon = newIcon)),
//                 ],
//               )
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 5,
//         ),
//         if (textController.text.isEmpty && validate == true)
//           Container(
//             alignment: Alignment.center,
//             child: Column(
//               children: [
//                 Text(
//                   'Please! Enter your task.',
//                   style: TextStyle(
//                     color: Colors.red,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 )
//               ],
//             ),
//           )
//         else
//           Container(),
//         InkWell(
//           child: Container(
//             width: double.infinity,
//             padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
//             decoration: BoxDecoration(
//               color: taskColor,
//               borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(20.0),
//                   bottomRight: Radius.circular(20.0)),
//             ),
//             child: Text(
//               '+',
//               style: TextStyle(color: Colors.white, fontSize: 35),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           onTap: () async {
//             if (textController.text.isNotEmpty) {
//               taskProvider.addTask(TaskModel(
//                   title: textController.text,
//                   codePoint: taskIcon.codePoint,
//                   color: taskColor.value));
//               Navigator.pop(context);
//             } else {
//               setState(() {
//                 validate = true;
//               });
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
