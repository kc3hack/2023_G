import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final notionUri = Uri.parse('http://127.0.0.1:5000/notion');
final notionHeader = {'content-type': 'application/json'};

class NotificationData {
  late DateTime setDateTime; //設定した日時
  //late DateTime limitDateTime; //期限
  late String content; //通知のタイトル
  //late String description; //詳細
  late int channelId; //通知チャンネルID
  late List<DateTime> remindList;

  NotificationData(
      {required this.setDateTime,
      //required this.limitDateTime,
      required this.content,
      required this.remindList,
      //required this.description,
      required this.channelId});

  static dateTimeToString(DateTime dt) {
    String zp(int n) {
      return n.toString().padLeft(2, '0');
    }

    return '${dt.year}-${zp(dt.month)}-${zp(dt.day)} ${zp(dt.hour)}:${zp(dt.minute)}:${zp(dt.second)}';
  }

  Map<String, dynamic> toMap() {
    return {
      "setDateTime": dateTimeToString(setDateTime),
      //"limitDateTime": limitDateTime.toString(),
      "content": content,
      "remindList": remindList.map((e) => dateTimeToString(e)).toList(),
      //"description": description,
      "channelId": channelId.toString(),
    };
  }

  String toJsonString() {
    return jsonEncode(toMap());
  }

  static NotificationData fromJsonString(String jstr) {
    final json = jsonDecode(jstr);
    List<dynamic> sl = json["remindList"];
    List<DateTime> dl = sl.map((e) => DateTime.parse(e.toString())).toList();
    return NotificationData(
        setDateTime: DateTime.parse(json["setDateTime"].toString()),
        //limitDateTime: DateTime.parse(json["limitDateTime"].toString()),
        content: json["content"] as String,
        //description: json["description"] as String,
        remindList: dl,
        channelId: json["channelId"] as int);
  }

  Future<String> saveIntoDatabase() async {
    var response =
        await http.post(notionUri, headers: notionHeader, body: toJsonString());
    debugPrint(
        '■saveIntoDatabase StatusCode:${response.statusCode.toString()}');
    debugPrint("savedata:" + toJsonString());
    if (response.statusCode == 500) return '';
    return response.body;
  }

  void print() {
    debugPrint('Notification print');
    debugPrint(toJsonString());
  }
}

Schedule schedule = Schedule();

class Schedule {
  List<NotificationData> list = [];

  Future<void> getFromDatabase() async {
    var response = await http.get(notionUri, headers: notionHeader);
    debugPrint('■getFromDatabase StatusCode:${response.statusCode.toString()}');
    if (response.statusCode != 200) return;
    debugPrint(response.body);
    if (response.body.length < 10) return;
    String short = response.body.substring(7, response.body.length - 4);
    List<String> jlist =
        short.split(RegExp(r'},\s+{')).map((e) => '{$e}').toList();
    debugPrint(jlist.toString());
    list = jlist.map((e) => NotificationData.fromJsonString(e)).toList();
    print();
  }

  void print() {
    debugPrint('Schelude print');
    debugPrint(list.map((e) => e.toJsonString()).toList().toString());
  }
}

//画像送信部分（仮）
Future<void> postImage(File imageFile) async {
  String base64Image = base64Encode(imageFile.readAsBytesSync());
  String jsonBody = jsonEncode({"image": base64Image});
  final response =
      await http.post(Uri.parse("http://127.0.0.1:5000/ocr"), body: jsonBody);
  debugPrint('■postImage StatusCode:' + response.statusCode.toString());
  if (response.statusCode != 200) return;
  debugPrint(response.body);
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
