import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';

class TaskTitleAndIcon extends StatelessWidget {
  final TaskModel task;

  const TaskTitleAndIcon({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpacytiWidget(
      number: 1,
      child: Padding(
        padding: EdgeInsets.all(2.w),
        child: Row(
          children: [
            Icon(
              IconData(
                task.codePoint,
                fontFamily: 'MaterialIcons',
              ),
              color: Color(task.color),
              size: 6.w,
            ),
            SizedBox(width: 5.w),
            SizedBox(
              width: 75.w,
              child: Text(
                task.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(task.color)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
