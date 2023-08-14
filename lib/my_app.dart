// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Page/Setting/language/language_provider.dart';
import 'package:task_app/Page/Setting/theme/presentation/providers/theme_provider.dart';
import 'package:task_app/Page/Setting/theme/presentation/styles/app_themes.dart';
import 'package:task_app/Page/Setting/theme/services/storage/storage_service.dart';
import 'package:task_app/Page/splash_screen.dart';
import 'package:task_app/notification/notification_manager.dart';
import 'package:task_app/notification/task_subtask_notification.dart';
import 'Page/name_page/name_notifier.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.storageService,
    required this.nameNotifier,
    this.initialLink,
  }) : super(key: key);
  final StorageService storageService;
  final NameNotifier nameNotifier;
  final String? initialLink;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const String routeHome = '/', routeNotification = '/subTask';

  bool navigateToTodayTask = false;
  @override
  void initState() {
    NotificationManager.startListeningNotificationEvents();
    super.initState();
    // if (widget.initialLink == 'todoapp://todotasks') {
    //   navigateToTodayTask = true; // set the variable to true
    // }
  }

  List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName) {
    List<Route<dynamic>> pageStack = [];

    if (initialRouteName == routeNotification &&
        NotificationManager.initialAction != null) {
      print('test 1');
      // pageStack.add(MaterialPageRoute(builder: (_) => const HomePage()));
      pageStack.add(MaterialPageRoute(
          builder: (_) => TaskSubtaskNotification(
              receivedAction: NotificationManager.initialAction!)));
    } else {
      pageStack.add(MaterialPageRoute(builder: (_) => const SplashScreen()));
    }
    return pageStack;
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeHome:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case routeNotification:
        ReceivedAction receivedAction = settings.arguments as ReceivedAction;
        print('test 2');
        return MaterialPageRoute(
            builder: (_) =>
                TaskSubtaskNotification(receivedAction: receivedAction));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // if (navigateToTodayTask) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (context) => TodaysTasksAndSubTasks()),
    //       (Route<dynamic> route) =>
    //           false, // removes all previous routes from the stack
    //     );
    //   });
    // }
    return EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('vi'),
        Locale('fr'),
        Locale('de'),
        Locale('zh'),
        Locale('hi'),
        Locale('ru'),
        Locale('pt'),
        Locale('ja'),
        Locale('ko'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
            return Consumer<LanguageProvider>(
                builder: (context, languageProvider, child) {
              return MaterialApp(
                navigatorKey: MyApp.navigatorKey,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: Locale(languageProvider.currentLanguageCode),
                debugShowCheckedModeBanner: false,
                theme: AppThemes.main(
                  primaryColor: themeProvider.selectedPrimaryColor,
                ),
                darkTheme: AppThemes.main(
                  isDark: true,
                  primaryColor: themeProvider.selectedPrimaryColor,
                ),
                themeMode: themeProvider.selectedThemeMode,

                onGenerateRoute: onGenerateRoute,
                onGenerateInitialRoutes: onGenerateInitialRoutes,
                // onGenerateInitialRoutes:
                // (String initialRouteName) {
                //   print('InitialRouteName: $initialRouteName');
                //   print('InitialAction: ${NotificationManager.initialAction}');
                //   List<Route<dynamic>> pageStack = [];

                //   if (initialRouteName == routeNotification &&
                //       NotificationManager.initialAction != null) {
                //     pageStack.add(MaterialPageRoute(
                //             builder: (_) => TestPage(
                //                 receivedAction:
                //                     NotificationManager.initialAction!))
                //         //   PageRouteBuilder(
                //         //   pageBuilder: (_, __, ___) => TestPage(
                //         //       receivedAction: NotificationManager.initialAction!),
                //         //   // TaskSubtaskNotification(
                //         //   //     receivedAction: NotificationManager.initialAction!),
                //         //   transitionDuration: Duration(seconds: 0),
                //         //   opaque: false,
                //         //   barrierColor:
                //         //       Color.fromARGB(255, 235, 235, 235).withOpacity(0.5),
                //         // )
                //         );
                //   } else {
                //     pageStack
                //         .add(MaterialPageRoute(builder: (_) => HomePage()));
                //   }

                //   return pageStack;
                // },
                // onGenerateInitialRoutes: (String initialRouteName) {
                //   print('InitialRouteName: $initialRouteName');
                //   print(
                //       'InitialAction: ${NotificationManager.initialAction}');
                //   List<Route<dynamic>> pageStack = [];
                //   pageStack.add(MaterialPageRoute(
                //       builder: (_) => const SplashScreen()));

                //   if (initialRouteName == routeNotification &&
                //       NotificationManager.initialAction != null) {
                //     pageStack.add(PageRouteBuilder(
                //       pageBuilder: (_, __, ___) => TaskSubtaskNotification(
                //           receivedAction: NotificationManager.initialAction!),
                //       transitionDuration: Duration(seconds: 0),
                //       opaque: false,
                //       barrierColor:
                //           Color.fromARGB(255, 235, 235, 235).withOpacity(0.5),
                //     ));
                //   }

                //   return pageStack;
                // },
                // onGenerateRoute: onGenerateRoute,
                // (settings) {
                //   switch (settings.name) {
                //     case routeHome:
                //       return MaterialPageRoute(
                //           builder: (_) => const SplashScreen());
                //     case routeNotification:
                //       ReceivedAction receivedAction =
                //           settings.arguments as ReceivedAction;
                //       return PageRouteBuilder(
                //         pageBuilder: (_, __, ___) => TaskSubtaskNotification(
                //             receivedAction: receivedAction),
                //         transitionDuration: Duration(seconds: 0),
                //         opaque: false,
                //         barrierColor: Color.fromARGB(255, 235, 235, 235)
                //             .withOpacity(0.5), // set your desired color
                //       );
                //   }
                //   return null;
                // },
              );
            });
          });
        },
      ),
    );
  }
}
