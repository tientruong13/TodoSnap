// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/component/colorpicker/color_picker_builder.dart';
import 'package:task_app/component/iconpicker/icon_picker_builder.dart';
import 'package:task_app/widget/animated_bottom_to_top_widget.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';
import 'package:task_app/widget/custom_dialog.dart';
import 'package:task_app/widget/font_size.dart';

void editTask(
  BuildContext context, {
  required String taskId,
  required String title,
  required Color color,
  required IconData icon,
  required TaskModel task,
}) {
  // final taskProvider = Provider.of<TaskDataProvider>(context, listen: false);
  // TextEditingController textController = TextEditingController();
  bool validate = false;
  late Color taskColor;
  late IconData taskIcon;
  String newTitle = '';

  taskColor = color;
  taskIcon = icon;

  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          final taskProvider =
              Provider.of<TaskDataProvider>(context, listen: false);
          final subTaskProvider = Provider.of<SubTaskDataProvider>(context);
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
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
                        child: OpacytiWidget(
                          number: 1,
                          child: Text(
                            'Edit List'.tr(),
                            style: TextStyleUtils.headingBottomSheet,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 90.w,
                        child: BottomToTopWidget(
                          index: 1,
                          child: TextFormField(
                            initialValue: title,
                            onChanged: (value) {
                              String trimmedValue = value.trim();
                              title = trimmedValue;
                            },
                            cursorColor: taskColor,
                            autofocus: true,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              hintText: 'Add A New List'.tr(),
                              contentPadding:
                                  EdgeInsets.only(right: 15, left: 15),
                              border: InputBorder.none,
                            ),
                            style: TextStyleUtils.addTaskandSubtask,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      if (newTitle.isEmpty && validate == true)
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
                                  onColorChanged: (newColor) =>
                                      setState(() => taskColor = newColor)),
                              SizedBox(
                                width: 3.w,
                              ),
                              IconPickerBuilder(
                                  iconData: taskIcon,
                                  highlightColor: taskColor,
                                  action: (newIcon) =>
                                      setState(() => taskIcon = newIcon)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          vibrateFor1Second();
                          newTitle = title;
                          newTitle.isEmpty ? validate = true : validate = false;
                          if (newTitle.isNotEmpty) {
                            taskProvider.editTask(
                                id: taskId,
                                toEditedTask: TaskModel(
                                    title: newTitle,
                                    codePoint: taskIcon.codePoint,
                                    color: taskColor.value,
                                    id: taskId,
                                    indexId: taskProvider.totalTasks));
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              validate == true;
                            });
                          }
                        },
                        child: BottomToTopWidget(
                          index: 3,
                          child: Container(
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
                ),
                Positioned(
                  top: 4.w,
                  right: 4.w,
                  child: BottomToTopWidget(
                    index: 4,
                    child: IconButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BottomToTopWidget(
                                index: 1,
                                child: CustomDialog(
                                  onPressed: () {
                                    vibrateForAhalfSeconds();
                                    taskProvider.deleteTask(
                                        task, subTaskProvider);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            });
                      },
                      icon: Icon(
                        Ionicons.trash,
                        size: 6.w,
                        color: Colors.red,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
      });
}
