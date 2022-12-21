import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:dicoding_flutter_fundamental/notification/notification_service.dart';
import 'package:dicoding_flutter_fundamental/service/background_service.dart';
import 'package:dicoding_flutter_fundamental/utils/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingProvider extends ChangeNotifier {
  static const String notificationKey = "notification_new_restaurant";
  static const int alarmId = 1;

  bool isNotificationActivated = false;

  late SharedPreferences prefs;

  static Future<void> showNotification() async {
    BackgroundService.callback();

    NotificationService notificationService = NotificationService();
    notificationService.showNotification(flutterLocalNotificationsPlugin);
  }

  SettingProvider() {
    initializePreference();
  }

  void initializePreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  void getDefaultSettingValue() async {
    isNotificationActivated = prefs.getBool(notificationKey) ?? false;

    notifyListeners();
  }

  void changeSetting(bool isActivated) async {
    prefs.setBool(notificationKey, isActivated);

    if (isActivated) {
      activateNotification();
    } else {
      deactivateNotification();
    }

    isNotificationActivated = isActivated;
    notifyListeners();
  }

  void activateNotification() async {
    AndroidAlarmManager.periodic(
      const Duration(hours: 24),
      alarmId,
      SettingProvider.showNotification,
      startAt: DateHelper.alarmSpecificTime("11", "00"),
      exact: true,
      wakeup: true,
    );
  }

  void deactivateNotification() async {
    AndroidAlarmManager.cancel(alarmId);
  }

}