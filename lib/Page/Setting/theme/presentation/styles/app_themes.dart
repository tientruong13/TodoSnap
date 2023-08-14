import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:task_app/Page/Setting/theme/presentation/styles/app_colors.dart';
import '../models/app_theme.dart';

class AppThemes {
  static ThemeData main({
    bool isDark = false,
    Color primaryColor = AppColors.primary,
  }) {
    return ThemeData(
      fontFamily: 'TitilliumWeb',
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: isDark
          ? AppColors.getShade(primaryColor, value: 0.1, darker: true)
          : primaryColor,

      scaffoldBackgroundColor: isDark
          ? Color.fromARGB(255, 15, 12, 17)
          : Color.fromARGB(255, 235, 235, 235),
      // Color.fromARGB(255, 242, 242, 242),
      // Color.fromARGB(255, 249, 250, 252)
      cardColor:
          isDark ? AppColors.blackLight : AppColors.white, //task and subtask
      canvasColor: isDark ? AppColors.blackLight : AppColors.white, // container
      dividerColor: isDark
          ? Colors.white.withOpacity(0.5)
          : Colors.black.withOpacity(0.5),
      shadowColor: isDark ? AppColors.text : AppColors.grayDark,
      focusColor: isDark ? Colors.white : Colors.black,
      // accentColor: isDark ? AppColors.white : AppColors.black,
      primarySwatch: AppColors.getMaterialColorFromColor(primaryColor),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: primaryColor,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      ),
    );
  }

  static List<AppTheme> appThemeOptions = [
    AppTheme(
      mode: ThemeMode.light,
      title: 'Light',
      icon: Ionicons.sunny,
    ),
    AppTheme(
      mode: ThemeMode.dark,
      title: 'Dark',
      icon: Ionicons.moon,
    ),
  ];
}
