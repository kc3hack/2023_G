import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'flutter_data.dart';

//cf https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code

class ComTestPage extends StatefulWidget {
  const ComTestPage({super.key});

  final String title = 'Test Page';

  @override
  State<ComTestPage> createState() => _ComTestPageState();
}

class _ComTestPageState extends State<ComTestPage> {
  String infoText = '';

  var n = NotificationData(
    createDateTime: DateTime.now(),
    limitDateTime: DateTime.now().add(const Duration(days: 10)),
    content: "test",
    description: "desc",
    //remindList: [DateTime(2023, 2, 15), DateTime(2023, 2, 22)],
    //channelId: 123
  );

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
                final j = n.toJsonString();
                debugPrint(j);
                n = NotificationData.fromJsonString(j);
                debugPrint(n.toJsonString());
              },
              child: const Text('json'),
            ),
            FloatingActionButton(
              onPressed: () {
                Future(() async {
                  final res = await getDatafromSubURL('/notion');
                  debugPrint(res.toString());
                });
              },
              child: const Text('get'),
            ),
            FloatingActionButton(
              onPressed: () async {
                final res = await n.saveIntoDatabase();
                debugPrint(res.toString());
              },
              child: const Text('n post'),
            ),
            FloatingActionButton(
              onPressed: () async {
                await schedule.getFromDatabase();
              },
              child: const Text('s get'),
            ),
            FloatingActionButton(
              onPressed: () {
                Future(() async {
                  var response = await http.post(
                      Uri.parse('http://127.0.0.1:5000/notion'),
                      headers: {
                        'content-type': 'application/json'
                      },
                      body: {
                        "content": "con",
                        "setDateTime": "2023-02-16 13:00:00"
                      });
                  debugPrint('StatusCode:${response.statusCode.toString()}');
                  debugPrint(response.body.toString());
                });
              },
              child: const Text('post map'),
            ),
            FloatingActionButton(
              onPressed: () {
                Future(() async {
                  debugPrint(jsonEncode({
                    "content": "con",
                    "setDateTime": "2023-02-16 13:00:00"
                  }));
                  var response =
                      await http.post(Uri.parse('http://127.0.0.1:5000/notion'),
                          headers: {'content-type': 'application/json'},
                          body: jsonEncode({
                            "content": "con",
                            "setDateTime": "2023-02-16 13:00:00",
                            "remindList": [
                              "2023-02-17 20:00:00",
                              "2023-03-01 10:00:00"
                            ]
                          }));
                  debugPrint('StatusCode:${response.statusCode.toString()}');
                  debugPrint(response.body.toString());
                });
              },
              child: const Text('post json'),
            ),
          ],
        ),
      ),
    );
  }
}
