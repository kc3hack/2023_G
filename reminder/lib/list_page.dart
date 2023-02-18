import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder/text_input.dart';
import 'dart:io' as io;

import 'flutter_data.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  final String title = '登録されている予定一覧';

  @override
  State<ListPage> createState() => _ListPageState();
}

final footer = Container(
    width: double.infinity,
    height: 50,
    decoration: const BoxDecoration(
        color: Colors.green, boxShadow: [BoxShadow(blurRadius: 3)]),
    child: const Center(
        child: Text(
      'KC3Hack2023 チームG',
      style: TextStyle(color: Colors.white),
    )));

late Size windowSize;

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
      description: "desc",
      //remindList: [DateTime(2023, 2, 20), DateTime(2023, 2, 25)],
      //channelId: 123
    );
  }

  Future<void> addSchedule() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return PulldownBTNPage();
    }));
    //テスト用
    //await rndnd().saveIntoDatabase();
    reload();
  }

  Future<void> reload() async {
    await schedule.getFromDatabase();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      await reload();
      schedule.print();
    });
  }

  bool enableDeleteButton = false;

  @override
  Widget build(BuildContext context) {
    windowSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: windowSize.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton.icon(
                          onPressed: addSchedule,
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.green),
                              fixedSize:
                                  MaterialStatePropertyAll(Size(170, 40))),
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
                        const Text('削除ボタン：'),
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
                  height: windowSize.height - 200,
                  width: windowSize.width * 0.9,
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
                              elevation: 5,
                              child: ListTile(
                                title: SizedBox(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          Text(
                                            schedule.list[index].content,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                              schedule.list[index].description),
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
                                              iconSize: 30,
                                              onPressed: () async {
                                                //Delete
                                                await NotificationData
                                                    .deleteNotion(schedule
                                                        .list[index].channelId);
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
              ],
            ),
            footer,
          ],
        ),
      ),
    );
  }
}
