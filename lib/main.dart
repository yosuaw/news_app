import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:news_app/common/navigation.dart';
import 'package:news_app/data/api/api_service.dart';
import 'package:news_app/data/preferences/preferences_helper.dart';
import 'package:news_app/provider/news_provider.dart';
import 'package:news_app/provider/preferences_provider.dart';
import 'package:news_app/provider/scheduling_provider.dart';
import 'package:news_app/ui/article_detail_page.dart';
import 'package:news_app/ui/home_page.dart';
import 'package:news_app/data/model/article.dart';
import 'package:news_app/common/styles.dart';
import 'package:news_app/ui/article_web_view.dart';
import 'package:flutter/material.dart';
import 'package:news_app/utils/background_service.dart';
import 'package:news_app/utils/notification_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.notification.isDenied
      .then((value) => Permission.notification.request());

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvier(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: Consumer<PreferencesProvier>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'News App',
            theme: provider.themeData,
            navigatorKey: navigatorKey,
            builder: (context, child) {
              // for change iOS theme
              return CupertinoTheme(
                data: CupertinoThemeData(
                  brightness:
                      provider.isDarkTheme ? Brightness.dark : Brightness.light,
                ),
                child: Material(
                  child: child,
                ),
              );
            },
            initialRoute: HomePage.routeName,
            routes: {
              HomePage.routeName: (context) => const HomePage(),
              ArticleDetailPage.routeName: (context) => ArticleDetailPage(
                    article:
                        ModalRoute.of(context)?.settings.arguments as Article,
                  ),
              ArticleWebView.routeName: (context) => ArticleWebView(
                    url: ModalRoute.of(context)?.settings.arguments as String,
                  ),
            },
          );
        },
      ),
    );
  }
}
