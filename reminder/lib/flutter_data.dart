import 'dart:convert';

class NotificationData {
  late DateTime setDateTime; //設定した日時
  late DateTime limitDateTime; //期限
  late String title; //通知のタイトル
  late String description; //詳細
  late int channelID; //通知チャンネルID

  NotificationData(
      {required this.setDateTime,
      required this.limitDateTime,
      required this.title,
      required this.description,
      required this.channelID});

  String toJsonString() {
    Map<String, dynamic> map = {
      "setDateTime": setDateTime.toString(),
      "limitDateTime": limitDateTime.toString(),
      "title": title,
      "description": description,
      "channelID": channelID
    };
    return jsonEncode(map);
  }

  static NotificationData fromJsonString(String jstr) {
    final json = jsonDecode(jstr);
    return NotificationData(
        setDateTime: DateTime.parse(json["setDateTime"].toString()),
        limitDateTime: DateTime.parse(json["limitDateTime"].toString()),
        title: json["title"] as String,
        description: json["description"] as String,
        //remindList: rl,
        channelID: json["channelID"] as int);
  }
}

class Schedule {}
