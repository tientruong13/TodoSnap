import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/edit_subtask.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Page/Setting/provider/setting_provider.dart';
import 'package:task_app/Page/subtask_page/image/image_page.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/notification/option_notification.dart/select_option.dart';
import 'package:task_app/widget/animation_left_to_right.dart';
import 'package:task_app/widget/color_utils.dart';
import 'package:task_app/widget/font_size.dart';
import 'package:task_app/widget/icon/custom_check_box.dart';
import 'package:task_app/widget/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SubTaskTitle extends StatefulWidget {
  SubTaskTitle({
    Key? key,
    required this.index,
    required this.subtask,
    required this.task,
    this.onPressed,
    required this.onChanged,
    this.onChange,
    this.checkBoxController,
    this.isCompleted,
    this.detail,
    this.imagePaths,
  }) : super(key: key) {
    // print(
    //     'SubTaskTitle constructor: eventDate = $eventDate, eventTime = $eventTime');
  }
  final int index;
  final SubTaskModel subtask;
  final TaskModel task;
  final void Function(BuildContext)? onPressed;
  final void Function(bool) onChanged;
  final Function? onChange;
  final Animation<double>? checkBoxController;
  final bool? isCompleted;
  final String? detail;

  final List<String>? imagePaths;

  @override
  State<SubTaskTitle> createState() => _SubTaskTitleState();
}

