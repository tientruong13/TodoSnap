// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Page/Setting/provider/setting_provider.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';

enum DayOfMonth {
  Day1,
  Day2,
  Day3,
  Day4,
  Day5,
  Day6,
  Day7,
  Day8,
  Day9,
  Day10,
  Day11,
  Day12,
  Day13,
  Day14,
  Day15,
  Day16,
  Day17,
  Day18,
  Day19,
  Day20,
  Day21,
  Day22,
  Day23,
  Day24,
  Day25,
  Day26,
  Day27,
  Day28,
  Day29,
  Day30,
  Day31
}

String dayOfMonthToString(DayOfMonth day) {
  switch (day) {
    case DayOfMonth.Day1:
      return 'Once a month on the 1';
    case DayOfMonth.Day2:
      return 'Once a month on the 2';
    case DayOfMonth.Day3:
      return 'Once a month on the 3';
    case DayOfMonth.Day4:
      return 'Once a month on the 4';
    case DayOfMonth.Day5:
      return 'Once a month on the 5';
    case DayOfMonth.Day6:
      return 'Once a month on the 6';
    case DayOfMonth.Day7:
      return 'Once a month on the 7';
    case DayOfMonth.Day8:
      return 'Once a month on the 8';
    case DayOfMonth.Day9:
      return 'Once a month on the 9';
    case DayOfMonth.Day10:
      return 'Once a month on the 10';
    case DayOfMonth.Day11:
      return 'Once a month on the 11';
    case DayOfMonth.Day12:
      return 'Once a month on the 12';
    case DayOfMonth.Day13:
      return 'Once a month on the 13';
    case DayOfMonth.Day14:
      return 'Once a month on the 14';
    case DayOfMonth.Day15:
      return 'Once a month on the 15';
    case DayOfMonth.Day16:
      return 'Once a month on the 16';
    case DayOfMonth.Day17:
      return 'Once a month on the 17';
    case DayOfMonth.Day18:
      return 'Once a month on the 18';
    case DayOfMonth.Day19:
      return 'Once a month on the 19';
    case DayOfMonth.Day20:
      return 'Once a month on the 20';
    case DayOfMonth.Day21:
      return 'Once a month on the 21';
    case DayOfMonth.Day22:
      return 'Once a month on the 22';
    case DayOfMonth.Day23:
      return 'Once a month on the 23';
    case DayOfMonth.Day24:
      return 'Once a month on the 24';
    case DayOfMonth.Day25:
      return 'Once a month on the 25';
    case DayOfMonth.Day26:
      return 'Once a month on the 26';
    case DayOfMonth.Day27:
      return 'Once a month on the 27';
    case DayOfMonth.Day28:
      return 'Once a month on the 28';
    case DayOfMonth.Day29:
      return 'Once a month on the 29';
    case DayOfMonth.Day30:
      return 'Once a month on the 30';
    case DayOfMonth.Day31:
      return 'Once a month on the 31';
    default:
      return 'Day ${day.index + 1}';
  }
}

class MonthlyTime extends StatefulWidget {
  const MonthlyTime({
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
  State<MonthlyTime> createState() => _MonthlyTimeState();
}

class _MonthlyTimeState extends State<MonthlyTime> {
  DateTime currentDate = DateTime.now();
  DayOfMonth? selectedDay;
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
      selectedDay = _intToDayOfMonth(eventDateTime!.day);
    } else {
      // Default to Monday if eventDate or eventTime is null
      selectedDay = DayOfMonth.Day1;
    }
    eventTime = widget.subTask.eventTime ?? currentTime;
  }

  DayOfMonth _intToDayOfMonth(int dayOfMonthInt) {
    // Be aware that DateTime.weekday returns 1 for Monday and 7 for Sunday
    // So we subtract 1 to match your enum where Monday is 0
    return DayOfMonth.values[dayOfMonthInt - 1];
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
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  FixedExtentScrollController scrollController =
                      FixedExtentScrollController(
                    initialItem: DayOfMonth.values.indexOf(selectedDay!),
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
                                    selectedDay = DayOfMonth.values[index];
                                  });
                                },
                                children: DayOfMonth.values.map((day) {
                                  return Text(dayOfMonthToString(day));
                                }).toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () {
                                  vibrateForAhalfSeconds();
                                  setState(() {
                                    selectedDay = DayOfMonth
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
                  dayOfMonthToString(selectedDay ?? DayOfMonth.Day1),
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
          //     child: DropdownButton<DayOfMonth>(
          //       hint: Text(
          //         "Select Your Day",
          //         style: TextStyle(
          //           fontSize: 16.sp,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.black,
          //         ),
          //       ),
          //       menuMaxHeight: 50.h,
          //       underline: Container(),
          //       iconSize: 0.0,
          //       style: TextStyle(
          //         fontSize: 16.sp,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.black,
          //       ),
          //       value: selectedDay,
          //       onChanged: (DayOfMonth? newValue) {
          //         setState(() {
          //           selectedDay = newValue!;
          //         });
          //       },
          //       items: DayOfMonth.values
          //           .map<DropdownMenuItem<DayOfMonth>>((DayOfMonth value) {
          //         return DropdownMenuItem<DayOfMonth>(
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
                // Construct the DateTime from the selected eventDate and eventTime
                DateTime futureTime = DateTime(
                  currentDate.year,
                  currentDate.month,
                  selectedDay!.index +
                      1, // This should be the selected day of the month
                  eventTime!.hour,
                  eventTime!.minute,
                );

                // If the constructed date is in the past, set the futureTime to be next month
                if (futureTime.isBefore(DateTime.now())) {
                  futureTime = DateTime(futureTime.year, futureTime.month + 1,
                      futureTime.day, futureTime.hour, futureTime.minute);
                }

                // Update the existing SubTaskModel instance
                widget.subTask.eventDate = futureTime;
                widget.subTask.eventTime =
                    TimeOfDay(hour: futureTime.hour, minute: futureTime.minute);
                subTaskProvider.updateSubTask(widget.subTask);

                // Create the payload using the subTask's ID
                String payload = widget.subTask.id;

                // Schedule the notification
                subTaskProvider.createMonthlyNotification(
                  widget.subTask,
                  widget.task,
                  selectedDay!.index +
                      1, // selectedDay (now it's DayOfMonth, so this corresponds to the day of the month)
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
