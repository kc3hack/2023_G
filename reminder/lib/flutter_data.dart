import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reminder/list_page.dart';

import 'send_local_notification.dart';

final notionUri = Uri.parse('http://127.0.0.1:5000/notion');
final notionHeader = {'content-type': 'application/json'};

var localNotifications = LocalNotifications();

class NotificationData {
  late DateTime createDateTime; //作成した日時
  late DateTime limitDateTime; //期限
  late String content; //通知のタイトル
  late String description; //詳細
  int channelId = 0; //通知チャンネルID
  //late List<DateTime> remindList;

  NotificationData(
      {required this.createDateTime,
      required this.limitDateTime,
      required this.content,
      //required this.remindList,
      required this.description,
      int? channelId}) {
    this.channelId = channelId ?? 0;
  }

  static dateTimeToString(DateTime dt) {
    String zp(int n) {
      return n.toString().padLeft(2, '0');
    }

    return '${dt.year}-${zp(dt.month)}-${zp(dt.day)} ${zp(dt.hour)}:${zp(dt.minute)}:${zp(dt.second)}';
  }

  Map<String, dynamic> toMap() {
    return {
      "createDateTime": dateTimeToString(createDateTime),
      "limitDateTime": dateTimeToString(limitDateTime),
      "content": content,
      //"remindList": remindList.map((e) => dateTimeToString(e)).toList(),
      "description": description,
      "channelId": channelId.toString(),
    };
  }

  String toJsonString() {
    return jsonEncode(toMap());
  }

  static NotificationData fromJsonString(String jstr) {
    final json = jsonDecode(jstr);
    //List<dynamic> sl = json["remindList"];
    //List<DateTime> dl = sl.map((e) => DateTime.parse(e.toString())).toList();
    return NotificationData(
        createDateTime: DateTime.parse(json["createDateTime"].toString()),
        limitDateTime: DateTime.parse(json["limitDateTime"].toString()),
        content: json["content"] as String,
        description: json["description"] ?? '',
        //remindList: dl,
        channelId: json["channelId"] as int);
  }

  //リマインドのタイミングをここで設定
  List<Duration> remindTiming = const [
    Duration(hours: 1),
    Duration(days: 1),
    Duration(days: 7),
    Duration(days: 28)
  ];

  //成功か否かを返す
  Future<bool> createNotification() async {
    final id = await saveIntoDatabase();
    if (id == null) return false;
    final List<DateTime> remindList = [];
    for (int i = 0; i < remindTiming.length; i++) {
      final nextRemindDateTime = createDateTime.add(remindTiming[i]);
      if (nextRemindDateTime.isBefore(limitDateTime)) {
        remindList.add(nextRemindDateTime);
      }
    }
    remindList.add(limitDateTime.subtract(const Duration(days: 1)));
    remindList.add(limitDateTime);
    //通知をOSに登録
    if (isPhone) {
      for (int i = 0; i < remindList.length; i++) {
        LocalNotifications.sendLocalNotification(
            content, description, remindList[i], id);
      }
    }
    return true;
  }

  //データベースに登録。idを返却
  Future<int?> saveIntoDatabase() async {
    var response =
        await http.post(notionUri, headers: notionHeader, body: toJsonString());
    debugPrint(
        '■saveIntoDatabase StatusCode:${response.statusCode.toString()}');
    debugPrint("savedata:" + toJsonString());
    if (response.statusCode != 200) return null;
    debugPrint('response.body:' + response.body);
    return jsonDecode(response.body)["id"] as int?;
  }

  static Future<void> deleteNotion(int id) async {
    await http.delete(Uri.parse('http://127.0.0.1:5000/notion/$id'));
    //Todo:OSの通知解除
    if (isPhone) await LocalNotifications.cancelId(id);
  }

  void print() {
    debugPrint('Notification print');
    debugPrint(toJsonString());
  }

  static NotificationData fromJsonMap(jmap) {
    return NotificationData(
        createDateTime: DateTime.parse(jmap["createDateTime"]),
        limitDateTime: DateTime.parse(jmap["limitDateTime"]),
        content: jmap["content"] as String,
        description: jmap["description"] ?? '',
        //remindList: dl,
        channelId: jmap["channelId"] as int);
  }
}

Schedule schedule = Schedule();

class Schedule {
  List<NotificationData> list = [];

  Future<void> getFromDatabase() async {
    var response = await http.get(notionUri, headers: notionHeader);
    debugPrint('■getFromDatabase StatusCode:${response.statusCode.toString()}');
    if (response.statusCode != 200) return;
    //debugPrint('■' + response.body);

    final List jlist = jsonDecode(response.body);
    list = jlist.map((e) => NotificationData.fromJsonMap(e)).toList();

    /*
    if (response.body.length < 10) {
      list = [];
      return;
    }
    String short = response.body.substring(7, response.body.length - 4);
    debugPrint('■' + short);
    List<String> jlist =
        short.split(RegExp(r'},\s+{')).map((e) => '{$e}').toList();
    debugPrint(jlist.toString());
    list = jlist.map((e) => NotificationData.fromJsonString(e)).toList();
    */
    print();
  }

  void print() {
    debugPrint('Schelude print');
    debugPrint(list.map((e) => '${e.toJsonString()}\n').toList().toString());
  }
}

//画像送信部分（仮）
Future<String?> doOcr(File imageFile) async {
  String base64Image = base64Encode(imageFile.readAsBytesSync());
  String jsonBody = jsonEncode({"image": base64Image});
  debugPrint(jsonBody);
  final response =
      await http.post(Uri.parse("http://127.0.0.1:5000/notioin/ocr"), body: jsonBody);
  debugPrint('■ocr StatusCode:' + response.statusCode.toString());
  if (response.statusCode != 200) return null;
  debugPrint(response.body);
  return response.body;
}

//以下テスト用

Future<void> getHelloWorld() async {
  var jsondata = await getDatafromSubURL('');
  debugPrint(jsondata);
}

Future<void> getRandomId() async {
  final responce = await http
      .get(Uri.parse('http://127.0.0.1:5000/var/${Random().nextInt(100)}'));
  debugPrint(responce.statusCode.toString());
  debugPrint(responce.body);
}

Future<dynamic> getDatafromFullURL(String fullurl) async {
  var response = await http
      .get(Uri.parse(fullurl), headers: {'content-type': 'application/json'});
  debugPrint('StatusCode:${response.statusCode.toString()}');
  //if (response.statusCode != 200) return;
  return jsonDecode(response.body);
}

Future<dynamic> postDataToFullURL(
    String fullurl, Map<String, String> map) async {
  var response = await http.post(Uri.parse(fullurl),
      headers: {'content-type': 'application/json'}, body: jsonEncode(map));
  debugPrint('StatusCode:${response.statusCode.toString()}');
  //if (response.statusCode != 200) return;
  return jsonDecode(response.body);
}

Future<dynamic> getDatafromSubURL(String suburl) async {
  String fullurl = 'http://127.0.0.1:5000$suburl';
  return getDatafromFullURL(fullurl);
}

Future<dynamic> postDataToSubURL(String suburl, Map<String, String> map) async {
  String fullurl = 'http://127.0.0.1:5000$suburl';
  return postDataToFullURL(fullurl, map);
}
