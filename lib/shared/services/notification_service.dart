import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';

class NotificationService extends GetxService {
  static const String prayerChannelKey = 'prayer_channel';
  static const String azkarChannelKey = 'azkar_channel';

  Future<NotificationService> init() async {
    try {
      await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: prayerChannelKey,
            channelName: 'Rappels de prière',
            channelDescription: 'Notifications pour les horaires de prière',
            defaultColor: AppColors.primary,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
          ),
          NotificationChannel(
            channelKey: azkarChannelKey,
            channelName: 'Azkar quotidiens',
            channelDescription: 'Rappels pour les azkar du matin et du soir',
            defaultColor: AppColors.primary,
            importance: NotificationImportance.Default,
            channelShowBadge: true,
          ),
        ],
      );

      final allowed = await AwesomeNotifications().isNotificationAllowed();
      if (!allowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    } catch (_) {}

    return this;
  }

  Future<void> schedulePrayerNotification({
    required int id,
    required String prayerName,
    required String prayerTime,
    required DateTime scheduledTime,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: prayerChannelKey,
        title: '🕌 $prayerName',
        body: "Il est l'heure de la prière $prayerName ($prayerTime)",
        notificationLayout: NotificationLayout.Default,
        color: AppColors.primary,
        wakeUpScreen: true,
        fullScreenIntent: true,
        category: NotificationCategory.Alarm,
      ),
      schedule: NotificationCalendar.fromDate(date: scheduledTime),
    );
  }

  Future<void> scheduleAzkarReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: azkarChannelKey,
        title: title,
        body: body,
        color: AppColors.primary,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        repeats: true,
      ),
    );
  }

  Future<void> cancelAllPrayerNotifications() async {
    await AwesomeNotifications().cancelNotificationsByChannelKey(prayerChannelKey);
  }

  Future<void> cancelAll() async {
    await AwesomeNotifications().cancelAll();
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: azkarChannelKey,
        title: title,
        body: body,
        color: AppColors.primary,
      ),
    );
  }
}
