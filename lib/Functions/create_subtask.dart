import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/add_image/image_page.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Page/Setting/provider/setting_provider.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/widget/animated_bottom_to_top_widget.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';
import 'package:task_app/widget/font_size.dart';

void createSubTask(BuildContext context, {required TaskModel task}) {
  final subTaskProvider =
      Provider.of<SubTaskDataProvider>(context, listen: false);
  final taskProvider = Provider.of<TaskDataProvider>(context, listen: false);
  var _task = taskProvider.getTaskList.firstWhere((it) => it.id == task.id);

  TextEditingController subTaskController = TextEditingController();
  TextEditingController subTaskDetailController = TextEditingController();
  bool validate = false;

  bool datePicked = false;
  DateTime? newDate;
  DateTime? eventDate;
  TimeOfDay? eventTime;
  // SubTaskModel? subTask;
  // String _subTaskTitle = '';
  List<String> tempImagePaths = [];

  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          // final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
          //     GlobalKey<ScaffoldMessengerState>();

          // final taskProvider =
          //     Provider.of<TaskDataProvider>(context, listen: false);

          showImagePicker() async {
            String? imagePath = await subTaskProvider.addImage(context);
            if (imagePath != null) {
              tempImagePaths.add(imagePath);
              setState(() {}); // Update the UI with the new image path
            }
          }

          void _dateTimePicker() {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                final today = DateTime.now();
                DateTime initialTime = newDate ?? today;
                newDate = DateTime(
                    initialTime.year, initialTime.month, initialTime.day);
                datePicked = true;
                return Container(
                  width: 100.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.all(2.w),
                      child: Column(
                        children: [
                          Expanded(
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              minimumDate: initialTime,
                              maximumDate: DateTime(newDate!.year + 10),
                              initialDateTime: initialTime,
                              onDateTimeChanged: (val) => setState(() {
                                newDate =
                                    DateTime(val.year, val.month, val.day);
                                // datePicked = true;
                              }),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              vibrateForAhalfSeconds();
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Save'.tr(),
                              style: TextStyle(
                                  fontSize: 18.sp, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          // void _dateTimePicker() {
          //   BottomPicker.date(
          //     pickerTextStyle: Theme.of(context)
          //         .textTheme
          //         .titleMedium!
          //         .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
          //     title: 'Pick Your Date'.tr(),
          //     titleStyle: Theme.of(context)
          //         .textTheme
          //         .titleLarge!
          //         .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
          //     onChange: (index) => setState(() {
          //       newDate = index;
          //       val = true;
          //     }),
          //     iconColor: Colors.white,
          //     minDateTime: newDate,
          //     maxDateTime: DateTime(2123, 1, 1),
          //     initialDateTime: newDate,
          //     buttonSingleColor: Colors.black,
          //   ).show(context);
          // }

          // void _update(value) {
          //   setState(() {
          //     _subTaskTitle = value;
          //     // print('$_subTaskTitle');
          //   });
          // }

          SubTaskModel tempSubTask = SubTaskModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            detail: subTaskDetailController.text,
            title: subTaskController.text,
            parent: _task.id,
            date: newDate ?? DateTime.now(),
            imagePaths: tempImagePaths,
          );
          final settingProvider = Provider.of<SettingProvider>(context);
          String datePicker = DateFormat(
                  settingProvider.selectedDateFormat?.format,
                  Localizations.localeOf(context).toString())
              .format(newDate ?? DateTime.now());
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            height: 90.h,
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
                        padding: EdgeInsets.only(top: 7.w),
                        child: OpacytiWidget(
                          number: 1,
                          child: Text(
                            'New Task'.tr(),
                            style: TextStyleUtils.headingBottomSheet,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      if (subTaskController.text.isEmpty && validate == true)
                        Container(
                          padding: EdgeInsets.only(left: 10.w),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Please! Enter your task.'.tr(),
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 2.h,
                        ),
                      SizedBox(
                        width: 90.w,
                        child: BottomToTopWidget(
                          index: 1,
                          child: TextFormField(
                            controller: subTaskController,
                            maxLines: 1,
                            // cursorColor: taskColor,
                            // onChanged: (value) {
                            //   _update(value);
                            //   // print('$value');
                            // },
                            autofocus: true,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              hintText: 'Add A New Task'.tr(),
                              contentPadding:
                                  EdgeInsets.only(right: 15, left: 15),
                              border: InputBorder.none,
                            ),
                            style: TextStyleUtils.addTaskandSubtask,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.w,
                      ),
                      SizedBox(
                        width: 90.w,
                        child: BottomToTopWidget(
                          index: 2,
                          child: TextFormField(
                            controller: subTaskDetailController,
                            maxLines: 3,
                            // cursorColor: taskColor,
                            autofocus: true,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              hintText: 'Add Details'.tr(),
                              contentPadding:
                                  EdgeInsets.only(right: 15, left: 15),
                              border: InputBorder.none,
                            ),
                            style: TextStyleUtils.addTaskandSubtask,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 2.w, left: 5.w, right: 5.w, bottom: 22.w),
                          child: BottomToTopWidget(
                            index: 3,
                            child: ImageGridViewForAdd(
                              imagePaths: tempImagePaths,
                              subTask: tempSubTask,
                              onDelete: (index, tempSubTask) async {
                                vibrateForAhalfSeconds();
                                await subTaskProvider.deleteImage(
                                    index, tempSubTask);
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      BottomToTopWidget(
                        index: 4,
                        child: Container(
                          padding: EdgeInsets.only(left: 3.w),
                          height: 12.w,
                          width: 100.w,
                          color: Theme.of(context).canvasColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              datePicked == false
                                  ? IconButton(
                                      onPressed: () {
                                        vibrateForAhalfSeconds();
                                        _dateTimePicker();
                                      },
                                      icon: Icon(
                                        Ionicons.calendar_number,
                                        size: 7.w,
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        vibrateForAhalfSeconds();
                                        _dateTimePicker();
                                      },
                                      child: Text('$datePicker'),
                                      style: TextButton.styleFrom(
                                          primary: Color(_task.color),
                                          textStyle:
                                              TextStyle(fontSize: 18.sp)),
                                    ),
                              IconButton(
                                  onPressed: () {
                                    vibrateForAhalfSeconds();
                                    showImagePicker();
                                  },
                                  icon: Icon(
                                    Ionicons.image,
                                    size: 7.w,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          vibrateFor1Second();
                          if (subTaskController.text.isNotEmpty) {
                            SubTaskModel newSubTask = SubTaskModel(
                              detail: subTaskDetailController.text,
                              title: subTaskController.text,
                              parent: _task.id,
                              date: newDate ?? DateTime.now(),
                              imagePaths: tempImagePaths,
                              eventDate: eventDate,
                              eventTime: eventTime,
                            );

                            subTaskProvider.addSubTask(newSubTask);

                            Navigator.pop(context);
                          } else {
                            setState(() {
                              validate = true;
                            });
                          }
                        },
                        child: BottomToTopWidget(
                          index: 5,
                          child: Container(
                            // padding: EdgeInsets.all(12),
                            height: 12.w,
                            width: 100.w,
                            decoration:
                                BoxDecoration(color: Color(_task.color)),
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
