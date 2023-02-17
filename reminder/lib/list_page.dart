import 'package:flutter/material.dart';

import 'flutter_data.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  final String title = 'List Page';

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final buttonStyle =
      const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(50, 40)));

  //テスト用通知データ
  var n = NotificationData(
      createDateTime: DateTime.now().add(const Duration(days: 1)),
      limitDateTime: DateTime.now().add(const Duration(days: 20)),
      content: "test",
      // description: "desc",
      remindList: [DateTime(2023, 2, 20), DateTime(2023, 2, 25)],
      channelId: 123);

  void addSchedule() async {
    //Todo:予定追加画面に遷移する
    //現在テスト用
    await n.saveIntoDatabase();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: addSchedule,
                    style: buttonStyle,
                    child: const Icon(Icons.add),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: reload,
                    style: buttonStyle,
                    child: const Icon(Icons.refresh),
                  ),
                ),
              ],
            ),
            //一覧表示
            SizedBox(
              height: size.height * 0.7,
              width: size.width * 0.8,
              child: ListView.builder(
                itemCount: schedule.list.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: SizedBox(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  'limit:${NotificationData.dateTimeToString(schedule.list[index].limitDateTime)}',
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                )
                              ],
                            ),
                            //削除ボタン
                            IconButton(
                                onPressed: () async {
                                  //Delete
                                  await NotificationData.deleteNotion(
                                      schedule.list[index].channelId);
                                  //Todo:local_notificationの方も削除する
                                  reload();
                                },
                                icon: const Icon(Icons.delete))
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
      ),
    );
  }
}
