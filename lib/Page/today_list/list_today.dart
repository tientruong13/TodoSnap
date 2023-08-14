// ignore_for_file: unused_import

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Page/Setting/provider/setting_provider.dart';
import 'package:task_app/Page/home_page/home_page.dart';
import 'package:task_app/Page/home_page/task_title_and_icon.dart';
import 'package:task_app/Page/subtask_page/subtask_title.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';
import 'package:task_app/widget/animated_top_to_bottom_widget.dart';

class TodaysTasksAndSubTasks extends StatefulWidget {
  @override
  State<TodaysTasksAndSubTasks> createState() => _TodaysTasksAndSubTasksState();
}

class _TodaysTasksAndSubTasksState extends State<TodaysTasksAndSubTasks>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    // String toDay = DateFormat(settingProvider.selectedDateFormat!.format,
    //         Localizations.localeOf(context).toString())
    //     .format(tz.TZDateTime.now(tz.local));

    // String tomorrow = DateFormat(settingProvider.selectedDateFormat!.format,
    //         Localizations.localeOf(context).toString())
    //     .format(tz.TZDateTime.now(tz.local).add(Duration(days: 1)));

    String toDay = DateFormat(settingProvider.selectedDateFormat!.format,
            Localizations.localeOf(context).toString())
        .format(DateTime.now());
    String tomorrow = DateFormat(settingProvider.selectedDateFormat!.format,
            Localizations.localeOf(context).toString())
        .format(DateTime.now().add(Duration(days: 1)));
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
                child: TopToBottomWidget(
              index: 1,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 8.h),
                    height: 13.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(6.w),
                        bottomRight: Radius.circular(6.w),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3), //Color of Shadow
                          spreadRadius: 5, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            _onItemTapped(0);
                            vibrateForAhalfSeconds();
                          },
                          child: Text(
                            "Today".tr(),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: _selectedIndex == 0
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _onItemTapped(1);
                            vibrateForAhalfSeconds();
                          },
                          child: Text(
                            "Tomorrow".tr(),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: _selectedIndex == 1
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            Column(
              children: [
                TopToBottomWidget(
                  index: 2,
                  child: Container(
                    height: 8.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(6.w),
                        bottomRight: Radius.circular(6.w),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(0.3), //Color of Shadow
                          spreadRadius: 5, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: OpacytiWidget(
                      number: 1,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              vibrateForAhalfSeconds();
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: HomePage()));
                            },
                            icon: Icon(Ionicons.chevron_back),
                          ),
                          Expanded(
                            child: Text(
                              _selectedIndex == 1 ? '$tomorrow' : '$toDay',
                              style: TextStyle(
                                  fontSize: 18.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_selectedIndex == 0) TodayListWidget(),
                if (_selectedIndex == 1) TomorrowListWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TodayListWidget extends StatelessWidget {
  const TodayListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 6.h, left: 2.w, right: 2.w, bottom: 1.w),
        child: Consumer2<TaskDataProvider, SubTaskDataProvider>(
          builder: (context, taskData, subTaskData, child) {
            List<Widget> _generateFlatList(
                TaskModel task, List<SubTaskModel> subtasks) {
              List<Widget> flatList = [];
              flatList.add(TaskTitleAndIcon(
                task: task,
              ));
              flatList.addAll(
                subtasks.asMap().entries.map(
                      (entry) => SubTaskTitle(
                        index: entry.key,
                        imagePaths: entry.value.imagePaths,
                        task: task,
                        detail: entry.value.detail,
                        subtask: entry.value,
                        onPressed: (context) {
                          vibrateForAhalfSeconds();
                          subTaskData.deleteSubTask(entry.value);
                        },
                        onChanged: (value) {
                          vibrateFor3time();
                          subTaskData.toggleSubTask(context,
                              id: entry.value.id,
                              title: entry.value.title,
                              newValue: value);
                          taskData.markTaskCompleted(context, task);
                        },
                      ),
                    ),
              );
              return flatList;
            }

            // Get not completed tasks
            List<TaskModel> notCompletedTasks =
                taskData.getNotCompletedTasksList;

            // Get subtasks for not completed tasks
            Map<String, List<SubTaskModel>> subTaskListToday = {};
            for (TaskModel task in notCompletedTasks) {
              List<SubTaskModel> subtasks =
                  subTaskData.getSubtasksForTaskForToday(task.id);
              if (subtasks.isNotEmpty) {
                subTaskListToday[task.id] = subtasks;
              }
            }

            List<Widget> allTasksAndSubTasks = [];

            for (var entry in subTaskListToday.entries) {
              final task = taskData.getTaskById(entry.key);
              final subtasks = entry.value;
              allTasksAndSubTasks.addAll(_generateFlatList(task!, subtasks));
            }

            return ListView(
              children: allTasksAndSubTasks,
            );
          },
        ),
      ),
    );
  }
}

class TomorrowListWidget extends StatelessWidget {
  const TomorrowListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 6.h, left: 2.w, right: 2.w, bottom: 1.w),
        child: Consumer2<TaskDataProvider, SubTaskDataProvider>(
          builder: (context, taskData, subTaskData, child) {
            List<Widget> _generateFlatList(
                TaskModel task, List<SubTaskModel> subtasks) {
              List<Widget> flatList = [];
              flatList.add(TaskTitleAndIcon(
                task: task,
              ));
              flatList.addAll(
                subtasks.asMap().entries.map(
                      (entry) => SubTaskTitle(
                        index: entry.key,
                        imagePaths: entry.value.imagePaths,
                        task: task,
                        detail: entry.value.detail,
                        subtask: entry.value,
                        onPressed: (context) {
                          vibrateForAhalfSeconds();
                          subTaskData.deleteSubTask(entry.value);
                        },
                        onChanged: (value) {
                          vibrateFor3time();
                          subTaskData.toggleSubTask(context,
                              id: entry.value.id,
                              title: entry.value.title,
                              newValue: value);
                          taskData.markTaskCompleted(context, task);
                        },
                      ),
                    ),
              );
              return flatList;
            }

            // Get not completed tasks
            List<TaskModel> notCompletedTasks =
                taskData.getNotCompletedTasksList;

            // Get subtasks for not completed tasks
            Map<String, List<SubTaskModel>> subTaskListToday = {};
            for (TaskModel task in notCompletedTasks) {
              List<SubTaskModel> subtasks =
                  subTaskData.getSubtasksForTaskForTomorrow(task.id);
              if (subtasks.isNotEmpty) {
                subTaskListToday[task.id] = subtasks;
              }
            }

            List<Widget> allTasksAndSubTasks = [];

            for (var entry in subTaskListToday.entries) {
              final task = taskData.getTaskById(entry.key);
              final subtasks = entry.value;
              allTasksAndSubTasks.addAll(_generateFlatList(task!, subtasks));
            }

            return ListView(
              children: allTasksAndSubTasks,
            );
          },
        ),
      ),
    );
  }
}
