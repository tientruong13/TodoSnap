import 'dart:async';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/Create_task.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Page/Setting/setting.dart';
import 'package:task_app/Page/calendar/calendar_page.dart';
import 'package:task_app/Page/completed_page/completed_page.dart';
import 'package:task_app/Page/home_page/custom_appbar.dart';
import 'package:task_app/Page/home_page/plus.dart';
import 'package:task_app/Page/home_page/task_page.dart';
import 'package:task_app/Page/name_page/name_notifier.dart';
import 'package:task_app/Page/search/search_page.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/widget/animated_bottom_to_top_widget.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';
import 'package:task_app/widget/color.dart';
import 'package:task_app/widget/custom_dialog.dart';
import 'package:task_app/widget/sliver_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  // List<TaskModel> tsksList = [];
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void startPeriodicUpdates() {
    // Call the update function every hour
    _timer = Timer.periodic(Duration(hours: 1), (timer) async {
      final subTaskDataProvider =
          Provider.of<SubTaskDataProvider>(context, listen: false);
      await subTaskDataProvider.updateAppWidget();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final subTaskDataProvider =
          Provider.of<SubTaskDataProvider>(context, listen: false);
      await subTaskDataProvider.updateAppWidget();
    });
    startPeriodicUpdates();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this)
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 0.8).animate(_controller);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // fetchTasks();
  // }

  // Future<void> fetchTasks() async {
  //   final tasksList = Provider.of<TaskDataProvider>(context, listen: false);
  //   final result = await tasksList.getNotCompletedTasksList;
  //   setState(() {
  //     tsksList = result;
  //   });
  // }

  @override
  void dispose() {
    _controller.dispose();
    // Cancel the timer when the screen is disposed
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nameNotifier = Provider.of<NameNotifier>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Consumer<TaskDataProvider>(
                builder: (context, TaskDataProvider tasksList, child) {
              // ignore: unused_local_variable
              var tsksList = tasksList.getNotCompletedTasksList;

              return Stack(
                children: [
                  if (_selectedIndex == 1) CompletedPage(),
                  if (_selectedIndex == 0)
                    CustomPage(
                      title: AppBarWidget1(nameNotifier: nameNotifier),
                      leading: Icon(
                        Ionicons.chevron_back,
                        size: 2.w,
                        color: mainColorOfLight(context),
                      ),
                      centerTitle: false,
                      backgroundColor: scaffoldBackground(context),
                      headerExpandedHeight: 0.245,
                      switchWidget: false,
                      // headerBottomBar: _selectedIndex == 1
                      //     ? headerBottomBarWidget()
                      //     : Container(),
                      headerWidget: CustomAppBar(),
                      physics: tsksList.isEmpty
                          ? const NeverScrollableScrollPhysics()
                          : const BouncingScrollPhysics(),
                      body: [
                        tsksList.isEmpty ? Container() : TaskPage(),
                      ],
                    ),
                  // if (_selectedIndex == 0)
                  //   tsksList.isEmpty
                  //       ? Positioned(
                  //           child: EmptyHomePageWidget(),
                  //         )
                  //       : Container(),
                  Positioned(
                    bottom: 1.5.h,
                    left: 4.w,
                    child: BottomToTopWidget(
                      index: 2,
                      child: Container(
                        // padding: EdgeInsets.all(8),
                        height: 9.h,
                        width: 83.w,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(6.w)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                                onTap: () {
                                  _onItemTapped(0);
                                  vibrateForAhalfSeconds();
                                },
                                child: Icon(
                                  Ionicons.home,
                                  size: 7.w,
                                )),
                            InkWell(
                                onTap: () {
                                  vibrateForAhalfSeconds();
                                  _onItemTapped(1);
                                },
                                child: Icon(
                                  Ionicons.list,
                                  size: 7.w,
                                )),
                            InkWell(
                              onTap: () {
                                vibrateForAhalfSeconds();
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: CalendarPage()));
                              },
                              child: Hero(
                                tag: 'calendar',
                                child: Icon(
                                  Ionicons.calendar,
                                  size: 7.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2.5.h,
                    left: 23.w,
                    child: BottomToTopWidget(
                      index: 2,
                      child: Container(
                        height: 2.w,
                        width: 2.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: _selectedIndex == 0
                              ? Theme.of(context).scaffoldBackgroundColor
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2.5.h,
                    left: 45.w,
                    child: BottomToTopWidget(
                      index: 2,
                      child: Container(
                        height: 2.w,
                        width: 2.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: _selectedIndex == 1
                              ? Theme.of(context).scaffoldBackgroundColor
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2.7.h,
                    right: 4.w,
                    child: BottomToTopWidget(
                      index: 3,
                      child: InkWell(
                        onTap: () {
                          vibrateForAhalfSeconds();
                          createTask(context);
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
              );
            }),
          ],
        ),
      ),
    );
  }

  headerBottomBarWidget() {
    final taskDataProvider =
        Provider.of<TaskDataProvider>(context, listen: true);
    final completedList = taskDataProvider.getCompletedTasksList;
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
              size: 7.w,
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyHomePageWidget extends StatelessWidget {
  const EmptyHomePageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OpacytiWidget(
      number: 1,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 2.w),
              child: Text(
                'Your List is empty.'.tr(),
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
                        offset:
                            const Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomPaint(
                      foregroundPainter: BoxShadowPainter(
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
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
                    'to start organizing.',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarWidget1 extends StatelessWidget {
  const AppBarWidget1({
    super.key,
    required this.nameNotifier,
  });

  final NameNotifier nameNotifier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 1.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: Row(
              children: [
                Text(
                  "Your list".tr(),
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      vibrateForAhalfSeconds();
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.size,
                              alignment: Alignment.bottomCenter,
                              child: SearchPage()));
                    },
                    icon: Icon(Ionicons.search)),
                IconButton(
                    onPressed: () {
                      vibrateForAhalfSeconds();
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.size,
                              alignment: Alignment.bottomCenter,
                              child: SettingPage()));
                    },
                    icon: Icon(Ionicons.options))
              ],
            ),
          )
        ],
      ),
    );
  }
}
