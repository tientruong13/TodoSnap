import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:task_app/Page/home_page/home_page.dart';
import 'package:task_app/Page/name_page/name_notifier.dart';
import 'package:task_app/Page/name_page/name_page.dart';
import 'package:task_app/Page/today_list/list_today.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:uni_links/uni_links.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? incomingLink;

  // @override
  // void initState() {
  //   super.initState();
  //   NotificationManager.startListeningNotificationEvents();
  //   Future.delayed(Duration(seconds: 5)).then((value) {
  //     if (NotificationManager.initialAction != null) {
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //           builder: (context) => TaskSubtaskNotification(
  //             receivedAction: NotificationManager.initialAction!,
  //           ),
  //         ),
  //       );
  //     } else {
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (context) => CheckName()),
  //       );
  //     }
  //   });
  // }
  void handleLink(String? link) {
    if (link != null) {
      incomingLink = link;
    }
  }

  @override
  void initState() {
    super.initState();

    // Check if app was opened from a notification
    getInitialLink().then((initialLink) {
      handleLink(initialLink);
    });

    linkStream.listen((String? link) {
      handleLink(link);
    }, onError: (err) {
      // Handle the error here
    });
    Future.delayed(Duration(seconds: 5)).then((value) {
      final subTaskDataProvider =
          Provider.of<SubTaskDataProvider>(context, listen: false);
      int todaySubtasksCount =
          subTaskDataProvider.getTodayUncompletedSubtasksCount();
      if (incomingLink == 'todoapp://todotasks') {
        if (todaySubtasksCount == 0) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CheckName()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => TodaysTasksAndSubTasks()),
          );
        }
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CheckName()),
        );
      }
    });

    // Future.delayed(Duration(seconds: 5)).then((value) {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => CheckName()),
    //   );
    // });

    // Future.delayed(Duration(seconds: 5)).then((value) {
    //   if (NotificationManager.initialAction != null) {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(
    //           builder: (context) => TaskSubtaskNotification(
    //               receivedAction: NotificationManager.initialAction!)),
    //     );
    //   } else {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => CheckName()),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RiveAnimation.asset(
        'assets/logo.riv',
        fit: BoxFit.cover,
      ),
    );
  }
}

class CheckName extends StatelessWidget {
  const CheckName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final nameNotifier = Provider.of<NameNotifier>(context);

    if (nameNotifier.isNameSet) {
      return HomePage();
    } else {
      return NamePage();
    }
  }
}
