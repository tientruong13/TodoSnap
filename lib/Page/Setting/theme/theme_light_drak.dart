import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Page/Setting/theme/presentation/providers/theme_provider.dart';

class ImageThemeSwitcher extends StatefulWidget {
  @override
  _ImageThemeSwitcherState createState() => _ImageThemeSwitcherState();
}

class _ImageThemeSwitcherState extends State<ImageThemeSwitcher>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      bool isDarkTheme = themeProvider.selectedThemeMode == ThemeMode.dark;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              vibrateForAhalfSeconds();
              setState(() {
                ThemeMode newThemeMode = ThemeMode.light;
                themeProvider.setSelectedThemeMode(newThemeMode);
              });
            },
            child: AnimatedBuilder(
              animation: _animation,
              builder: (_, __) {
                return Stack(
                  children: [
                    Container(
                      height: 12.w,
                      width: 12.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkTheme
                                ? Colors.transparent
                                : Colors.grey.withOpacity(_animation.value),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'assets/sun.png',
                            width: 10.w,
                            height: 10.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              vibrateForAhalfSeconds();
              setState(() {
                ThemeMode newThemeMode = ThemeMode.dark;
                themeProvider.setSelectedThemeMode(newThemeMode);
              });
            },
            child: AnimatedBuilder(
              animation: _animation,
              builder: (_, __) {
                return Container(
                  height: 12.w,
                  width: 12.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkTheme
                            ? Colors.white.withOpacity(_animation.value)
                            : Colors.transparent,
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/moon.png',
                        width: 10.w,
                        height: 10.w,
                        // fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
