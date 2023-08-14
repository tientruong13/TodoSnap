import 'package:flutter/material.dart';

class ColorUtils {
  static const List<Color> defaultColors = [
    Color(0xff16b9fd),
    Color(0xffDC2626),
    Color(0xffEF4444),
    Color(0xffF87171),
    Color(0xffFCA5A5),
    Color(0xffEA580C),
    Color(0xffF97316),
    Color(0xffFB923C),
    Color(0xffFDBA74),
    Color(0xffCA8A04),
    Color(0xffEAB308),
    Color(0xffFACC15),
    Color(0xffFDE047),
    Color(0xff65A30D),
    Color(0xff84CC16),
    Color(0xffA3E635),
    Color(0xffBEF264),
    Color(0xff16A34A),
    Color(0xff22C55E),
    Color(0xff4ADE80),
    Color(0xff86EFAC),
    Color(0xff0D9488),
    Color(0xff14B8A6),
    Color(0xff2DD4BF),
    Color(0xff5EEAD4),
    Color(0xff0284C7),
    Color(0xff0EA5E9),
    Color(0xff38BDF8),
    Color(0xff7DD3FC),
    Color(0xff1D4ED8),
    Color(0xff2563EB),
    Color(0xff3B82F6),
    Color(0xff60A5FA),
    Color(0xff4338CA),
    Color(0xff4F46E5),
    Color(0xff6366F1),
    Color(0xff818CF8),
    Color(0xff6D28D9),
    Color(0xff7C3AED),
    Color(0xff8B5CF6),
    Color(0xffA78BFA),
    Color(0xff7E22CE),
    Color(0xff9333EA),
    Color(0xffA855F7),
    Color(0xffC084FC),
    Color(0xffA21CAF),
    Color(0xffC026D3),
    Color(0xffD946EF),
    Color(0xffE879F9),
    Color(0xffBE185D),
    Color(0xffDB2777),
    Color(0xffEC4899),
    Color(0xffF472B6),
    Color(0xffBE123C),
    Color(0xffE11D48),
    Color(0xffF43F5E),
    Color(0xffFB7185),
    Color(0xff3F3F46),
    Color(0xff52525B),
    Color(0xff71717A),
    Color(0xffA1A1AA),
  ];

  static Map<int, Color> _color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };

  static Map<int, Color> _colors = Map();

  static Map<int, Color> get colors {
    if (_colors.isNotEmpty) {
      return _colors;
    }

    defaultColors.forEach((color) {
      _colors[color.value] = color;
    });
    return _colors;
  }

  static Color getColorFrom({required int id}) {
    return colors[id] ?? Color(0xff16b9fd);
  }

  static MaterialColor getMaterialColorFrom({required int id}) {
    return MaterialColor((colors[id] ?? Color(0xff16b9fd)).value, _color);
  }
}
