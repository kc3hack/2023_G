import 'package:flutter/material.dart';

import 'flutter_data.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  final String title = 'List Page';

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  var n = NotificationData(
      setDateTime: DateTime.now(),
      //  limitDateTime: DateTime.now().add(const Duration(days: 10)),
      content: "test",
      // description: "desc",
      remindList: [DateTime(2023, 2, 15), DateTime(2023, 2, 22)],
      channelId: 123);

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
                ElevatedButton(
                  onPressed: () async {
                    await n.saveIntoDatabase();
                    setState(() {});
                  },
                  child: const Icon(Icons.add),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await schedule.getFromDatabase();
                    setState(() {});
                  },
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.7,
              child: ListView.builder(
                itemCount: schedule.list.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: SizedBox(
                        height: 60,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  schedule.list[index].content,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  NotificationData.dateTimeToString(
                                      schedule.list[index].setDateTime),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                )
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  //キャンセル
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
