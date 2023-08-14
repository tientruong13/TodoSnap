import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

enum NotificationType {
  Daily,
  Weekly,
  Monthly,
  Custom,
}

BoxShadow shadow = BoxShadow(
  color: Colors.grey.withOpacity(0.2),
  spreadRadius: 1,
  blurRadius: 1,
  offset: const Offset(0, 0),
);

LottieBuilder loadingAnimation = Lottie.asset('assets/loading.json');

DateTime selectedDate = DateTime.now();
String formattedDate = DateFormat('MMM d').format(DateTime.now());
String showToday = DateFormat('MM/dd').format(DateTime.now());
String showWeekday = DateFormat("E").format(DateTime.now()).toUpperCase();
String showTodayFull = DateFormat.yMMMMd().format(DateTime.now());
String formatDate(DateTime date, String format) {
  return DateFormat(format).format(date);
}

Future<bool> customShowDialog(BuildContext context) async {
  Completer<bool> completer = Completer<bool>();
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you really want to delete?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              completer.complete(false);
            },
            child: Text('NO'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              completer.complete(true);
            },
            child: Text('YES'),
          ),
        ],
      );
    },
  );
  return completer.future;
}
