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
  // Androidでの通知アクション
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
  Future<void> onSelectNotification(String? payload) async {}
  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}
  // 通知タップ時のメソッド
  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      print('notification payload: $payload');
    }
    // 画面遷移
    /*
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    );
    */
  }

  // 初期化メソッド
  Future<void> Initialization() async {
    const String iconImage = 'icon path';
    if (flutterLocalNotificationsPlugin != null) {
      return;
    }
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var resultAndroid = await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
    var resultIOS = await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    print(resultAndroid);
    print(resultIOS);
    //タイムゾーン設定
    await initTimeZone();
    // 初期化処理実行
    // Android
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings(iconImage);
    // iOS
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
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {},
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
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
          //importance: Importance.max,
          //priority: Priority.high,
          //ticker: 'ticker', // 旧Androidのステータスバーに表示
        ),
        iOS: DarwinNotificationDetails(),
      );
      // 通知送信予約設定
      /*await flutterLocalNotificationsPlugin!.zonedSchedule(
          1, title, body, scheduledDate, notificationDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);*/
      // 通知送信
      await flutterLocalNotificationsPlugin!
          .show(0, title, body, notificationDetails, payload: 'item x');
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
