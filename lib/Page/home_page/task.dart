// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Page/subtask_page/subtask_page.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/widget/animated_bottom_to_top_widget.dart';
import 'package:task_app/widget/color.dart';
import 'package:task_app/widget/color_utils.dart';

class TaskTitle extends StatefulWidget {
  const TaskTitle({
    Key? key,
    required this.task,
    required this.index,
  }) : super(key: key);
  final TaskModel task;
  final int index;

  @override
  State<TaskTitle> createState() => _TaskTitleState();
}

class _TaskTitleState extends State<TaskTitle> {
  late Color taskColor;
  late IconData taskIcon;
  late TaskModel task;
  late SubTaskModel subtask;
  final ValueNotifier<bool> dragNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    taskColor = ColorUtils.defaultColors[0];
    taskIcon = Icons.work;
  }

  @override
  Widget build(BuildContext context) {
    TaskModel _task;

    final taskProvider = Provider.of<TaskDataProvider>(context);
    final subTaskProvider = Provider.of<SubTaskDataProvider>(context);
    try {
      _task =
          taskProvider.getTaskList.firstWhere((it) => it.id == widget.task.id);
    } catch (e) {
      print(e); // Optionally, you can print or handle the error.
      return Container(); // If error occurs, return an empty Container widget.
    }

    var _subTask = subTaskProvider.getSubTaskList
        .where((it) => it.parent == widget.task.id)
        .toList();
    bool getTaskdone() {
      List<SubTaskModel> _subTask = subTaskProvider.getSubTaskList
          .where((it) => it.parent == widget.task.id)
          .toList();
      return _subTask.every((subtask) => subtask.isCompleted) &&
          _subTask.isNotEmpty;
    }

    var color = ColorUtils.getMaterialColorFrom(id: _task.color);
    // var icon = IconData(_task.codePoint, fontFamily: 'MaterialIcons');

    final subTaskLeft = subTaskProvider.getTotalSubTasLeft(_task);
    return GestureDetector(
      onTap: () {
        vibrateForAhalfSeconds();
        Navigator.of(context).push(
          PageRouteBuilder(
            fullscreenDialog: true,
            transitionDuration: Duration(milliseconds: 1000),
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return SubTaskPage(
                task: widget.task,
              );
            },
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },

      // onTap: () {
      //   Navigator.of(context).push(
      //     PageRouteBuilder(
      //       pageBuilder: (context, animation, secondaryAnimation) {
      //         return FadeTransition(
      //           opacity: Tween<double>(
      //             begin: 0.0,
      //             end: 1.0,
      //           ).animate(animation),
      //           child: SubTaskPage(
      //             task: widget.task,
      //           ),
      //         );
      //       },
      //       transitionsBuilder:
      //           (context, animation, secondaryAnimation, child) {
      //         return child;
      //       },
      //       transitionDuration: Duration(seconds: 1),
      //     ),
      //   );
      // },
      child: BottomToTopWidget(
        index: widget.index,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 13.w, left: 3.w, right: 3.w),
                  child: Text(
                    widget.task.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              _subTask.isEmpty
                  ? Container()
                  : getTaskdone()
                      ? Positioned(
                          top: 2.w,
                          right: 2.w,
                          child: GestureDetector(
                            onTap: () {
                              taskProvider.deleteTask(_task, subTaskProvider);
                            },
                            child: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : Positioned(
                          top: 4.w,
                          right: 8.w,
                          child: Text(
                            '${subTaskLeft.toString()}',
                            maxLines: 1,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),
                        ),
              Positioned(
                top: 4.w,
                left: 4.w,
                child: Container(
                  height: 11.w,
                  width: 11.w,
                  decoration: BoxDecoration(
                    color: scaffoldBackground(context),
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                        IconData(widget.task.codePoint,
                            fontFamily: 'MaterialIcons'),
                        size: 6.w,
                        color: color
                        // Colors.grey.shade300.withOpacity(0.5),
                        ),
                  ),
                ),
                // child: OpacytiWidget(
                //   number: 2,
                //   child: TodoBadge(
                //     size: 8.w,
                //     id: widget.task.id,
                //     codePoint: widget.task.codePoint,
                //     color: getTaskdone()
                //         ? Colors.grey
                //         : ColorUtils.getColorFrom(
                //             id: widget.task.color,
                //           ),
                //   ),
                // ),
              ),
              Positioned(
                  top: 2.w,
                  right: -10.w,
                  child: Transform.rotate(
                    angle: -45 * 3.14159265359 / 180,
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ColorUtils.getColorFrom(
                              id: widget.task.color,
                            ).withOpacity(0.2),
                            Colors.transparent
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn,
                      child: Icon(
                        IconData(widget.task.codePoint,
                            fontFamily: 'MaterialIcons'),
                        size: 40.w,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
