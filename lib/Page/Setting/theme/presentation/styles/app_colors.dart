import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xff16b9fd);
  static const Color primaryOption2 = Color(0xffDC2626);
  static const Color primaryOption3 = Color(0xffEF4444);
  static const Color primaryOption4 = Color(0xffF87171);
  static const Color primaryOption5 = Color(0xffFCA5A5);

  static const Color primaryOption6 = Color(0xffEA580C);
  static const Color primaryOption7 = Color(0xffF97316);
  static const Color primaryOption8 = Color(0xffFB923C);
  static const Color primaryOption9 = Color(0xffFDBA74);

  static const Color primaryOption10 = Color(0xffCA8A04);
  static const Color primaryOption11 = Color(0xffEAB308);
  static const Color primaryOption12 = Color(0xffFACC15);
  static const Color primaryOption13 = Color(0xffFDE047);

  static const Color primaryOption14 = Color(0xff65A30D);
  static const Color primaryOption15 = Color(0xff84CC16);
  static const Color primaryOption16 = Color(0xffA3E635);
  static const Color primaryOption17 = Color(0xffBEF264);

  static const Color primaryOption18 = Color(0xff16A34A);
  static const Color primaryOption19 = Color(0xff22C55E);
  static const Color primaryOption20 = Color(0xff4ADE80);
  static const Color primaryOption21 = Color(0xff86EFAC);

  static const Color primaryOption22 = Color(0xff0D9488);
  static const Color primaryOption23 = Color(0xff14B8A6);
  static const Color primaryOption24 = Color(0xff2DD4BF);
  static const Color primaryOption25 = Color(0xff5EEAD4);

  static const Color primaryOption26 = Color(0xff0284C7);
  static const Color primaryOption27 = Color(0xff0EA5E9);
  static const Color primaryOption28 = Color(0xff38BDF8);
  static const Color primaryOption29 = Color(0xff7DD3FC);

  static const Color primaryOption30 = Color(0xff1D4ED8);
  static const Color primaryOption31 = Color(0xff2563EB);
  static const Color primaryOption32 = Color(0xff3B82F6);
  static const Color primaryOption33 = Color(0xff60A5FA);

  static const Color primaryOption34 = Color(0xff4338CA);
  static const Color primaryOption35 = Color(0xff4F46E5);
  static const Color primaryOption36 = Color(0xff6366F1);
  static const Color primaryOption37 = Color(0xff818CF8);

  static const Color primaryOption38 = Color(0xff6D28D9);
  static const Color primaryOption39 = Color(0xff7C3AED);
  static const Color primaryOption40 = Color(0xff8B5CF6);
  static const Color primaryOption41 = Color(0xffA78BFA);

  static const Color primaryOption42 = Color(0xff7E22CE);
  static const Color primaryOption43 = Color(0xff9333EA);
  static const Color primaryOption44 = Color(0xffA855F7);
  static const Color primaryOption45 = Color(0xffC084FC);

  static const Color primaryOption46 = Color(0xffA21CAF);
  static const Color primaryOption47 = Color(0xffC026D3);
  static const Color primaryOption48 = Color(0xffD946EF);
  static const Color primaryOption49 = Color(0xffE879F9);

  static const Color primaryOption50 = Color(0xffBE185D);
  static const Color primaryOption51 = Color(0xffDB2777);
  static const Color primaryOption52 = Color(0xffEC4899);
  static const Color primaryOption53 = Color(0xffF472B6);

  static const Color primaryOption54 = Color(0xffBE123C);
  static const Color primaryOption55 = Color(0xffE11D48);
  static const Color primaryOption56 = Color(0xffF43F5E);
  static const Color primaryOption57 = Color(0xffFB7185);

  static const Color primaryOption58 = Color(0xff3F3F46);
  static const Color primaryOption59 = Color(0xff52525B);
  static const Color primaryOption60 = Color(0xff71717A);
  static const Color primaryOption61 = Color(0xffA1A1AA);

  static const Color white = Color(0xffffffff);
  static const Color white50 = Color(0x88ffffff);
  static const Color grayDark = Color(0xffeaeaea);
  static const Color gray = Color(0xFFEAEAEA);
  static const Color text = Color(0xff000000);
  static const Color text50 = Color(0x88000000);
  static const Color black = Color(0xff001424);
  static const Color black50 = Color(0x88001424);
  static const Color blackLight = Color(0xff011f35);

  static List<Color> primaryColorOptions = const [
    primary,
    primaryOption2,
    primaryOption3,
    primaryOption4,
    primaryOption5,
    primaryOption6,
    primaryOption7,
    primaryOption8,
    primaryOption9,
    primaryOption10,
    primaryOption11,
    primaryOption12,
    primaryOption13,
    primaryOption14,
    primaryOption15,
    primaryOption16,
    primaryOption17,
    primaryOption18,
    primaryOption19,
    primaryOption20,
    primaryOption21,
    primaryOption22,
    primaryOption23,
    primaryOption24,
    primaryOption25,
    primaryOption26,
    primaryOption27,
    primaryOption28,
    primaryOption29,
    primaryOption30,
    primaryOption31,
    primaryOption32,
    primaryOption33,
    primaryOption34,
    primaryOption35,
    primaryOption36,
    primaryOption37,
    primaryOption38,
    primaryOption39,
    primaryOption40,
    primaryOption41,
    primaryOption42,
    primaryOption43,
    primaryOption44,
    primaryOption45,
    primaryOption46,
    primaryOption47,
    primaryOption48,
    primaryOption49,
    primaryOption50,
    primaryOption51,
    primaryOption52,
    primaryOption53,
    primaryOption54,
    primaryOption55,
    primaryOption56,
    primaryOption57,
    primaryOption58,
    primaryOption59,
    primaryOption60,
    primaryOption61,
  ];

  static Color getShade(Color color, {bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness(
        (darker ? (hsl.lightness - value) : (hsl.lightness + value))
            .clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static MaterialColor getMaterialColorFromColor(Color color) {
    Map<int, Color> _colorShades = {
      50: getShade(color, value: 0.5),
      100: getShade(color, value: 0.4),
      200: getShade(color, value: 0.3),
      300: getShade(color, value: 0.2),
      400: getShade(color, value: 0.1),
      500: color, //Primary value
      600: getShade(color, value: 0.1, darker: true),
      700: getShade(color, value: 0.15, darker: true),
      800: getShade(color, value: 0.2, darker: true),
      900: getShade(color, value: 0.25, darker: true),
    };
    return MaterialColor(color.value, _colorShades);
  }
}
