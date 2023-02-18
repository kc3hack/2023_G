import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'flutter_data.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  final String title = '登録されている予定一覧';

  @override
  State<ListPage> createState() => _ListPageState();
}

final footer = Expanded(
    child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.blue, boxShadow: [BoxShadow(blurRadius: 3)]),
        child: const Center(
            child: Text(
          'KC3Hack2023 チームG',
          style: TextStyle(color: Colors.white),
        ))));

class _ListPageState extends State<ListPage> {
  final buttonStyle =
      const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(50, 40)));

  //テスト用通知データ
  NotificationData rndnd() {
    return NotificationData(
      createDateTime:
          DateTime.now().add(Duration(days: Random().nextInt(9) + 1)),
      limitDateTime:
          DateTime.now().add(Duration(days: Random().nextInt(30) + 10)),
      content: "test",
      // description: "desc",
      //remindList: [DateTime(2023, 2, 20), DateTime(2023, 2, 25)],
      //channelId: 123
    );
  }

  void addSchedule() async {
    //Todo:予定追加画面に遷移する
    //現在テスト用
    await (rndnd().saveIntoDatabase());
    reload();
  }

  void reload() async {
    await schedule.getFromDatabase();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    reload();
  }

  bool enableDeleteButton = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton.icon(
                      onPressed: addSchedule,
                      style: const ButtonStyle(
                          fixedSize: MaterialStatePropertyAll(Size(170, 40))),
                      label: const Text(
                        '予定を作成',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      icon: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ),
                  Row(children: [
                    const Text('削除ボタンを表示：'),
                    //cf: https://stackoverflow.com/questions/45924474/how-do-you-detect-the-host-platform-from-dart-code
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? CupertinoSwitch(
                            value: enableDeleteButton,
                            activeColor: Colors.red,
                            onChanged: (b) {
                              setState(() {
                                enableDeleteButton = b;
                              });
                            })
                        : Switch(
                            value: enableDeleteButton,
                            activeColor: Colors.red,
                            onChanged: (b) {
                              setState(() {
                                enableDeleteButton = b;
                              });
                            }),
                  ]),
                ],
              ),
            ),
            //一覧表示
            SizedBox(
              height: size.height - 170,
              width: size.width * 0.9,
              child: schedule.list.length == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            '現在登録されている予定はありません。',
                            style: TextStyle(fontSize: 20),
                          )
                        ])
                  : ListView.builder(
                      itemCount: schedule.list.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: SizedBox(
                              height: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        schedule.list[index].content,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${NotificationData.dateTimeToString(schedule.list[index].limitDateTime)}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87),
                                      )
                                    ],
                                  ),
                                  //削除ボタン
                                  enableDeleteButton
                                      ? IconButton(
                                          onPressed: () async {
                                            //Delete
                                            await NotificationData.deleteNotion(
                                                schedule.list[index].channelId);
                                            //Todo:local_notificationの方も削除する
                                            reload();
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            footer,
          ],
        ),
      ),
    );
  }
}
