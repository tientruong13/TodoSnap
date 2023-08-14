import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/notification/option_notification.dart/custom_Time/custom_time.dart';
import 'package:task_app/notification/option_notification.dart/daily/daily_time.dart';
import 'package:task_app/notification/option_notification.dart/monthly/monthly_time.dart';
import 'package:task_app/notification/weekly/weekly_time.dart';
import 'package:task_app/widget/animated_bottom_to_top_widget.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';
import 'package:task_app/widget/utils.dart';

int getNotificationTypeIndex(NotificationType notificationType) {
  switch (notificationType) {
    case NotificationType.Custom:
      return 0;
    case NotificationType.Daily:
      return 1;
    case NotificationType.Weekly:
      return 2;
    case NotificationType.Monthly:
      return 3;
    default:
      return 0; // default value
  }
}

void selectOption(BuildContext context, TaskModel task, SubTaskModel subtask) {
  int _currentSelection = getNotificationTypeIndex(
      subtask.notificationType ?? NotificationType.Custom);
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        final subTaskProvider =
            Provider.of<SubTaskDataProvider>(context, listen: false);
        final taskProvider =
            Provider.of<TaskDataProvider>(context, listen: false);
        var _task =
            taskProvider.getTaskList.firstWhere((it) => it.id == task.id);
        final Map<int, Widget> _children = <int, Widget>{
          0: Text(
            'Custom',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          1: Text('Daily',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          2: Text('Weekly',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          3: Text('Monthly',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        };

        final Map<int, Widget> _containerChildren = <int, Widget>{
          0: CustomTime(
            task: _task,
            subTask: subtask,
          ), // For Row 1
          1: DailyTime(
            task: _task,
            subTask: subtask,
          ), // For Row 2
          2: WeeklyTime(
            task: _task,
            subTask: subtask,
          ), // For Row 3
          3: MonthlyTime(
            task: _task,
            subTask: subtask,
          ) // For Row 4
        };
        void cancelNotification() {
          subTaskProvider.cancelSubTaskNotification(subtask);
          Navigator.pop(context);
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 1.w,
            right: 1.w,
          ),
          child: Container(
            height: 38.h,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                      top: 1.h,
                      right: 5.w,
                      child: BottomToTopWidget(
                        index: 3,
                        child: IconButton(
                          onPressed: cancelNotification,
                          icon: Icon(
                            Ionicons.trash,
                            size: 6.w,
                            color: Colors.red,
                          ),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.all(5.w),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2.w),
                          child: BottomToTopWidget(
                            index: 1,
                            child: Text(
                              'Reminders'.tr(),
                              style: TextStyle(
                                  fontSize: 18.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        OpacytiWidget(number: 1, child: Divider()),
                        Padding(
                          padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                          child: BottomToTopWidget(
                            index: 2,
                            child: CupertinoSlidingSegmentedControl(
                              children: _children,
                              onValueChanged: (val) {
                                setState(() {
                                  _currentSelection = val!;
                                  subtask.notificationType = NotificationType
                                      .values[_currentSelection];
                                });
                              },
                              groupValue: _currentSelection,
                            ),
                          ),
                        ),
                        _containerChildren[_currentSelection] ?? Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}
