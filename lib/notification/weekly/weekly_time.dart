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

enum DayOfWeek {
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  Sunday,
}

String dayOfWeekToString(DayOfWeek day) {
  switch (day) {
    case DayOfWeek.Monday:
      return 'Once a week on Monday';
    case DayOfWeek.Tuesday:
      return 'Once a week on Tuesday';
    case DayOfWeek.Wednesday:
      return 'Once a week on Wednesday';
    case DayOfWeek.Thursday:
      return 'Once a week on Thursday';
    case DayOfWeek.Friday:
      return 'Once a week on Friday';
    case DayOfWeek.Saturday:
      return 'Once a week on Saturday';
    case DayOfWeek.Sunday:
      return 'Once a week on Sunday';
    default:
      return 'Day ${day.index + 1}';
  }
}

class WeeklyTime extends StatefulWidget {
  const WeeklyTime({
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
  State<WeeklyTime> createState() => _WeeklyTimeState();
}

class _WeeklyTimeState extends State<WeeklyTime> {
  DateTime currentDate = DateTime.now();
  DayOfWeek? selectedDay;

  TimeOfDay currentTime = TimeOfDay.now();
  TimeOfDay? eventTime;
  DateTime? eventDateTime;

  @override
  void initState() {
    super.initState();

    if (widget.subTask.eventDate != null && widget.subTask.eventTime != null) {
      eventDateTime = DateTime(
        widget.subTask.eventDate!.year,
        widget.subTask.eventDate!.month,
        widget.subTask.eventDate!.day,
        widget.subTask.eventTime!.hour,
        widget.subTask.eventTime!.minute,
      );
      // Convert DateTime to DayOfWeek
      selectedDay = _intToDayOfWeek(eventDateTime!.weekday);
    } else {
      // Default to Monday if eventDate or eventTime is null
      selectedDay = DayOfWeek.Monday;
    }
    eventTime = widget.subTask.eventTime ?? currentTime;
  }

  DayOfWeek _intToDayOfWeek(int dayOfWeekInt) {
    // Be aware that DateTime.weekday returns 1 for Monday and 7 for Sunday
    // So we subtract 1 to match your enum where Monday is 0
    return DayOfWeek.values[dayOfWeekInt - 1];
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
    // FixedExtentScrollController scrollController = FixedExtentScrollController(
    //   initialItem: DayOfWeek.values.indexOf(selectedDay!),
    // );
    return SizedBox(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  FixedExtentScrollController scrollController =
                      FixedExtentScrollController(
                    initialItem: DayOfWeek.values.indexOf(selectedDay!),
                  );
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
                              child: CupertinoPicker(
                                scrollController: scrollController,
                                diameterRatio: 1.1,
                                itemExtent: 32.0,
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    selectedDay = DayOfWeek.values[index];
                                  });
                                },
                                children: DayOfWeek.values.map((day) {
                                  return Text(day.toString().split('.').last);
                                }).toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () {
                                  vibrateForAhalfSeconds();
                                  setState(() {
                                    selectedDay = DayOfWeek
                                        .values[scrollController.selectedItem];
                                  });
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
                  dayOfWeekToString(selectedDay ?? DayOfWeek.Monday),
                  // eventDate == null
                  //     ? "Select Your Day".tr()
                  //     : DateFormat(settingProvider.selectedDateFormat!.format,
                  //             Localizations.localeOf(context).toString())
                  //         .format(eventDate!),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // OpacytiWidget(
          //   number: 1,
          //   child: Container(
          //     padding: EdgeInsets.only(left: 3.w),
          //     height: 5.h,
          //     width: 100.w,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(15),
          //       color: Colors.grey.shade500.withOpacity(0.2),
          //     ),
          //     child: DropdownButton<DayOfWeek>(
          //       hint: Text(
          //         "Select Your Day",
          //         style: TextStyle(
          //           fontSize: 16.sp,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.black,
          //         ),
          //       ),
          //       underline: Container(),
          //       iconSize: 0.0,
          //       style: TextStyle(
          //         fontSize: 16.sp,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.black,
          //       ),
          //       value: selectedDay,
          //       onChanged: (DayOfWeek? newValue) {
          //         setState(() {
          //           selectedDay = newValue!;
          //         });
          //       },
          //       items: DayOfWeek.values
          //           .map<DropdownMenuItem<DayOfWeek>>((DayOfWeek value) {
          //         return DropdownMenuItem<DayOfWeek>(
          //           value: value,
          //           child: Text(value.toString().split('.').last),
          //         );
          //       }).toList(),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 3.w,
          ),
          GestureDetector(
            onTap: () async {
              vibrateForAhalfSeconds();
              DateTime now = DateTime.now();
              DateTime initialTime = DateTime(now.year, now.month, now.day,
                  eventTime!.hour, eventTime!.minute);
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
                              initialDateTime: initialTime,
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
              if (selectedDay != null && eventTime != null) {
                // Calculate the start of the week (Monday)
                DateTime startOfWeek = currentDate
                    .subtract(Duration(days: currentDate.weekday - 1));

                // Construct the DateTime from the startOfWeek and the selectedDay
                DateTime futureTime = DateTime(
                  startOfWeek.year,
                  startOfWeek.month,
                  startOfWeek.day +
                      selectedDay!
                          .index, // Add the selectedDay index to represent the correct day of the week
                  eventTime!.hour,
                  eventTime!.minute,
                );

                // Update the existing SubTaskModel instance
                widget.subTask.eventDate = futureTime;
                widget.subTask.eventTime =
                    TimeOfDay(hour: futureTime.hour, minute: futureTime.minute);
                subTaskProvider.updateSubTask(widget.subTask);

                // Create the payload using the subTask's ID
                String payload = widget.subTask.id;

                // Schedule the notification
                subTaskProvider.createWeeklyNotification(
                  widget.subTask,
                  widget.task,
                  selectedDay!.index + 1, // selectedDay
                  payload,
                );

                Navigator.pop(context);
              } else {
                print('Please select both day and time.');
              }
            },
            child: OpacytiWidget(
              number: 1,
              child: Text(
                'Save'.tr(),
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
          )
        ],
      ),
    );
  }
}