class _SubTaskTitleState extends State<SubTaskTitle>
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
      duration: const Duration(milliseconds: 300),
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
    final subTaskProvider = Provider.of<SubTaskDataProvider>(context);
    // final subTasks = subTaskProvider.getSubTasksListBySort
    //     .where((it) => it.parent == widget.task.id)
    //     .toList();
    final settingProvider = Provider.of<SettingProvider>(context);
    // String formattedDate = DateFormat(settingProvider.selectedDateFormat!.format)
    //         .format(DateTime.now());
    final taskProvider = Provider.of<TaskDataProvider>(context);
    TaskModel task;
    try {
      task =
          taskProvider.getTaskList.firstWhere((it) => it.id == widget.task.id);
    } catch (e) {
      return Container();
    }
    // ignore: unused_local_variable
    var color = ColorUtils.getMaterialColorFrom(id: task.color);
    // ignore: unused_local_variable
    DateTime now = DateTime.now();
    // ignore: unused_local_variable
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
// '${DateFormat(settingProvider.selectedDateFormat!.format, Localizations.localeOf(context).toString()).format(widget.subtask.eventDate!)} ${widget.subtask.eventTime!.format(context)}',
    String getNotificationDisplayText(
        DateTime eventDateTime, TimeOfDay eventTime, NotificationType? type) {
      switch (type) {
        case NotificationType.Daily:
          return '${'Daily'.tr()}: ${eventTime.format(context)}';

        case NotificationType.Weekly:
          return '${'Weekly on'.tr()} ${DateFormat('EEEE', Localizations.localeOf(context).toString()).format(eventDateTime)}, ${eventTime.format(context)}';

        case NotificationType.Monthly:
          return '${'Monthly on the'.tr()} ${DateFormat('d', Localizations.localeOf(context).toString()).format(eventDateTime)}, ${eventTime.format(context)}';

        case NotificationType.Custom:
          return '${DateFormat(settingProvider.selectedDateFormat!.format, Localizations.localeOf(context).toString()).format(eventDateTime)}, ${eventTime.format(context)}';
        default:
          return '';
      }
    }

    Color getNotificationColor(DateTime? eventDateTime) {
      final now = DateTime.now();

      if (widget.subtask.isNotificationActive == false) {
        return Colors.grey;
      } else if (widget.subtask.notificationType == NotificationType.Custom) {
        if (eventDateTime != null) {
          return eventDateTime.isBefore(now) ? Colors.grey : color;
        }
        return Colors.grey; // return grey if eventDateTime is null
      }

      return color;
    }

    final Color textColor = getNotificationColor(eventDateTime);

    Icon getNotificationIcon(DateTime? eventDateTime) {
      final now = DateTime.now();

      if (widget.subtask.isNotificationActive == false) {
        return Icon(
          Ionicons.notifications_off,
          color: Colors.grey,
          size: 4.w,
        );
      } else if (widget.subtask.notificationType == NotificationType.Custom) {
        if (eventDateTime != null) {
          return eventDateTime.isBefore(now)
              ? Icon(
                  Ionicons.notifications_off,
                  color: Colors.grey,
                  size: 4.w,
                )
              : Icon(
                  Ionicons.notifications,
                  color: color,
                  size: 4.w,
                );
        }
        return Icon(
          Ionicons.notifications_off,
          color: Colors.grey,
          size: 4.w,
        );
      }

      return Icon(
        Ionicons.notifications,
        color: color,
        size: 4.w,
      );
    }

    return LeftToRightWidget(
      index: widget.index,
      child: GestureDetector(
        onTap: () async {
          vibrateForAhalfSeconds();
          editSubTask(context,
              subtaskId: widget.subtask.id,
              parent: widget.subtask.parent,
              title: widget.subtask.title,
              detail: widget.subtask.detail,
              date: widget.subtask.date,
              task: widget.task,
              imagePaths: widget.subtask.imagePaths,
              subTask: widget.subtask);
        },
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Slidable(
            startActionPane: ActionPane(
              motion: DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    // Navigator.push(
                    //     context,
                    //     PageTransition(
                    //         type: PageTransitionType.fade,
                    //         child: TaskSubtaskNotification(
                    //           subtask: widget.subtask,
                    //         )));
                    vibrateForAhalfSeconds();
                    subTaskProvider.shareSubtask(
                      imagePaths: widget.subtask.imagePaths,
                      subtaskTitle: widget.subtask.title,
                      subtaskDetail: widget.subtask.detail,
                    );
                  },
                  backgroundColor: Colors.blue,
                  icon: Ionicons.share_social,
                ),
                SlidableAction(
                  onPressed: widget.subtask.isCompleted
                      ? null
                      : (context) {
                          vibrateForAhalfSeconds();
                          selectOption(
                            context,
                            widget.task,
                            widget.subtask,
                          );
                        },
                  backgroundColor: Colors.green,
                  icon: Ionicons.notifications,
                ),
              ],
            ),
            endActionPane: ActionPane(motion: DrawerMotion(), children: [
              SlidableAction(
                onPressed: widget.onPressed,
                backgroundColor: Colors.red,
                icon: Ionicons.trash,
              ),
            ]),
            child: Padding(
              padding:
                  EdgeInsets.only(top: 1.w, bottom: 1.w, left: 2.w, right: 2.w),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.w),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomCheckBox(
                              height: 11.w,
                              width: 11.w,
                              value: widget.subtask.isCompleted,
                              onChanged: widget.onChanged,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 1.w),
                                          child: Container(
                                            width: 60.w,
                                            child: Text(
                                                maxLines: 2,
                                                widget.subtask.title,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: widget
                                                            .subtask.isCompleted
                                                        ? Colors.grey
                                                        : null,
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: widget
                                                            .subtask.isCompleted
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : null),
                                                textAlign: TextAlign.left),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              DateFormat(
                                                      settingProvider
                                                          .selectedDateFormat!
                                                          .format,
                                                      Localizations.localeOf(
                                                              context)
                                                          .toString())
                                                  .format(widget.subtask.date),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.grey,
                                                  decoration:
                                                      widget.subtask.isCompleted
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null),
                                            ),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            widget.subtask.eventDate == null ||
                                                    widget.subtask.eventTime ==
                                                        null
                                                //     ||
                                                // widget.subtask.isCompleted
                                                ? Container()
                                                : Row(
                                                    children: [
                                                      getNotificationIcon(
                                                          eventDateTime),
                                                      SizedBox(
                                                        width: 1.w,
                                                      ),
                                                      Text(
                                                        getNotificationDisplayText(
                                                          widget.subtask
                                                              .eventDate!,
                                                          widget.subtask
                                                              .eventTime!,
                                                          widget.subtask
                                                              .notificationType,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          color: textColor,
                                                          decoration: widget
                                                                  .subtask
                                                                  .isCompleted
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : null,
                                                        ),
                                                      )
                                                    ],
                                                    // children: [
                                                    //   // Icon(
                                                    //   //   Ionicons.notifications,
                                                    //   //   color: eventDateTime!
                                                    //   //           .isBefore(now)
                                                    //   //       ? Colors.grey
                                                    //   //       : color,
                                                    //   //   size: 4.w,
                                                    //   // ),
                                                    //   SizedBox(
                                                    //     width: 1.w,
                                                    //   ),

                                                    //   Text(
                                                    //     getNotificationDisplayText(
                                                    //       widget.subtask
                                                    //           .eventDate!,
                                                    //       widget.subtask
                                                    //           .eventTime!,
                                                    //       widget.subtask
                                                    //               .notificationType ??
                                                    //           NotificationType
                                                    //               .Custom,
                                                    //     ),
                                                    // '${DateFormat(settingProvider.selectedDateFormat!.format, Localizations.localeOf(context).toString()).format(widget.subtask.eventDate!)} ${widget.subtask.eventTime!.format(context)}',
                                                    //     style: TextStyle(
                                                    //         fontSize: 14.sp,
                                                    //         color: Colors.blue,
                                                    // eventDateTime
                                                    //         .isBefore(
                                                    //             now)
                                                    //     ? Colors.grey
                                                    //     : color,
                                                    //         decoration: widget
                                                    //                 .subtask
                                                    //                 .isCompleted
                                                    //             ? TextDecoration
                                                    //                 .lineThrough
                                                    //             : null),
                                                    //   ),
                                                    // ],
                                                  ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            widget.subtask.detail.isEmpty &&
                                    (widget.subtask.imagePaths.isEmpty)
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      vibrateForAhalfSeconds();
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
                                        size: 7.w,
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
                                  Linkify(
                                    onOpen: (link) async {
                                      if (!await launchUrl(
                                        Uri.parse(link.url),
                                      )) {
                                        throw Exception(
                                            'Could not launch ${link.url}');
                                      }
                                    },
                                    text: widget.subtask.detail,
                                    style: TextStyleUtils.addTaskandSubtask,
                                    linkStyle: TextStyle(color: Colors.blue),
                                  ),
                                  // Text(
                                  //   Linkify(
                                  //     onOpen: (link) async {
                                  //       if (await canLaunch(link.url)) {
                                  //         await launch(link.url);
                                  //       } else {
                                  //         throw 'Could not launch $link';
                                  //       }
                                  //     },
                                  //     text: widget.subtask
                                  //         .detail, // Assuming 'detail' is a String.
                                  //     style: TextStyleUtils.addTaskandSubtask,
                                  //     linkStyle: TextStyle(
                                  //         color: Colors
                                  //             .blue), // Change this color to match your app theme.
                                  //   ).toString(),
                                  //   // widget.subtask.detail,
                                  //   //   style: TextStyleUtils.addTaskandSubtask
                                  // ),
                                  widget.subtask.imagePaths.isEmpty
                                      ? Container()
                                      : SizedBox(
                                          height: 15.h,
                                          // maxHeight:
                                          //     MediaQuery.of(context).size.height *
                                          //         0.3,
                                          child: ImageGridView(
                                            imagePaths:
                                                widget.subtask.imagePaths,
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
          ),
        ),
      ),
    );
  }
}
