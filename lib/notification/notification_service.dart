import 'dart:math';
import 'dart:io';

import 'package:dicoding_flutter_fundamental/model/restaurant.dart';
import 'package:dicoding_flutter_fundamental/notification/received_notification.dart';
import 'package:dicoding_flutter_fundamental/service/restaurant_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final selectNotificationSubject = BehaviorSubject<String?>();
final didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();


class NotificationService {
  static const _channelId = "01";
  static const _channelName = "channel_01";
  static const _channelDesc = "restaurant_app_channel";
  static NotificationService? _instance;

  NotificationService._internal() {
    _instance = this;
  }
  factory NotificationService() => _instance ?? NotificationService._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
          final payload = details.payload;
          selectNotificationSubject.add(payload);
        });
  }

  void requestIOSPermissions(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true, badge: true, sound: true);
  }

  void configureDidReceiveLocalNotificationSubject(BuildContext context, String route) {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
              title: receivedNotification.title != null
                  ? Text(receivedNotification.title ?? "")
                  : null,
              content: receivedNotification.body != null
                  ? Text(receivedNotification.body ?? "")
                  : null,
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('OK'),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    var restaurant = Restaurant.fromRawJson(receivedNotification.payload ?? "{}");
                    await Navigator.pushNamed(context, route,
                        arguments: restaurant);
                  },
                )
              ],
            ),
      );
    });
  }

  void configureSelectNotificationSubject(BuildContext context, String route) {
    selectNotificationSubject.stream.listen((String? payload) async {
      if (payload != null) {
        var restaurant = Restaurant.fromRawJson(payload);
        await Navigator.pushNamed(context, route,
            arguments: restaurant);
      }
    });
  }

  Future<void> showNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    final restaurantService = RestaurantService();
    final random = Random();
    final restaurants = await restaurantService.fetchAllRestaurant();
    final selectedRestaurant = restaurants[random.nextInt(restaurants.length)];

    var largeIconPath = await _downloadAndSaveFile(
        "https://restaurant-api.dicoding.dev/images/small/${selectedRestaurant.pictureId}",
        "largeIcon"
    );

    var bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(largeIconPath),
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      contentTitle: 'Ada restoran baru ${selectedRestaurant.name}',
      htmlFormatContentTitle: true,
      summaryText: 'Restoran baru dengan nama ${selectedRestaurant.name} telah di buka, segera kunjungi untuk mendapatkan diskon menarik',
      htmlFormatSummaryText: true,
    );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      styleInformation: bigPictureStyleInformation,
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    var payload = selectedRestaurant.toRawJson();

    await flutterLocalNotificationsPlugin.show(
        0,
        "Ada restoran baru nih",
        "Restoran baru dengan nama ${selectedRestaurant.name} telah di buka",
        platformChannelSpecifics,
        payload: payload
    );
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(Uri.parse(url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}