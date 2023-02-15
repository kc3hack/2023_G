import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/*import 'package:flutter_native_timezone/flutter_native_timezone.dart';
*/
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin =
      null;

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // handle action
  }
  // タイムゾーン設定メソッド
  Future<void> initTimeZone() async {
    tz.initializeTimeZones();
    var jp = tz.getLocation('Asia/Tokyo');
    tz.setLocalLocation(jp);
  }

/*
  // 以下略
  Future<void> _showNotificationWithActions() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'title',
      'body',
      channelDescription: 'channelDescription',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('id_1', 'Action 1'),
        AndroidNotificationAction('id_2', 'Action 2'),
        AndroidNotificationAction('id_3', 'Action 3'),
      ],
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin!
        .show(0, '...', '...', notificationDetails);
  }
*/
  //　通知タップ時メソッド
  Future<void> onSelectNotification(String? payload) async {}
  // アプリがバックグラウンドや終了時の通知タップ時メソッド
  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}
  // 初期化メソッド
  Future<void> Initialization() async {
    const String iconImage = '@mipmap/ic_launcher3';
    if (flutterLocalNotificationsPlugin != null) {
      return;
    }
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    /*flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        .requestPermission();*/
    //タイムゾーン設定
    await initTimeZone();
    // 初期化処理実行
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings(iconImage);
    final DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      //onDidReceiveLocalNotifications: onDidReceiveLocalNotifications,
    );
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin!.initialize(
      initializationSettings,
      //onDidReceiveNotificationResponse: onDidReceiveLocalNotificationResponse,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationRespinse) async {
        //onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      },
    );

    return;
  }

  // 通知設定
  Future<bool> SendLocalNotification(
    String title, // 通知タイトル
    String body, // 通知内容
    DateTime dayTime, // 通知送信時刻
  ) async {
    String channelID = "LocalNotification";
    String channelName = "SpecifiedNotification";
    String icon = "@drawable/favicon";
    if (flutterLocalNotificationsPlugin == null) {
      return false;
    }
    initTimeZone();
    Initialization();
    try {
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        dayTime.year,
        dayTime.month,
        dayTime.day,
        dayTime.hour,
        dayTime.minute,
        dayTime.second,
      );
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channelID,
          channelName,
          channelDescription: "Channel Description.",
        ),
        //iOS: IOSNotificationDetails(),
      );
      // 通知送信予約設定
      await flutterLocalNotificationsPlugin!.zonedSchedule(
          1, title, body, scheduledDate, notificationDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
