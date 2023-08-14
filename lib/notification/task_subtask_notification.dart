// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Page/home_page/home_page.dart';
import 'package:task_app/Page/subtask_page/subtask_page.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/notification/subtask_title_notification.dart';
import 'package:task_app/widget/color_utils.dart';
import 'package:tuple/tuple.dart';

class TaskSubtaskNotification extends StatefulWidget {
  const TaskSubtaskNotification({
    Key? key,
    required this.receivedAction,
  }) : super(key: key);
  final ReceivedAction receivedAction;
  @override
  State<TaskSubtaskNotification> createState() =>
      _TaskSubtaskNotificationState();
}

class _TaskSubtaskNotificationState extends State<TaskSubtaskNotification> {
  Future<Tuple2<TaskModel?, SubTaskModel?>> fetchData() async {
    final taskProvider = Provider.of<TaskDataProvider>(context, listen: false);
    final subTaskProvider =
        Provider.of<SubTaskDataProvider>(context, listen: false);
    String? id = widget.receivedAction.payload?["id"];
    if (id == null) {
      throw ArgumentError('ReceivedAction payload does not contain an "id"');
    }

    SubTaskModel? subtask = subTaskProvider.getSubtaskById(id);
    if (subtask == null) {
      throw ArgumentError('No SubTask found with id: $id');
    }

    String parentId = subtask.parent;
    TaskModel? parentTask = taskProvider.getTaskById(parentId);
    if (parentTask == null) {
      throw ArgumentError('No Task found with id: $parentId');
    }

    return Tuple2(parentTask, subtask);
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskDataProvider>(context, listen: false);
    final subTaskProvider =
        Provider.of<SubTaskDataProvider>(context, listen: false);
    return FutureBuilder<Tuple2<TaskModel?, SubTaskModel?>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Assuming we got our data successfully, we can access them through snapshot.data.item1 and snapshot.data.item2
          // item1 is TaskModel, item2 is SubTaskModel
          var parentTask = snapshot.data!.item1;
          var subtask = snapshot.data!.item2;

          return SafeArea(
            child: Scaffold(
              body: Container(
                // height: 100.h,
                // width: 100.w,
                color: ColorUtils.getMaterialColorFrom(id: parentTask!.color)
                    .withOpacity(0.5),
                child: Center(
                    child: Card(
                  elevation: 5,
                  color: Color.fromARGB(255, 235, 235, 235),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(1.w),
                    child: SizedBox(
                      width: 90.w,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2.w, bottom: 3.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 9.w,
                                  width: 9.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                        IconData(parentTask.codePoint,
                                            fontFamily: 'MaterialIcons'),
                                        size: 5.w,
                                        color: ColorUtils.getMaterialColorFrom(
                                            id: parentTask.color)
                                        // Colors.grey.shade300.withOpacity(0.5),
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Text(
                                  parentTask.title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SubTaskTitleNotification(
                              subtask: subtask!,
                              task: parentTask,
                              onChanged: (value) async {
                                vibrateFor3time();
                                subTaskProvider.toggleSubTask(context,
                                    id: subtask.id,
                                    title: subtask.title,
                                    newValue: value);
                                taskProvider.markTaskCompleted(
                                    context, parentTask);
                              }),
                          Padding(
                            padding: EdgeInsets.all(
                              3.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      vibrateForAhalfSeconds();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(),
                                        ),
                                      );
                                      // subTaskProvider
                                      //     .cancelSubTaskNotification(subtask);
                                    },
                                    child: Text('Home screen',
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold))),
                                TextButton(
                                    onPressed: () {
                                      vibrateForAhalfSeconds();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SubTaskPage(task: parentTask),
                                        ),
                                      );
                                      // subTaskProvider
                                      //     .cancelSubTaskNotification(subtask);
                                    },
                                    child: Text('Task screen',
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
              ),
            ),
          );
        }
      },
    );
  }
}

// class TaskSubtaskNotification extends StatefulWidget {
//   const TaskSubtaskNotification({
//     Key? key,
//     required this.receivedAction,
//   }) : super(key: key);
//   final ReceivedAction receivedAction;
//   @override
//   State<TaskSubtaskNotification> createState() =>
//       _TaskSubtaskNotificationState();
// }

// class _TaskSubtaskNotificationState extends State<TaskSubtaskNotification> {
//   @override
//   Widget build(BuildContext context) {
//     final taskProvider = Provider.of<TaskDataProvider>(context, listen: false);
//     final subTaskProvider =
//         Provider.of<SubTaskDataProvider>(context, listen: false);
//     String? id = widget.receivedAction.payload?["id"];
//     if (id == null) {
//       // handle this situation, for example, return an error widget or throw an error
//       throw ArgumentError('ReceivedAction payload does not contain an "id"');
//     }

//     SubTaskModel? subtask = subTaskProvider.getSubtaskById(id);
//     if (subtask == null) {
//       // handle this situation
//       throw ArgumentError('No SubTask found with id: $id');
//     }

//     String parentId = subtask.parent;
//     TaskModel? parentTask = taskProvider.getTaskById(parentId);
//     if (parentTask == null) {
//       // handle this situation
//       throw ArgumentError('No Task found with id: $parentId');
//     }
//     print('ReceivedAction payload: ${widget.receivedAction.payload}');
//     print('SubTask: ${subTaskProvider.getSubtaskById(id)}');
//     print('Parent Task: ${taskProvider.getTaskById(subtask.parent)}');
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           // height: 100.h,
//           // width: 100.w,
//           color: ColorUtils.getMaterialColorFrom(id: parentTask.color)
//               .withOpacity(0.5),
//           child: Center(
//               child: Card(
//             elevation: 5,
//             color: Color.fromARGB(255, 235, 235, 235),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(1.w),
//               child: SizedBox(
//                 width: 90.w,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(top: 2.w, bottom: 3.w),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             height: 9.w,
//                             width: 9.w,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(50),
//                               ),
//                             ),
//                             child: Center(
//                               child: Icon(
//                                   IconData(parentTask.codePoint,
//                                       fontFamily: 'MaterialIcons'),
//                                   size: 5.w,
//                                   color: ColorUtils.getMaterialColorFrom(
//                                       id: parentTask.color)
//                                   // Colors.grey.shade300.withOpacity(0.5),
//                                   ),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 3.w,
//                           ),
//                           Text(
//                             parentTask.title,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SubTaskTitleNotification(
//                         subtask: subtask,
//                         task: parentTask,
//                         onChanged: (value) async {
//                           vibrateFor3time();
//                           subTaskProvider.toggleSubTask(context,
//                               id: subtask.id,
//                               title: subtask.title,
//                               newValue: value);
//                           taskProvider.markTaskCompleted(context, parentTask);
//                         }),
//                     Padding(
//                       padding: EdgeInsets.all(
//                         3.w,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           TextButton(
//                               onPressed: () {
//                                 vibrateForAhalfSeconds();
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => HomePage(),
//                                   ),
//                                 );
//                                 subTaskProvider
//                                     .cancelSubTaskNotification(subtask);
//                               },
//                               child: Text('Home screen',
//                                   style: TextStyle(
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.bold))),
//                           TextButton(
//                               onPressed: () {
//                                 vibrateForAhalfSeconds();
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         SubTaskPage(task: parentTask),
//                                   ),
//                                 );
//                                 subTaskProvider
//                                     .cancelSubTaskNotification(subtask);
//                               },
//                               child: Text('Task screen',
//                                   style: TextStyle(
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.bold))),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           )),
//         ),
//       ),
//     );
//   }
// }
