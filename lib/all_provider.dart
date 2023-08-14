// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:task_app/Page/Setting/language/language_provider.dart';
import 'package:task_app/Page/Setting/provider/setting_provider.dart';
import 'package:task_app/Page/Setting/theme/presentation/providers/theme_provider.dart';
import 'package:task_app/Page/Setting/theme/services/storage/storage_service.dart';
import 'package:task_app/Page/name_page/name_notifier.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/my_app.dart';

class AllProvider extends StatelessWidget {
  const AllProvider({
    Key? key,
    required this.storageService,
    required this.nameNotifier,
    required this.initialLink,
  }) : super(key: key);
  final StorageService storageService;
  final NameNotifier nameNotifier;
  final String? initialLink;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TaskDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SubTaskDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingProvider(),
        ),
        ChangeNotifierProvider<NameNotifier>.value(
          value:
              nameNotifier, // Here you use the nameNotifier that you initialized before
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(storageService),
        ),
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(),
        ),
      ],
      child: MyApp(
          nameNotifier: nameNotifier,
          storageService: storageService,
          initialLink: initialLink),
    );
  }
}
