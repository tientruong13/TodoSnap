// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_import
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_app/Model/notification_type.dart';
import 'package:task_app/Model/setting_model.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Model/time_of_day_adapter.dart';
import 'package:task_app/Page/Setting/theme/services/storage/service_locator.dart';
import 'package:task_app/Page/Setting/theme/services/storage/storage_service.dart';
import 'package:task_app/all_provider.dart';
import 'package:task_app/notification/notification_manager.dart';
import 'package:uni_links/uni_links.dart';
import 'Page/name_page/name_notifier.dart';
import 'Page/name_page/name_storage.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await EasyLocalization.ensureInitialized();
  await NotificationManager.initializeLocalNotifications();
  await AwesomeNotifications().requestPermissionToSendNotifications();
  // tz.initializeTimeZones();
  // var currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  // tz.setLocalLocation(tz.getLocation(currentTimeZone));

  setUpServiceLocator();

  await Hive.initFlutter();

  final storageService = getIt<StorageService>();
  await storageService.init();
  Hive.registerAdapter<SettingsModel>(SettingsModelAdapter());
  if (!Hive.isAdapterRegistered(TaskModelAdapter().typeId)) {
    Hive.registerAdapter(TaskModelAdapter());
    if (!Hive.isAdapterRegistered(SubTaskModelAdapter().typeId)) {
      Hive.registerAdapter(SubTaskModelAdapter());
    }
  }
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(NotificationTypeAdapter());
  final nameNotifier = NameNotifier(NameStorage());
  await nameNotifier.init(); // Here you wait for the name to load
// Check for the initial link when the app starts
  String? initialLink;
  try {
    initialLink = await getInitialLink();
  } catch (e) {
    // Handle exception if necessary
  }
  runApp(
    AllProvider(
        storageService: storageService,
        nameNotifier: nameNotifier,
        initialLink: initialLink),
  );
}
