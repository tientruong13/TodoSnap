import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Page/home_page/task_title_and_icon.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';
import 'package:task_app/widget/animated_top_to_bottom_widget.dart';
import 'package:task_app/Page/subtask_page/subtask_title.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final FocusNode _textFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  late Map<String, AnimationController> _animationControllers;

  @override
  void initState() {
    super.initState();
    _animationControllers = {};

    _searchController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          final subTaskProvider =
              Provider.of<SubTaskDataProvider>(context, listen: false);

          // Dispose all existing animation controllers
          _animationControllers.forEach((_, controller) {
            controller.dispose();
          });

          // Clear the map and create new animation controllers for the current subtask list
          _animationControllers.clear();

          for (final subtask in subTaskProvider.searchSubTaskList) {
            _animationControllers[subtask.id] = AnimationController(
              duration: const Duration(milliseconds: 1500),
              vsync: this,
            );
            _animationControllers[subtask.id]!.forward();
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationControllers.forEach((_, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subTaskProvider =
        Provider.of<SubTaskDataProvider>(context, listen: false);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
          child: Scaffold(
              body: Stack(
        children: [
          Positioned(
            top: 70.w,
            left: 20.w,
            child: Hero(
              tag: 'Search',
              child: Material(
                type: MaterialType.transparency,
                child: Icon(
                  Ionicons.search,
                  size: 60.w,
                  color: Colors.grey.shade400.withOpacity(0.3),
                ),
              ),
            ),
          ),
          // Positioned(
          //     top: 70.w,
          //     left: 20.w,
          //     child: Lottie.asset('assets/data.json',
          //         height: 50.w, width: 50.w)),
          Column(
            children: [
              TopToBottomWidget(
                index: 1,
                child: Container(
                  height: 9.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.w),
                      bottomRight: Radius.circular(8.w),
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
                  child: Padding(
                    padding: EdgeInsets.only(right: 3.w),
                    child: Row(
                      children: [
                        OpacytiWidget(
                          number: 1,
                          child: IconButton(
                            onPressed: () {
                              vibrateForAhalfSeconds();
                              Navigator.pop(context);
                              _searchController.clear();
                              _textFocusNode.unfocus();
                              subTaskProvider.searchSubTasksByTitle(
                                  ""); // Add this line to clear search list

                              setState(() {});
                            },
                            icon: Icon(Ionicons.chevron_back),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _textFocusNode,
                            controller: _searchController,
                            autofocus: true,
                            textInputAction: TextInputAction.search,
                            keyboardType: TextInputType.text,
                            onChanged: (value) =>
                                Provider.of<SubTaskDataProvider>(context,
                                        listen: false)
                                    .searchSubTasksByTitle(value),
                            style: TextStyle(
                              fontSize: 18.sp,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              contentPadding: EdgeInsets.only(
                                left: 3.w,
                                right: 2.w,
                                // bottom: 1.w,
                              ),
                              hintText: "Search Tasks".tr(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              // enabledBorder: InputBorder.none,
                              // focusedBorder: InputBorder.none,
                              suffix: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    vibrateForAhalfSeconds();
                                    _searchController.clear();
                                    _textFocusNode.unfocus();
                                    subTaskProvider.searchSubTasksByTitle("");
                                    setState(() {});
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Consumer2<TaskDataProvider, SubTaskDataProvider>(
                  builder:
                      (context, taskDataProvider, subTaskDataProvider, child) {
                    final subTaskList = subTaskDataProvider.searchSubTaskList;

                    final Map<String, List<SubTaskModel>> groupedSubTasks = {};
                    for (final subTask in subTaskList) {
                      if (groupedSubTasks.containsKey(subTask.parent)) {
                        groupedSubTasks[subTask.parent]!.add(subTask);
                      } else {
                        groupedSubTasks[subTask.parent] = [subTask];
                      }
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: groupedSubTasks.length,
                      itemBuilder: (context, index) {
                        final parentId = groupedSubTasks.keys.elementAt(index);
                        final subTasks = groupedSubTasks[parentId];
                        final task = taskDataProvider.getTaskById(parentId);

                        if (task == null) {
                          return SizedBox.shrink();
                        }

                        List<Widget> subTaskWidgets = [];

                        for (var i = 0; i < subTasks!.length; i++) {
                          final subtask = subTasks[i];
                          subTaskWidgets.add(
                            Padding(
                              padding: EdgeInsets.only(left: 16, bottom: 8),

                              // AnimatedListItem(
                              //   key: ValueKey('${subtask.id}_search'),
                              //   index: i,
                              //   length: subTasks.length,
                              //   aniController:
                              //       _animationControllers[subtask.id] ??
                              //           AnimationController(
                              //             duration:
                              //                 const Duration(milliseconds: 1500),
                              //             vsync: this,
                              //           ),
                              //   animationType: AnimationType.flipX,
                              child: SubTaskTitle(
                                index: i,
                                imagePaths: subtask.imagePaths,
                                task: task,
                                detail: subtask.detail,
                                subtask: subtask,
                                onPressed: (context) {
                                  vibrateForAhalfSeconds();
                                  subTaskDataProvider.deleteSubTask(subtask);
                                },
                                onChanged: (value) {
                                  vibrateFor3time();
                                  subTaskDataProvider.toggleSubTask(
                                    context,
                                    id: subtask.id,
                                    title: subtask.title,
                                    newValue: value,
                                  );
                                  taskDataProvider.markTaskCompleted(
                                      context, task);
                                },
                              ),
                            ),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 16, top: 16),
                              child: TaskTitleAndIcon(task: task),
                            ),
                            ...subTaskWidgets,
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ))),
    );
  }
}
