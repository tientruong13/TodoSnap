import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rive/rive.dart';
import 'package:task_app/Page/home_page/home_page.dart';
import 'package:task_app/Page/name_page/name_notifier.dart';
import 'package:task_app/widget/animated_bottom_to_top_widget.dart';

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  bool val = false;
  late FocusNode _textFocusNode;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _textFocusNode = FocusNode();
    _nameController.addListener(() {
      setState(() {}); // Trigger a rebuild whenever the text changes
    });

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _animation = Tween(begin: -1.w, end: 1.w).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color.fromARGB(255, 235, 235, 235),
          child: Stack(
            children: [
              Positioned(
                top: 18.h,
                left: 37.w,
                child: BottomToTopWidget(
                  index: 1,
                  child: Container(
                    height: 25.w,
                    width: 25.w,
                    child: RiveAnimation.asset(
                      'assets/logo1.riv',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(seconds: 1),
                top: 45.h,
                left: _nameController.text.isNotEmpty && _textFocusNode.hasFocus
                    ? 17.w
                    : 21.w,
                child: BottomToTopWidget(
                  index: 2,
                  child: AnimatedContainer(
                    width: _nameController.text.isNotEmpty &&
                            _textFocusNode.hasFocus
                        ? 65.w
                        : 55.w,
                    duration: Duration(seconds: 1),
                    child: Card(
                      elevation: _textFocusNode.hasFocus ? 7 : 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 1.w, right: 1.w),
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3.w),
                          boxShadow: _textFocusNode.hasFocus
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 0),
                                  )
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: 55.w,
                                child: TextField(
                                  controller: _nameController,
                                  focusNode: _textFocusNode,
                                  // autofocus: true,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      left: 2.w,
                                      right: 2.w,
                                      bottom: 0.2.h,
                                    ),
                                    hintText: "Enter Your Name",
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            _nameController.text.isNotEmpty &&
                                    _textFocusNode.hasFocus
                                ? AnimatedOpacity(
                                    opacity: _nameController.text.isEmpty
                                        ? 0.0
                                        : 1.0,
                                    duration: Duration(milliseconds: 1500),
                                    child: InkWell(
                                      onTap: _nameController.text.isEmpty
                                          ? null // Disables the button
                                          : () {
                                              // Provider.of<VibrationProvider>(
                                              //         context,
                                              //         listen: false)
                                              //     .vibrate();
                                              if (_nameController
                                                  .text.isEmpty) {
                                                val = true;
                                              } else {
                                                Provider.of<NameNotifier>(
                                                        context,
                                                        listen: false)
                                                    .setName(
                                                        _nameController.text);
                                                Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) {
                                                      return SlideTransition(
                                                        position: Tween<Offset>(
                                                          begin: Offset(-1, 0),
                                                          end: Offset.zero,
                                                        ).animate(animation),
                                                        child: HomePage(),
                                                      );
                                                    },
                                                    transitionsBuilder:
                                                        (context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child) {
                                                      return child;
                                                    },
                                                  ),
                                                );
                                                val = false;
                                              }
                                              setState(() {});
                                            },
                                      child: Container(
                                        width: 15.w,
                                        height: 4.h,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 142, 44, 226),
                                          borderRadius:
                                              BorderRadius.circular(3.w),
                                        ),
                                        child: Center(
                                          child: _nameController.text.isEmpty
                                              ? Icon(
                                                  Ionicons.caret_forward,
                                                  color: Colors.white,
                                                  size: 7.w,
                                                )
                                              : Transform.translate(
                                                  offset: Offset(
                                                      _animation.value, 0),
                                                  child: Icon(
                                                    Ionicons.caret_forward,
                                                    color: Colors.white,
                                                    size: 7.w,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
