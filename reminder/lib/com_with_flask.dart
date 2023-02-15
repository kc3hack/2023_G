import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'flutter_data.dart';

//cf https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code

Future<void> getHelloWorld() async {
  var jsondata = await getDatafromSubURL();
  debugPrint(jsondata);
}

Future<void> getRandomId() async {
  final responce = await http
      .get(Uri.parse('http://127.0.0.1:5000/var/${Random().nextInt(100)}'));
  debugPrint(responce.statusCode.toString());
  debugPrint(responce.body);
}

Future<dynamic> getDatafromFullURL(String fullurl) async {
  var response = await http.get(Uri.parse(fullurl));
  debugPrint('StatusCode:${response.statusCode.toString()}');
  if (response.statusCode != 200) return;
  return jsonDecode(response.body);
}

Future<dynamic> getDatafromSubURL([String suburl = '']) async {
  String fullurl = 'http://127.0.0.1:5000$suburl';
  return getDatafromFullURL(fullurl);
}

class ComTestPage extends StatefulWidget {
  const ComTestPage({super.key});

  final String title = 'Test Page';

  @override
  State<ComTestPage> createState() => _ComTestPageState();
}

class _ComTestPageState extends State<ComTestPage> {
  String infoText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(infoText),
            FloatingActionButton(
              onPressed: () async {
                await getHelloWorld();
              },
              child: const Text('HW'),
            ),
            FloatingActionButton(
              onPressed: () async {
                await getRandomId();
              },
              child: const Text('Rnd'),
            ),
            FloatingActionButton(
              onPressed: () {
                var n = NotificationData(
                    setDateTime: DateTime.now(),
                    limitDateTime: DateTime.now().add(const Duration(days: 10)),
                    title: "test",
                    description: "desc",
                    //remindList: [DateTime(2023, 2, 15), DateTime(2023, 2, 22)],
                    channelID: 123);
                final j = n.toJsonString();
                debugPrint(j);
                n = NotificationData.fromJsonString(j);
                debugPrint(n.toJsonString());
              },
              child: const Text('json'),
            ),
          ],
        ),
      ),
    );
  }
}
