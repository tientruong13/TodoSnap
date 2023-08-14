import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/notification/option_notification.dart/custom_Time/custom_time.dart';
import 'package:task_app/widget/animated_bottom_to_top_widget.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';

class CreateReminderOptions extends StatefulWidget {
  const CreateReminderOptions({
    Key? key,
    required this.task,
    required this.subTask,
  }) : super(key: key);
  final TaskModel task;
  final SubTaskModel subTask;

  @override
  State<CreateReminderOptions> createState() => _CreateReminderOptionsState();
}

class _CreateReminderOptionsState extends State<CreateReminderOptions> {
  DateTime currentDate = DateTime.now();
  DateTime? eventDate;
  // TaskModel? task;
  TimeOfDay currentTime = TimeOfDay.now();
  TimeOfDay? eventTime;

  @override
  Widget build(BuildContext context) {
    // final subTaskProvider =
    //     Provider.of<SubTaskDataProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskDataProvider>(context, listen: false);
    var _task =
        taskProvider.getTaskList.firstWhere((it) => it.id == widget.task.id);
    // var _subTask = subTaskProvider.getSubTasksListBySort
    //     .where((it) => it.parent == widget.task.id)
    //     .toList();

    return BottomToTopWidget(
      index: 1,
      child: SimpleDialog(
        backgroundColor: Theme.of(context).canvasColor,
        // contentPadding: EdgeInsets.only(top: 10),
        // titlePadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title: Padding(
          padding: EdgeInsets.only(top: 1.w, bottom: 1.w),
          child: OpacytiWidget(
            number: 1,
            child: Text(
              'Reminders'.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w, right: 4.w),
            child: SizedBox(
              width: 90.w,
              height: 19.h,
              child: Column(
                children: [
                  CustomTime(
                    task: _task,
                    subTask: widget.subTask,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
