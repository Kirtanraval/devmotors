import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart'; // Import for permission handling

class SchedulerAlertPage extends StatefulWidget {
  @override
  _SchedulerAlertPageState createState() => _SchedulerAlertPageState();
}

class _SchedulerAlertPageState extends State<SchedulerAlertPage> {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    tz.initializeTimeZones(); // Initialize the timezone database
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _checkAndRequestExactAlarmPermission() async {
    // Check if permission is granted
    if (await Permission.scheduleExactAlarm.request().isGranted) {
      // Permission granted
    } else {
      // Handle permission denied
      print('Exact alarm permission not granted.');
    }
  }

  Future<void> _scheduleNotification() async {
    // Check and request the exact alarm permission before scheduling
    await _checkAndRequestExactAlarmPermission();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'scheduled_channel', // Channel ID
      'Scheduled Notifications', // Channel Name
      channelDescription: 'Channel for scheduled notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule the notification to appear 5 seconds from now
    await _localNotificationsPlugin.zonedSchedule(
      0,
      'Scheduled Notification',
      'This is your scheduled notification!',
      tz.TZDateTime.now(tz.local)
          .add(const Duration(seconds: 5)), // Use TZDateTime
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact, // Required parameter
    );

    print('Notification scheduled!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduler Alert'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _scheduleNotification,
          child: Text('Schedule Notification'),
        ),
      ),
    );
  }
}
