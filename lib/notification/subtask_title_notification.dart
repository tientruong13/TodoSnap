import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Page/Setting/provider/setting_provider.dart';
import 'package:task_app/Page/subtask_page/image/image_page.dart';
import 'package:task_app/widget/icon/custom_check_box.dart';

class SubTaskTitleNotification extends StatefulWidget {
  SubTaskTitleNotification({
    Key? key,
    required this.subtask,
    required this.task,
    required this.onChanged,
    this.detail,
    this.imagePaths,
  }) : super(key: key);

  final SubTaskModel subtask;
  final TaskModel task;
  final void Function(bool) onChanged;
  final String? detail;
  final List<String>? imagePaths;

  @override
  State<SubTaskTitleNotification> createState() => _SubTaskTitleState();
}

class _SubTaskTitleState extends State<SubTaskTitleNotification>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;

  SubTaskModel? subTask;
  bool isEventSet = false;
  @override
  void initState() {
    // Controller can be used directly without using Animation class to create
    // custom animation when the animated value is a double and you need to animate
    // exclusively between 0 => 1
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(_controller);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(
    // 'SubTaskTitle build: eventDate = ${widget.subtask.eventDate}, eventTime = ${widget.subtask.eventTime}');
    // bool isCompleted = false;
    // final size = MediaQuery.of(context).size;
    // final subTaskProvider = Provider.of<SubTaskDataProvider>(context);
    // final subTasks = subTaskProvider.getSubTasksListBySort
    //     .where((it) => it.parent == widget.task.id)
    //     .toList();
    final settingProvider = Provider.of<SettingProvider>(context);
    // String formattedDate =
    // DateFormat(settingProvider.selectedDateFormat!.format)
    //     .format(DateTime.now());

    DateTime now = DateTime.now();
    DateTime? eventDateTime;
    if (widget.subtask.eventDate != null && widget.subtask.eventTime != null) {
      eventDateTime = DateTime(
        widget.subtask.eventDate!.year,
        widget.subtask.eventDate!.month,
        widget.subtask.eventDate!.day,
        widget.subtask.eventTime!.hour,
        widget.subtask.eventTime!.minute,
      );
    }
    return Padding(
      padding: EdgeInsets.all(5),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomCheckBox(
                        height: 9.w,
                        width: 9.w,
                        value: widget.subtask.isCompleted,
                        onChanged: widget.onChanged,
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 1.w),
                                  child: Container(
                                    width: 48.w,
                                    child: Text(
                                        maxLines: 2,
                                        widget.subtask.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      DateFormat(settingProvider
                                              .selectedDateFormat!.format)
                                          .format(widget.subtask.date),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 14.sp, color: Colors.grey),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    widget.subtask.eventDate == null ||
                                            widget.subtask.eventTime == null
                                        ? Container()
                                        : Row(
                                            children: [
                                              Icon(
                                                Ionicons.notifications,
                                                color:
                                                    eventDateTime!.isBefore(now)
                                                        ? Colors.grey
                                                        : Colors.blue,
                                                size: 4.w,
                                              ),
                                              SizedBox(
                                                width: 1.w,
                                              ),
                                              Text(
                                                '${DateFormat(settingProvider.selectedDateFormat!.format).format(widget.subtask.eventDate!)} ${widget.subtask.eventTime!.format(context)}',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: eventDateTime
                                                          .isBefore(now)
                                                      ? Colors.grey
                                                      : Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      widget.subtask.detail.isEmpty &&
                              (widget.subtask.imagePaths.isEmpty)
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.all(5),
                              child: InkWell(
                                onTap: () {
                                  if (_controller.isCompleted) {
                                    _controller.reverse();
                                  } else {
                                    _controller.forward();
                                  }
                                },
                                child: RotationTransition(
                                  alignment: Alignment.center,
                                  turns: _rotationAnimation,
                                  child: Icon(
                                    Ionicons.chevron_down,
                                    size: 5.w,
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                  SizeTransition(
                    sizeFactor: _controller,
                    child: Padding(
                      padding: EdgeInsets.all(2.w),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.subtask.detail,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                            widget.subtask.imagePaths.isEmpty
                                ? Container()
                                : SizedBox(
                                    height: 20.h,
                                    child: ImageGridView(
                                      imagePaths: widget.subtask.imagePaths,
                                      subTask: widget.subtask,
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
