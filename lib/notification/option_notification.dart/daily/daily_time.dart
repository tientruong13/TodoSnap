// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Page/Setting/provider/setting_provider.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';

class DailyTime extends StatefulWidget {
  const DailyTime({
    Key? key,
    required this.task,
    required this.subTask,
    // required this.eventDate,
    // required this.eventTime,
  }) : super(key: key);

  final TaskModel task;
  final SubTaskModel subTask;

  // final DateTime eventDate;
  // final TimeOfDay eventTime;
  @override
  State<DailyTime> createState() => _DailyTimeState();
}

class _DailyTimeState extends State<DailyTime> {
  DateTime currentDate = DateTime.now();
  DateTime? eventDate;
  TimeOfDay currentTime = TimeOfDay.now();
  TimeOfDay? eventTime;

  @override
  void initState() {
    super.initState();

    // Initialize eventDate and eventTime to the existing values in the subTask, or the current date/time if they are null

    eventTime = widget.subTask.eventTime ?? currentTime;
  }

  @override
  Widget build(BuildContext context) {
    final subTaskProvider =
        Provider.of<SubTaskDataProvider>(context, listen: false);
    // ignore: unused_local_variable
    final settingProvider = Provider.of<SettingProvider>(context);
    // final taskProvider = Provider.of<TaskDataProvider>(context, listen: false);
    // var _task =
    //     taskProvider.getTaskList.firstWhere((it) => it.id == widget.task.id);
    // var _subTask = subTaskProvider.getSubTasksListBySort
    //     .where((it) => it.parent == widget.task.id)
    //     .toList();

    return SizedBox(
      child: Column(
        children: [
          OpacytiWidget(
            number: 1,
            child: Container(
              width: 100.w,
              height: 5.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade500.withOpacity(0.2),
              ),
              padding: EdgeInsets.all(3.w),
              child: Text(
                'Every Day',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 3.w,
          ),
          GestureDetector(
            onTap: () async {
              vibrateForAhalfSeconds();
              DateTime now = DateTime.now();
              // If eventTime has never been set, initialize it to current time + 1 minute
              if (eventTime == null) {
                DateTime initialTime = now.add(Duration(minutes: 1));
                eventTime = TimeOfDay.fromDateTime(initialTime);
              } else {
                DateTime initialTime = DateTime(now.year, now.month, now.day,
                    eventTime!.hour, eventTime!.minute);
                eventTime = TimeOfDay.fromDateTime(initialTime);
              }
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    width: 100.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                        // borderRadius: BorderRadius.vertical(
                        //   top: Radius.elliptical(200, 70),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Expanded(
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: DateTime(
                                now.year,
                                now.month,
                                now.day,
                                eventTime!.hour,
                                eventTime!.minute,
                              ),
                              onDateTimeChanged: (val) =>
                                  eventTime = TimeOfDay.fromDateTime(val),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {
                                vibrateForAhalfSeconds();
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Save'.tr(),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: OpacytiWidget(
              number: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade500.withOpacity(0.2),
                ),
                padding: EdgeInsets.all(3.w),
                child: Text(
                  eventTime == null
                      ? "Select Your Time".tr()
                      : eventTime!.format(context),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.w),
          TextButton(
              onPressed: () async {
                vibrateForAhalfSeconds();
                if (eventTime != null) {
                  // Construct the DateTime from today's date and the selected eventTime
                  DateTime futureTime = DateTime(
                    currentDate.year,
                    currentDate.month,
                    currentDate.day,
                    eventTime!.hour,
                    eventTime!.minute,
                  );

                  // If the constructed time is in the past, set the futureTime to be tomorrow
                  if (futureTime.isBefore(DateTime.now())) {
                    futureTime = DateTime(futureTime.year, futureTime.month,
                        futureTime.day + 1, futureTime.hour, futureTime.minute);
                  }

                  // Update the existing SubTaskModel instance with the selected date-time
                  widget.subTask.eventDate = futureTime;
                  widget.subTask.eventTime = TimeOfDay(
                      hour: futureTime.hour, minute: futureTime.minute);
                  subTaskProvider.updateSubTask(widget.subTask);

                  // Create the payload using the subTask's ID
                  String payload = widget.subTask.id;

                  // Schedule the daily notification
                  subTaskProvider.createDailyNotification(
                    widget.subTask,
                    widget.task,
                    payload,
                  );
                  print('futureTime: $futureTime');
                  print('subTask eventDate: ${widget.subTask.eventDate}');
                  print('subTask eventTime: ${widget.subTask.eventTime}');
                  Navigator.pop(context);
                } else {
                  print('Please select a time.');
                }
              },
              child: OpacytiWidget(
                number: 1,
                child: Text(
                  'Save'.tr(),
                  style: TextStyle(fontSize: 18.sp),
                ),
              ))
        ],
      ),
    );
  }
}
