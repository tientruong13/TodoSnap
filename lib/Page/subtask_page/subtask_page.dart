// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/create_subtask.dart';
import 'package:task_app/Functions/edit_task.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Page/home_page/home_page.dart';
import 'package:task_app/Page/home_page/plus.dart';
import 'package:task_app/Page/subtask_page/subtask_title.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/widget/animated_bottom_to_top_widget.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';
import 'package:task_app/widget/color.dart';
import 'package:task_app/widget/color_utils.dart';
import 'package:task_app/widget/font_size.dart';
import 'package:task_app/widget/sliver_app_bar.dart';

class SubTaskPage extends StatefulWidget {
  const SubTaskPage({
    Key? key,
    required this.task,
  }) : super(key: key);
  final TaskModel task;

  @override
  State<SubTaskPage> createState() => _SubTaskPageState();
}

class _SubTaskPageState extends State<SubTaskPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this)
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 0.8).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool value = false;
    // bool isCompleted = false;
    final subTaskProvider = Provider.of<SubTaskDataProvider>(context);
    final taskProvider = Provider.of<TaskDataProvider>(context);
    TaskModel task;
    try {
      task =
          taskProvider.getTaskList.firstWhere((it) => it.id == widget.task.id);
    } catch (e) {
      return Container();
    }
    // ignore: unused_local_variable
    var subTask = subTaskProvider.getSubTasksListBySort
        .where((it) => it.parent == widget.task.id)
        .toList();

    var color = ColorUtils.getMaterialColorFrom(id: task.color);
    var icon = IconData(task.codePoint, fontFamily: 'MaterialIcons');
    bool getTaskdone() {
      List<SubTaskModel> _subTask = subTaskProvider.getSubTaskList
          .where((it) => it.parent == widget.task.id)
          .toList();
      return _subTask.every((subtask) => subtask.isCompleted) &&
          _subTask.isNotEmpty;
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            CustomPage(
              leading: iconButtonBack(context),
              title: OpacytiWidget(
                number: 0,
                child: Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleUtils.addTaskandSubtask,
                ),
              ),
              centerTitle: false,
              backgroundColor: scaffoldBackground(context),
              appBarColor: color,
              actions: [iconButtonEdit(context, task, icon, color)],
              headerWidget: headerWidget(
                context,
                color,
                task,
                icon,
                subTaskProvider,
              ),
              headerExpandedHeight: 0.21,
              curvedBodyRadius: 40,
              body: [
                subTask.isEmpty
                    ? Container()
                    : SubtaskList(subTask, task, subTaskProvider, taskProvider),
              ],
              fullyStretchable: true,
              stretchMaxHeight: 0.5,
              expandedBody: expandedBody(context, color, icon),
              physics: subTask.isEmpty
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButtonAnimator:
                  FloatingActionButtonAnimator.scaling,
              floatingActionButton: getTaskdone()
                  ? Container()
                  : BottomToTopWidget(
                      index: 3,
                      child: InkWell(
                        onTap: () async {
                          vibrateForAhalfSeconds();
                          createSubTask(
                            context,
                            task: task,
                          );
                        },
                        child: Container(
                          height: 14.w,
                          width: 14.w,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5.w),
                            boxShadow: [
                              BoxShadow(
                                color: shadowButtonColor(context),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return CustomPaint(
                                  foregroundPainter: BoxShadowPainter(
                                    BoxShadow(
                                      color: Colors.white
                                          .withOpacity(_animation.value),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/plus1.svg',
                                    color: Colors.white,
                                    height: 7.w,
                                    width: 7.w,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget expandedBody(
      BuildContext context, MaterialColor color, IconData icon) {
    final subTaskProvider = Provider.of<SubTaskDataProvider>(context);
    final taskProvider = Provider.of<TaskDataProvider>(context);
    TaskModel task;
    try {
      task =
          taskProvider.getTaskList.firstWhere((it) => it.id == widget.task.id);
    } catch (e) {
      return Container();
    }

    // ignore: unused_local_variable
    var subTask = subTaskProvider.getSubTasksListBySort
        .where((it) => it.parent == widget.task.id)
        .toList();
    double percentValue = 0.05;
    percentValue = subTaskProvider.currentFinishedTaskCount(task) /
        subTaskProvider.subTaskCount(task);
    getPercentComplete() =>
        subTaskProvider.currentFinishedTaskCount(task) *
        100 /
        subTaskProvider.subTaskCount(task);

    return Container(
      color: Theme.of(context).cardColor,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 7.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    iconButtonBack(
                      context,
                    ),
                    Text(
                      'Statistics',
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    iconButtonEdit(context, task, icon, color)
                  ],
                ),
              ),
              SizedBox(
                height: 7.h,
              ),
              Center(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    height: 23.h,
                    width: 90.w,
                    // padding: EdgeInsets.only(
                    //     top: 4.w, left: 3.w, bottom: 2.w, right: 2.w),
                    decoration: BoxDecoration(
                      color: scaffoldBackground(context),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                            top: 0.w,
                            left: -7.w,
                            child: Transform.rotate(
                              angle: 45 * 3.14159265359 / 180,
                              child: ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      color.withOpacity(0.2),
                                      Colors.transparent
                                    ],
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.srcIn,
                                child: Icon(
                                  icon,
                                  size: 70.w,
                                ),
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.all(5.w),
                          child: Column(
                            children: [
                              // taskTitle(task),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(2.w),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/listtask.png',
                                              height: 8.w,
                                              width: 8.w,
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Text(
                                              '${subTaskProvider.subTaskCount(task).toString()}',
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(2.w),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/uncheck.png',
                                              height: 8.w,
                                              width: 8.w,
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Text(
                                              '${subTaskProvider.getTotalSubTasLeft(task).toString()}',
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(2.w),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/check.png',
                                              height: 8.w,
                                              width: 8.w,
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Text(
                                              '${subTaskProvider.currentFinishedTaskCount(task).toString()}',
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 2, bottom: 2, left: 8),
                                    child: FittedBox(
                                      child: CircularPercentIndicator(
                                        radius: 18.w,
                                        lineWidth: 5.w,
                                        animation: true,
                                        animateFromLastPercent: true,
                                        percent: percentValue.isNaN
                                            ? 0.00
                                            : percentValue,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        backgroundColor: Colors.white,
                                        progressColor: color,
                                        center: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            FittedBox(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  '${getPercentComplete().toStringAsFixed(0)}%',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  OpacytiWidget emptyWidget(BuildContext context) {
    return OpacytiWidget(
      number: 1,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 2.w),
              child: Text(
                'Your task list is waiting.'.tr(),
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: Text(
                    'Tap'.tr(),
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ),
                Container(
                  height: 8.w,
                  width: 8.w,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: shadowButtonColor(context),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomPaint(
                      foregroundPainter: BoxShadowPainter(
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/plus1.svg',
                        color: Colors.white,
                        height: 4.w,
                        width: 4.w,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: Text(
                    'to add your first task.'.tr(),
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget headerWidget(
    BuildContext context,
    MaterialColor color,
    TaskModel task,
    IconData icon,
    SubTaskDataProvider subTaskProvider,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: 2.w, left: 2.w, right: 2.w),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -6.w,
              left: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  'assets/3.png',
                  width: 110.w,
                  height: 50.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, right: 1.w, left: 1.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      iconButtonBack(context),
                      iconButtonEdit(context, task, icon, color),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: OpacytiWidget(
                    number: 1,
                    child: Row(
                      children: [
                        iconWidget(context, color, icon),
                        Padding(
                          padding: EdgeInsets.only(left: 2.w),
                          child: SizedBox(
                            width: 70.w,
                            child: taskTitle(task),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w),
                  child: subTaskProvider.subTaskCount(task) != 0
                      ? OpacytiWidget(
                          number: 2,
                          child: allTaskText(subTaskProvider, task),
                        )
                      : Container(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Text allTaskText(SubTaskDataProvider subTaskProvider, TaskModel task) {
    return Text(
      'All Tasks: ${subTaskProvider.subTaskCount(task).toString()}',
      style: TextStyle(fontSize: 15.sp, color: Colors.white),
    );
  }

  Container iconWidget(
      BuildContext context, MaterialColor color, IconData icon) {
    return Container(
      height: 11.w,
      width: 11.w,
      decoration: BoxDecoration(
        color: scaffoldBackground(context),
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      child: Center(
        child: Icon(icon, size: 6.w, color: color
            // Colors.grey.shade300.withOpacity(0.5),
            ),
      ),
    );
  }

  Text taskTitle(TaskModel task) {
    return Text(
      task.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
    );
  }

  OpacytiWidget iconButtonEdit(BuildContext context, TaskModel task,
      IconData icon, MaterialColor color) {
    return OpacytiWidget(
      number: 0,
      child: IconButton(
        onPressed: () {
          vibrateForAhalfSeconds();
          editTask(
            context,
            taskId: task.id,
            title: task.title,
            icon: icon,
            color: color,
            task: task,
          );
        },
        icon: Icon(
          Ionicons.ellipsis_vertical,
          size: 6.w,
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

  Consumer<SubTaskDataProvider> SubtaskList(
      List<SubTaskModel> subTask,
      TaskModel task,
      SubTaskDataProvider subTaskProvider,
      TaskDataProvider taskProvider) {
    return Consumer<SubTaskDataProvider>(
      builder: ((context, SubTaskDataProvider subtskProvider, child) {
        return Padding(
          padding: EdgeInsets.only(
            right: 2.w,
            left: 2.w,
          ),
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subTask.length,
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                var subtaskList = subTask[index];
                // print('Creating SubTaskTitle: subTask.eventDate = ${subtaskList.eventDate}, subTask.eventTime = ${subtaskList.eventTime}');
                return
                    // AnimatedListItem(
                    //     index: index,
                    //     length: subTask.length,
                    //     aniController: _animationController,
                    //     animationType: AnimationType.flipX,
                    SubTaskTitle(
                  index: index,
                  imagePaths: subtaskList.imagePaths,
                  task: task,
                  subtask: subtaskList,
                  detail: subtaskList.detail,
                  // eventDate: subtaskList.eventDate,
                  // eventTime: subtaskList.eventTime,
                  onPressed: (context) {
                    vibrateForAhalfSeconds();
                    subTaskProvider.deleteSubTask(subtaskList);
                  },
                  onChanged: (value) async {
                    vibrateFor3time();
                    subTaskProvider.toggleSubTask(context,
                        id: subtaskList.id,
                        title: subtaskList.title,
                        newValue: value);
                    subTaskProvider.cancelSubTaskNotification(subtaskList);
                    taskProvider.markTaskCompleted(context, task);
                  },
                  //
                );
              })),
        );
      }),
    );
  }
}
