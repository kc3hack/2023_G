import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin =
      null;

  // 通知タップ時起爆メソッド
  @pragma('vm:entry-point')
  void notificationTap(NotificationResponse notificationResponse) {}

  // タイムゾーン初期化メソッド
  Future<void> initTimeZone() async {
    tz.initializeTimeZones();
    var jp = tz.getLocation('Asia/Tokyo');
    tz.setLocalLocation(jp);
  }

/*
  * Androidでの通知アクション
  * よく分かっておらず、無くても動作はする。

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
  // なんのためのメソッドかよくわからない三銃士
  Future<void> onSelectNotification(String? payload) async {}
  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}
  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      print('notification payload: $payload');
    }
  }

  // 初期化メソッド
  Future<void> initialization(String iconPath) async {
    if (flutterLocalNotificationsPlugin != null) {
      // 初期化済みの場合キャンセルされる。
      return;
    }
    final String iconImage = iconPath;
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
    // 初期化処理設定
    // Android
    final AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings(iconImage);
    // iOS
    final DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    // 初期化設定インスタンス
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
      //macOS: darwinInitializationSettings,
    );
    // Pluginインスタンス生成
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    // 初期化処理実行
    await flutterLocalNotificationsPlugin!.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationTap, // 通知タップ時
    );

    return;
  }

  // 通知送信メソッド
  Future<bool> sendLocalNotification(
      String title, // 通知タイトル
      String body, // 通知内容
      DateTime dayTime, // 通知送信時刻
      String? iconPath // 通知アイコンパス
      ) async {
    // 各種変数
    String channelID = "LocalNotification";
    String channelName = "SpecifiedNotification";
    String icon = "@drawable/favicon"; // App Icon
    bool flag = false; // 通知送信可否

    if (iconPath == null) {
      iconPath = '@mipmap-xxxhdpi/ic_launcher';
    }

    if (flutterLocalNotificationsPlugin == null) {
      return flag;
    }

    // タイムゾーン初期化
    initTimeZone();
    // 通知設定初期化
    initialization(iconPath);

    try {
      // 通知予約時間設定
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        dayTime.year,
        dayTime.month,
        dayTime.day,
        dayTime.hour,
        dayTime.minute,
        dayTime.second,
      );
      // 通知設定
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
        //macOS: DarwinNotificationDetails(),
      );
      // 通知予約送信
      await flutterLocalNotificationsPlugin!.zonedSchedule(
          1, title, body, scheduledDate, notificationDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
      // 通知即時送信
      /*await flutterLocalNotificationsPlugin!
          .show(0, title, body, notificationDetails, payload: 'item x');*/
      flag = true;
    } catch (e) {
      print(e.toString());
    }
    return flag;
  }
}
