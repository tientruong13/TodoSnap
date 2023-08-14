import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Page/Setting/provider/setting_provider.dart';
import 'package:task_app/Page/home_page/home_page.dart';
import 'package:task_app/Page/home_page/task_title_and_icon.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';
import 'package:task_app/widget/animated_top_to_bottom_widget.dart';
import 'package:task_app/widget/color.dart';
import 'package:task_app/widget/font_size.dart';
import 'package:task_app/widget/sliver_app_bar.dart';

import '../subtask_page/subtask_title.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    Key? key,
  }) : super(key: key);
// final TaskModel task;
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat format = CalendarFormat.month;

  late AnimationController animationController;
  late AnimationController _controller;

  @override
  void initState() {
    _selectedDay = _focusedDay;
    setState(() {});
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    animationController.forward();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subTaskData =
        Provider.of<SubTaskDataProvider>(context, listen: false);
    final settingProvider = Provider.of<SettingProvider>(context);
    final subTaskProvider = Provider.of<SubTaskDataProvider>(context);
    // ignore: unused_local_variable
    final taskProvider = Provider.of<TaskDataProvider>(context);
    var subtaskBySelectDay =
        subTaskProvider.getTasksWithSubtasksForDay(_selectedDay!);
    int allTasks = subTaskProvider.getAllTasksCountForDay(_selectedDay!);
    int completedTasks =
        subTaskProvider.getCompletedTasksCountForDay(_selectedDay!);
    int uncompletedTasks =
        subTaskProvider.getUncompletedTasksCountForDay(_selectedDay!);
    return SafeArea(
      child: Scaffold(
        body: CustomPage(
          leading: iconButtonBack(context),
          title: OpacytiWidget(
            number: 0,
            child: Text(
              _selectedDay != null
                  ? DateFormat(settingProvider.selectedDateFormat!.format,
                          Localizations.localeOf(context).toString())
                      .format(
                          _selectedDay!) // You can format this to however you want
                  : 'No date selected',
              style: TextStyleUtils.addTaskandSubtask,
            ),
          ),
          centerTitle: false,
          switchWidget: false,
          headerWidget: headerWidget(
              context, subTaskData, allTasks, uncompletedTasks, completedTasks),
          backgroundColor: scaffoldBackground(context),
          headerExpandedHeight: 0.55,
          physics: subtaskBySelectDay.isEmpty
              ? const NeverScrollableScrollPhysics()
              : const BouncingScrollPhysics(),
          body: [
            listTaskSubtask(
              selectedDay: _selectedDay,
              animationController: animationController,
            ),
          ],
        ),
      ),
    );
  }

  OpacytiWidget iconButtonBack(BuildContext context) {
    return OpacytiWidget(
      number: 0,
      child: IconButton(
        onPressed: () {
          vibrateForAhalfSeconds();
          Navigator.push(context,
              PageTransition(type: PageTransitionType.fade, child: HomePage()));
        },
        icon: Icon(
          Ionicons.chevron_back,
          size: 6.w,
        ),
      ),
    );
  }

  TopToBottomWidget headerWidget(
    BuildContext context,
    SubTaskDataProvider subTaskData,
    int allTasks,
    int uncompletedTasks,
    int completedTasks,
  ) {
    return TopToBottomWidget(
      index: 1,
      child: Column(
        children: [
          Container(
            height: 8.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: mainColorOfLight(context),
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
            child: OpacytiWidget(
              number: 1,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      vibrateForAhalfSeconds();
                      Navigator.pop(context);
                    },
                    icon: Icon(Ionicons.chevron_back),
                  ),
                  Text(
                    'Calendar'.tr(),
                    style: TextStyleUtils.headingMedium,
                  ),
                  Hero(
                    tag: 'calendar',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Icon(Ionicons.calendar,
                          size: 8.w, color: Colors.transparent),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            // color: Theme.of(context).canvasColor,
            child: Calendar(subTaskData),
          ),
          // Padding(
          //   padding: EdgeInsets.only(
          //     left: 2.w,
          //     right: 2.w,
          //   ),
          //   child: Card(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(15.0),
          //     ),
          //     child: Container(
          //       decoration: BoxDecoration(
          //         color: mainColorOfLight(context),
          //         borderRadius: BorderRadius.circular(15),
          //       ),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: [
          //           Padding(
          //             padding: EdgeInsets.all(2.w),
          //             child: Row(
          //               children: [
          //                 Image.asset(
          //                   'assets/listtask.png',
          //                   height: 8.w,
          //                   width: 8.w,
          //                 ),
          //                 SizedBox(
          //                   width: 2.w,
          //                 ),
          //                 Text(
          //                   '${allTasks.toString()}',
          //                   style: TextStyle(
          //                       fontSize: 18.sp, fontWeight: FontWeight.bold),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Padding(
          //             padding: EdgeInsets.all(2.w),
          //             child: Row(
          //               children: [
          //                 Image.asset(
          //                   'assets/uncheck.png',
          //                   height: 8.w,
          //                   width: 8.w,
          //                 ),
          //                 SizedBox(
          //                   width: 2.w,
          //                 ),
          //                 Text(
          //                   '${uncompletedTasks.toString()}',
          //                   style: TextStyle(
          //                       fontSize: 18.sp, fontWeight: FontWeight.bold),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Padding(
          //             padding: EdgeInsets.all(2.w),
          //             child: Row(
          //               children: [
          //                 Image.asset(
          //                   'assets/check.png',
          //                   height: 8.w,
          //                   width: 8.w,
          //                 ),
          //                 SizedBox(
          //                   width: 2.w,
          //                 ),
          //                 Text(
          //                   '${completedTasks.toString()}',
          //                   style: TextStyle(
          //                       fontSize: 18.sp, fontWeight: FontWeight.bold),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  TableCalendar<Object?> Calendar(SubTaskDataProvider subTaskData) {
    return TableCalendar(
      locale: context.locale.toString(),
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2022),
      lastDay: DateTime.utc(2223),
      calendarFormat: CalendarFormat.month,
      onFormatChanged: (CalendarFormat _format) {
        setState(() {
          format = _format;
        });
      },
      daysOfWeekHeight: 2.5.h,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        weekendStyle: TextStyle(
          fontSize: 16.sp,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        // print('Selected day: $selectedDay');
        // print('Focused day: $focusedDay');
        // Call `setState()` when updating the selected day
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          animationController.reset(); // Reset the animation controller
          animationController.forward();
        });
      },
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      eventLoader: (day) {
        final tasksWithSubtasks = subTaskData.getTasksWithSubtasksForDay(day);
        List<SubTaskModel> subtasks = [];
        tasksWithSubtasks.values.forEach((subtaskList) {
          subtasks.addAll(subtaskList);
        });
        // print('Subtasks for day $day: $subtasks');
        return subtasks;
      },
      headerStyle: HeaderStyle(
        // leftChevronVisible: false,
        // rightChevronVisible: false,
        // headerPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        titleTextStyle: TextStyleUtils.addTaskandSubtask,
        titleCentered: true,
        formatButtonVisible: false,
      ),
      calendarStyle: CalendarStyle(
        markersAlignment: Alignment.bottomRight,
        defaultTextStyle: TextStyle(fontSize: 15.sp),
        weekendTextStyle: TextStyle(fontSize: 15.sp),
        selectedTextStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        todayTextStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.deepOrange,
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) => events.isNotEmpty
            ? Container(
                width: 7.w,
                height: 7.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  '${events.length}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                ),
              )
            : null,
      ),
    );
  }
}

