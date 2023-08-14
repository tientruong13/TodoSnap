import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/my_app.dart';

class NotificationManager {
  static ReceivedAction? initialAction;

  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().requestPermissionToSendNotifications();

    await AwesomeNotifications().initialize(
        'resource://drawable/logo_notification',
        [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'basic_channel',
            channelDescription: 'Notification channel for basic tests',
            playSound: true,
            enableVibration: true,
            groupAlertBehavior: GroupAlertBehavior.Children,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private,
            channelShowBadge: true,
            ledColor: Colors.deepPurple,
            defaultColor: Colors.deepPurple,
          )
        ],
        debug: true);

    // initialAction = await AwesomeNotifications()
    //     .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications().actionStream.listen(onActionReceivedMethod);
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print('Action received: ${receivedAction}');

    if (receivedAction.buttonKeyPressed == 'SilentAction' ||
        receivedAction.buttonKeyPressed == 'SilentBackgroundAction') {
      // For background actions, you must hold the execution until the end
      print(
          'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
    } else {
      MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/subTask',
          (route) => (route.settings.name != '/subTask') || route.isFirst,
          arguments: receivedAction);
    }
  }

  Future<void> scheduleNotification(
      int id,
      String title,
      String body,
      SubTaskModel subTask,
      TaskModel task,
      DateTime eventDate,
      TimeOfDay eventTime,
      String payload) async {
    DateTime scheduledDate = DateTime(eventDate.year, eventDate.month,
        eventDate.day, eventTime.hour, eventTime.minute);
    if (scheduledDate.isAfter(DateTime.now())) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: title,
          body: body,
          largeIcon: 'asset://assets/images/icon.png',
          payload: {"id": subTask.id},
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'COMPLETE',
            label: 'Touch to see more detail',
          ),
        ],
        schedule: NotificationCalendar.fromDate(date: scheduledDate),
      );
    } else {
      print("Scheduled date is in the past. Please select a future date.");
    }
  }

  Future<void> scheduleDailyNotification(
      int id,
      String title,
      String body,
      SubTaskModel subTask,
      TaskModel task,
      TimeOfDay eventTime,
      String payload) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        largeIcon: 'asset://assets/images/icon.png',
        payload: {"id": subTask.id},
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'COMPLETE',
          label: 'Touch to see more detail',
        ),
      ],
      schedule: NotificationCalendar(
        hour: eventTime.hour,
        minute: eventTime.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
  }

  Future<void> scheduleWeeklyNotification(
      int id,
      String title,
      String body,
      SubTaskModel subTask,
      TaskModel task,
      int weekday, // from 1 (Monday) to 7 (Sunday)
      TimeOfDay eventTime,
      String payload) async {
    // calculate next occurrence
    var now = DateTime.now();
    var daysUntilNextOccurrence = (weekday - now.weekday + 7) % 7;
    // ignore: unused_local_variable
    var nextOccurrence = now.add(Duration(days: daysUntilNextOccurrence));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        largeIcon: 'asset://assets/images/icon.png',
        payload: {"id": subTask.id},
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'COMPLETE',
          label: 'Touch to see more detail',
        ),
      ],
      schedule: NotificationCalendar(
        weekday: weekday,
        hour: eventTime.hour,
        minute: eventTime.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
  }

  Future<void> scheduleMonthlyNotification(
      int id,
      String title,
      String body,
      SubTaskModel subTask,
      TaskModel task,
      int dayOfMonth,
      TimeOfDay eventTime,
      String payload) async {
    // calculate next occurrence
    var now = DateTime.now();

    // Get the maximum day of next month
    int maxDayNextMonth = DateTime(now.year, now.month + 2, 0).day;

    // Check if the dayOfMonth is within the limit of next month's days
    if (dayOfMonth > maxDayNextMonth) {
      dayOfMonth =
          maxDayNextMonth; // if not, set it to the maximum day of next month
    }

    var nextOccurrence = DateTime(now.year, now.month + 1, dayOfMonth);

    if (nextOccurrence.isBefore(now)) {
      nextOccurrence = DateTime(now.year, now.month + 2, dayOfMonth);
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        largeIcon: 'asset://assets/images/icon.png',
        payload: {"id": subTask.id},
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'COMPLETE',
          label: 'Touch to see more detail',
        ),
      ],
      schedule: NotificationCalendar(
        day: dayOfMonth,
        hour: eventTime.hour,
        minute: eventTime.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
  }

  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }
}
