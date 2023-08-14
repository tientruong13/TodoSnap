import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/Page/home_page/task.dart';
import 'package:task_app/widget/animated_bottom_to_top_widget.dart';
import 'package:task_app/widget/animated_top_to_bottom_widget.dart';
import 'package:task_app/widget/custom_dialog.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({super.key});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  @override
  Widget build(BuildContext context) {
    final taskDataProvider =
        Provider.of<TaskDataProvider>(context, listen: true);
    final completedList = taskDataProvider.getCompletedTasksList;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TopToBottomWidget(
              index: 1,
              child: Container(
                padding: EdgeInsets.only(left: 7.w, right: 4.w),
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
                    Text(
                      'List Completed'.tr(),
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () async {
                        completedList.isEmpty
                            ? () {}
                            : await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return BottomToTopWidget(
                                    index: 1,
                                    child: CustomDialog(
                                      onPressed: () {
                                        vibrateForAhalfSeconds();
                                        taskDataProvider.deleteAllTask();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                });
                      },
                      icon: Icon(
                        Ionicons.trash,
                        color: Colors.red,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(
                  top: 3.w,
                  left: 5.w,
                  right: 5.w,
                ),
                itemCount: completedList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 5.w,
                  mainAxisSpacing: 5.w,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return TaskTitle(
                    index: index,
                    task: completedList[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
