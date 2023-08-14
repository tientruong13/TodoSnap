import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class IconCustom extends StatelessWidget {
  const IconCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            height: 10.w,
            width: 10.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white.withOpacity(0), Colors.white54]),
              borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(25.0),
                  bottomRight: const Radius.circular(25.0)),
              // border: Border.all(width: 0.5.w, color: Colors.white12),
            ),
            child: Center(
              child: Icon(
                Ionicons.options,
                color: Colors.black,
              ),
            ),
          ),
        ),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(25),
        //   child: BackdropFilter(
        //     filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        //     child: Container(
        //       height: 12.w,
        //       width: 12.w,
        //       // decoration: BoxDecoration(
        //       //   gradient: LinearGradient(
        //       //       begin: Alignment.topLeft,
        //       //       end: Alignment.bottomCenter,
        //       //       colors: [Colors.grey, Colors.white30]),
        //       //   borderRadius: BorderRadius.only(
        //       //       bottomLeft: const Radius.circular(25.0),
        //       //       bottomRight: const Radius.circular(25.0)),
        //       //   border: Border.all(width: 0.5.w, color: Colors.white12),
        //       // ),
        //       child: Center(
        //         child: Icon(Ionicons.options),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
