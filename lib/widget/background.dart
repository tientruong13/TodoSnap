import 'package:flutter/material.dart';

class BackGroundColor extends StatelessWidget {
  const BackGroundColor({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
        ),
        Align(
          alignment: Alignment(1.5, -1.2),
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(300),
                gradient: RadialGradient(
                  colors: [Colors.blue, Colors.white],
                )),
          ),
        ),
        Align(
          alignment: Alignment(-1.5, -1.2),
          child: Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(300),
                gradient: RadialGradient(
                  colors: [Colors.blue, Colors.white.withOpacity(0.5)],
                )),
          ),
        ),
      ],
    );
  }
}
