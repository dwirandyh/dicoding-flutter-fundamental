import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:dicoding_flutter_fundamental/model/restaurant.dart';
import 'package:dicoding_flutter_fundamental/notification/notification_service.dart';
import 'package:dicoding_flutter_fundamental/pages/detail/restaurant_detail_page.dart';
import 'package:dicoding_flutter_fundamental/pages/detail/restaurant_detail_provider.dart';
import 'package:dicoding_flutter_fundamental/pages/favorite/favorite_provider.dart';
import 'package:dicoding_flutter_fundamental/pages/home/home_provider.dart';
import 'package:dicoding_flutter_fundamental/pages/home/home_tab_bar.dart';
import 'package:dicoding_flutter_fundamental/pages/setting/setting_provider.dart';
import 'package:dicoding_flutter_fundamental/service/background_service.dart';
import 'package:dicoding_flutter_fundamental/service/local_storage_service.dart';
import 'package:dicoding_flutter_fundamental/service/restaurant_service.dart';
import 'package:flutter/material.dart';
import 'pages/home/home_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Background Service
  final BackgroundService service = BackgroundService();
  service.initializeIsolate();
  AndroidAlarmManager.initialize();

  // Notification
  final NotificationService notificationService = NotificationService();
  await notificationService.initNotifications(flutterLocalNotificationsPlugin);
  notificationService.requestIOSPermissions(flutterLocalNotificationsPlugin);


  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider(restaurantService: RestaurantService())),
            ChangeNotifierProvider<RestaurantDetailProvider>(create: (_) => RestaurantDetailProvider(
                restaurantService: RestaurantService(),
                localStorageService: LocalStorageService()
            )),
            ChangeNotifierProvider<FavoriteProvider>(create: (_) => FavoriteProvider(localStorageService: LocalStorageService())),
            ChangeNotifierProvider<SettingProvider>(create: (_) => SettingProvider())
          ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomeTabBar(),
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
            restaurant: ModalRoute.of(context)?.settings.arguments as Restaurant,
        ),
      },
    );
  }
}