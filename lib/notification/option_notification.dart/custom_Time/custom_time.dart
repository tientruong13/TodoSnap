// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Page/Setting/provider/setting_provider.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';

class CustomTime extends StatefulWidget {
  const CustomTime({
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
  State<CustomTime> createState() => _CustomTimeState();
}

class _CustomTimeState extends State<CustomTime> {
  DateTime currentDate = DateTime.now();
  DateTime? eventDate;
  TimeOfDay currentTime = TimeOfDay.now();
  TimeOfDay? eventTime;

  @override
  void initState() {
    super.initState();

    // Initialize eventDate and eventTime to the existing values in the subTask, or the current date/time if they are null
    eventDate = widget.subTask.eventDate ?? currentDate;
    eventTime = widget.subTask.eventTime ?? currentTime;
  }

  @override
  Widget build(BuildContext context) {
    final subTaskProvider =
        Provider.of<SubTaskDataProvider>(context, listen: false);
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
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  final today = DateTime(
                      currentDate.year, currentDate.month, currentDate.day);
                  // DateTime initialTime = today;
                  // eventDate = DateTime(
                  //     initialTime.year, initialTime.month, initialTime.day);
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
                      child: Padding(
                        padding: EdgeInsets.all(2.w),
                        child: Column(
                          children: [
                            Expanded(
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                minimumDate: today,
                                maximumDate: DateTime(currentDate.year + 10),
                                initialDateTime: eventDate,
                                onDateTimeChanged: (val) => eventDate =
                                    DateTime(val.year, val.month, val.day),
                              ),
                            ),
                            TextButton(
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
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: OpacytiWidget(
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
                  DateFormat(settingProvider.selectedDateFormat!.format,
                          Localizations.localeOf(context).toString())
                      .format(eventDate!),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
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
              // If no event date has been set or the event date is in the past, set event date and time to now
              if (eventDate == null ||
                  eventDate!.isBefore(DateTime(now.year, now.month, now.day))) {
                eventDate = DateTime(now.year, now.month, now.day);
                eventTime =
                    TimeOfDay.fromDateTime(now.add(Duration(minutes: 1)));
              }

              // else, if no event time has been set or the event time is in the past, set event time to now
              else if (eventTime == null ||
                  DateTime(eventDate!.year, eventDate!.month, eventDate!.day,
                          eventTime!.hour, eventTime!.minute)
                      .isBefore(now)) {
                eventTime =
                    TimeOfDay.fromDateTime(now.add(Duration(minutes: 1)));
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
                width: 100.w,
                height: 5.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade500.withOpacity(0.2),
                ),
                padding: EdgeInsets.all(3.w),
                child: Text(
                  eventTime!.format(context),
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
                if (eventDate != null && eventTime != null) {
                  // Construct the DateTime from the selected eventDate and eventTime
                  DateTime futureDate = DateTime(
                    eventDate!.year,
                    eventDate!.month,
                    eventDate!.day,
                    eventTime!.hour,
                    eventTime!.minute,
                  );

                  // Update the existing SubTaskModel instance
                  widget.subTask.eventDate = futureDate;
                  widget.subTask.eventTime = TimeOfDay(
                      hour: futureDate.hour, minute: futureDate.minute);
                  subTaskProvider.updateSubTask(widget.subTask);

                  // Create the payload using the subTask's ID
                  String payload = widget.subTask.id;
                  // print('id: $payload');

                  // Schedule the notification
                  subTaskProvider.createSubTaskNotification(
                    widget.subTask,
                    widget.task,
                    payload,
                  );

                  Navigator.pop(context);
                } else {
                  print('Please select both date and time.');
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
