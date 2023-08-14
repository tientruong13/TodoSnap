// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_local_variable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/Page/home_page/task.dart';

// import 'package:task_app/widget/draganddrop/devdrag.dart';
// import 'package:task_app/widget/reorderable/entities/order_update_entity.dart';
// import 'package:task_app/widget/reorderable/widgets/reorderable_builder.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    final _gridViewKey = GlobalKey();
    final tasksList = Provider.of<TaskDataProvider>(context, listen: true);
    var tsksList = tasksList.getNotCompletedTasksList;
    return Stack(
      children: [
        Padding(
          padding:
              EdgeInsets.only(top: 3.w, left: 5.w, right: 5.w, bottom: 12.h),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              mainAxisSpacing: 5.w,
              crossAxisSpacing: 5.w,
            ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: tsksList.length,
            itemBuilder: (context, index) {
              final task = tsksList[index];
              return TaskTitle(
                index: index,
                task: task,
              );
            },
          ),
        ),
      ],
    );
  }
}
