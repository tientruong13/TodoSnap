import 'package:flutter/material.dart';

import '../Page/Setting/theme/presentation/styles/app_colors.dart';

Color backGroundColor = Color(0xFFEAEAEA);

Color mainColorOfLight(BuildContext context) {
  return Theme.of(context).primaryColor;
}

Color mainColorOfDark(BuildContext context) {
  Color primaryOptionShade = AppColors.getShade(Theme.of(context).primaryColor,
      darker: true, value: 0.1);
  return primaryOptionShade;
}

Color scaffoldBackground(BuildContext context) {
  return Theme.of(context).scaffoldBackgroundColor;
}

Color cardColor(BuildContext context) {
  return Theme.of(context).cardColor;
}

Color canvasColor(BuildContext context) {
  return Theme.of(context).canvasColor;
}

Color iconBackgroundColor(BuildContext context) {
  return Theme.of(context).dividerColor.withOpacity(0.1);
}

Color shadowColor(BuildContext context) {
  return Theme.of(context).shadowColor;
}

Color shadowButtonColor(BuildContext context) {
  return Theme.of(context).dividerColor;
}

Color accentColor(BuildContext context) {
  return Theme.of(context).focusColor;
}