class listTaskSubtask extends StatefulWidget {
  const listTaskSubtask({
    Key? key,
    required DateTime? selectedDay,
    required this.animationController,
  })  : _selectedDay = selectedDay,
        super(key: key);

  final DateTime? _selectedDay;
  final AnimationController animationController;

  @override
  State<listTaskSubtask> createState() => _listTaskSubtaskState();
}

class _listTaskSubtaskState extends State<listTaskSubtask> {
  List<Widget> _buildFlatList(Map<String, List<SubTaskModel>> subTaskListByDay,
      TaskDataProvider taskData, SubTaskDataProvider subTaskData) {
    List<Widget> flatList = [];

    subTaskListByDay.forEach((parentId, subtasks) {
      final task = taskData.getTaskById(parentId);

      if (task != null) {
        // print('Displaying task: $task, subtasks: $subtasks');

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
      }
    });

    return flatList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.w, left: 2.w, right: 2.w, bottom: 2.w),
      child: Consumer2<SubTaskDataProvider, TaskDataProvider>(
        builder: (context, subTaskData, taskData, child) {
          final subTaskListByDay =
              subTaskData.getTasksWithSubtasksForDay(widget._selectedDay!);
          // print(
          //     'Subtasks for selected day ${widget._selectedDay}: $subTaskListByDay');

          // Build a list of widgets
          List<Widget> flatList =
              _buildFlatList(subTaskListByDay, taskData, subTaskData);

          if (flatList.isNotEmpty) {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: flatList,
            );
          } else {
            // Display a message when there are no tasks for the selected day
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 5.w),
                child: OpacytiWidget(
                  number: 1,
                  child: Text('No tasks available for the selected day.'.tr(),
                      style: TextStyle(fontSize: 16.sp)),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
