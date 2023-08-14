// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Page/Setting/setting.dart';
import 'package:task_app/Page/name_page/name_notifier.dart';
import 'package:task_app/Page/today_list/list_today.dart';
import 'package:task_app/Page/search/search_page.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';
import 'package:task_app/widget/animation_left_to_right.dart';
import 'package:task_app/widget/color.dart';
import 'package:task_app/widget/font_size.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  late String selectedImage;

  String getRandomGreeting() {
    List<String> greetings = [
      'How are you doing today?',
      'Let\'s make today an amazing day!',
      'Keep up the great work!',
      'Let\'s make the most of this day!',
      'Time to shine!',
      'You\'re doing an amazing job!',
      'Let\'s take on the day together!',
      'Don\'t forget to smile today!',
      'Your determination is admirable!',
      'Seize the day and make it yours!',
    ];

    // Get a random index from the greetings list
    int randomIndex = Random().nextInt(greetings.length);

    return greetings[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    // final nameNotifier = Provider.of<NameNotifier>(context, listen: false);
    final subTaskDataProvider =
        Provider.of<SubTaskDataProvider>(context, listen: true);
    int todaySubtasksCount =
        subTaskDataProvider.getTodayUncompletedSubtasksCount();
    return Padding(
      padding: EdgeInsets.only(top: 4.w, left: 2.w, right: 2.w),
      child: Container(
        // decoration: BoxDecoration(
        //   color: Theme.of(context).cardColor,
        //   borderRadius: BorderRadius.circular(30),
        // ),
        child: Stack(
          children: [
            // Positioned(
            //   top: -3.w,
            //   left: 0,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(50),
            //     child: Image.asset(
            //       'assets/3.png',
            //       width: 100.w,
            //       height: 50.w,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            // Positioned(
            //   top: 4.w,
            //   left: 0,
            //   child: OpacytiWidget(
            //     number: 1,
            //     child: ShaderMask(
            //       shaderCallback: (bounds) {
            //         return LinearGradient(
            //           begin: Alignment.topCenter,
            //           end: Alignment.bottomCenter,
            //           colors: [
            //             Colors.white.withOpacity(0.5),
            //             Colors.transparent
            //           ],
            //         ).createShader(bounds);
            //       },
            //       blendMode: BlendMode.srcIn,
            //       child: SvgPicture.asset(
            //         'assets/11.svg', // Replace 'assets/svg_image.svg' with the path to your SVG file.
            //         width: 97.w,

            //         fit: BoxFit.cover,
            //         color: Colors.white.withOpacity(0.5),

            //         // Optional: set the BoxFit of the SVG image, default is BoxFit.contain.
            //       ),
            //     ),
            //   ),
            // ),
            // Positioned(
            //   top: 10.w,
            //   left: 0,
            //   child: OpacytiWidget(
            //     number: 1,
            //     child: ShaderMask(
            //       shaderCallback: (bounds) {
            //         return LinearGradient(
            //           begin: Alignment.topCenter,
            //           end: Alignment.bottomCenter,
            //           colors: [
            //             Colors.white.withOpacity(0.3),
            //             Colors.transparent
            //           ],
            //         ).createShader(bounds);
            //       },
            //       blendMode: BlendMode.srcIn,
            //       child: SvgPicture.asset(
            //         'assets/12.svg', // Replace 'assets/svg_image.svg' with the path to your SVG file.
            //         width: 95.w,

            //         fit: BoxFit.cover,
            //         color: Colors.white.withOpacity(0.5),

            //         // Optional: set the BoxFit of the SVG image, default is BoxFit.contain.
            //       ),
            //     ),
            //   ),
            // ),
            // Positioned(
            //   left: -1.w,
            //   child: Container(
            //     height: 50.w,
            //     width: 50.w,
            //     child: Opacity(
            //         opacity: 0.5, child: Image.asset('assets/left.png')),
            //   ),
            // ),
            // Positioned(
            //   bottom: -10.h,
            //   right: 0,
            //   child: Container(
            //     height: 80.w,
            //     width: 80.w,
            //     child: Opacity(
            //         opacity: 0.5, child: Image.asset('assets/bottom.png')),
            //   ),
            // ),

            // Positioned.fill(
            //     child: BackdropFilter(
            //         filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            //         child: SizedBox())),
            Container(
              child: Column(
                children: [
                  LeftToRightWidget(
                    index: 1,
                    child: textHomepageWidget(),
                  ),
                  LeftToRightWidget(
                    index: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: Text(getRandomGreeting().tr(),
                            style: TextStyleUtils.title),
                      ),
                    ),
                  ),
                  LeftToRightWidget(
                    index: 3,
                    child: SecondBar(),
                  ),
                  LeftToRightWidget(
                      index: 4,
                      child: todaySubtasksCount == 0
                          ? InkWell(
                              onTap: () {},
                              child: TextWidget(
                                  todaySubtasksCount: todaySubtasksCount),
                            )
                          : InkWell(
                              onTap: () {
                                vibrateForAhalfSeconds();
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: TodaysTasksAndSubTasks()));
                              },
                              child: TextWidget(
                                  todaySubtasksCount: todaySubtasksCount),
                            )),
                ],
              ),
            ),
            Positioned(
              top: 11.h,
              left: 0.w,
              child: LeftToRightWidget(
                index: 5,
                child: ClipRect(
                  child: SvgPicture.asset(
                    'assets/calendar.svg',
                    width: 18.w,
                    height: 20.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class textHomepageWidget extends StatelessWidget {
  const textHomepageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final nameNotifier = Provider.of<NameNotifier>(context);
    return Container(
      padding: EdgeInsets.only(left: 4.w, top: 1.h, bottom: 0.5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Hello'.tr(),
            style: TextStyleUtils.headingMedium,
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.w),
            child: Text(
              '${nameNotifier.name}',
              style: TextStyleUtils.headingLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.todaySubtasksCount,
  });

  final int todaySubtasksCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Positioned(
        //   bottom: 1.w,
        //   right: 1.w,
        //   child: Transform.rotate(
        //     angle: pi / 60,
        //     child: Container(
        //       padding:
        //           EdgeInsets.only(right: 1.w, left: 20.w, top: 0, bottom: 0),
        //       height: 7.5.h,
        //       width: 70.w,
        //       decoration: BoxDecoration(
        //         color: Colors.transparent,
        //         borderRadius: BorderRadius.circular(30),
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.grey.withOpacity(0.5),
        //             spreadRadius: 1,
        //             blurRadius: 0,
        //             offset: Offset(0, 0),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),

        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.w),
          ),
          child: Container(
            // padding: EdgeInsets.only(right: 1.w, left: 20.w, top: 0, bottom: 0),
            height: 8.h,
            width: 90.w,
            decoration: BoxDecoration(
              color: mainColorOfLight(context),
              borderRadius: BorderRadius.circular(6.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Positioned(
                //     // right: 0,
                //     // top: 1.w,
                //     right: 0.w,
                //     child: Container(
                //       height: 20.w,
                //       width: 20.w,
                //       decoration: BoxDecoration(
                //         color: Colors.amber,
                //         borderRadius: BorderRadius.circular(100),
                //       ),
                //     )),

                Positioned(
                  // right: 0,
                  top: -36.5.w,
                  right: -2.w,
                  child: Container(
                    height: 90.w,
                    width: 90.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(500),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1.w,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        height: 80.w,
                        width: 80.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1.w,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            height: 70.w,
                            width: 70.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(500),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1.w,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                height: 60.w,
                                width: 60.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(500),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1.w,
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    height: 50.w,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(500),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        height: 40.w,
                                        width: 40.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(500),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            width: 1.w,
                                          ),
                                        ),
                                        child: Center(
                                          child: Container(
                                            height: 30.w,
                                            width: 30.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.1),
                                                width: 1.w,
                                              ),
                                            ),
                                            child: Center(
                                              child: Container(
                                                height: 20.w,
                                                width: 20.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                    width: 1.w,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Container(
                                                    height: 10.w,
                                                    width: 10.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                        color: Colors.white
                                                            .withOpacity(0.1),
                                                        width: 1.w,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Colors.white54.withOpacity(0.2),
                          mainColorOfLight(context),
                        ],
                      ),
                    ),
                  ),
                ),
                OpacytiWidget(
                  number: 1,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 1.w,
                        left: 18.w,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 70.w,
                            child: Text(
                              todaySubtasksCount == 0
                                  ? 'You don\'t have task, today'.tr()
                                  : 'You have {count} tasks, today'.tr(
                                      namedArgs: {
                                          'count': '$todaySubtasksCount'
                                        }),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SecondBar extends StatelessWidget {
  const SecondBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [IconSearchWidget(), IconSettingWidget()],
    );
  }
}

class IconSettingWidget extends StatelessWidget {
  const IconSettingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        vibrateForAhalfSeconds();
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.size,
                alignment: Alignment.bottomCenter,
                child: SettingPage()));
      },
      icon: Hero(
        tag: 'Setting',
        child: Icon(Ionicons.options),
      ),
    );
  }
}

class IconSearchWidget extends StatelessWidget {
  const IconSearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
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
              return SearchPage();
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
      icon: Hero(
        tag: 'Search',
        child: Icon(Ionicons.search),
      ),
    );
  }
}
