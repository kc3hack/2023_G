import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reminder/camerapage.dart';
//import 'package:alert_app_test1/study.dart'; //勉強したときの関数を別クラスから呼ぶ。

import 'flutter_data.dart';
import 'list_page.dart';
import 'camerapage.dart';

/*
void main() {
  Study study_ict = Study();

  //study_ict.UseWidget2();
  //study_ict.ColumnRow3();
  //study_ict.Image4();
  //study_ict.Container5();
  //study_ict.StlessWidget6();
  //study_ict.Button7();
  //study_ict.InputTxt();
  //study_ict.PullDownBTN();
}
*/
/*
//HomePageの書式で、画面遷移の実装が保障される。
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PulldownBTNPage(),
    );
  }
}*/

class PulldownBTNPage extends StatefulWidget {
  const PulldownBTNPage({super.key});

  final String title = '予定作成';

  @override
  State<PulldownBTNPage> createState() => _PulldownBTNPageState();
}

class _PulldownBTNPageState extends State<PulldownBTNPage> {
  //プルダウンボタンのリストや現在選択されている値を保持するための変数。
  List<DropdownMenuItem> yearList = [];
  int yearValue = 0;
  List<DropdownMenuItem> monthList = [];
  int monthValue = 0;
  List<DropdownMenuItem> dayList = [];
  int dayValue = 0;

  List<DropdownMenuItem> hourList = [];
  int hourValue = 0;
  List<DropdownMenuItem> minuteList = [];
  int minuteValue = 0;
  List<DropdownMenuItem> secondList = [];
  int secondValue = 0;

  String inputContent = '';
  String inputDescription = '';

  String infoText = '';
  Color infoTextColor = Colors.black;

  //int bdBTNtfs = 20; //ボトムダウンボタンのテキストのフォントサイズ

  //その年、月の日数
  int getDaysOfMonth() {
    final febDays = yearValue % 4 == 0 ? 29 : 28;
    return [0, 31, febDays, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][monthValue];
  }

  void refreshDays() {
    //日のプルダウンボタンを31個分作る。
    dayList = [];
    for (int i = 1; i <= getDaysOfMonth(); i++) {
      dayList.add(DropdownMenuItem(
          value: i,
          child: Container(
              alignment: Alignment.center,
              child: Text(
                i.toString(),
                style: const TextStyle(fontSize: 20),
              ))));
    }
  }

  Future<void> useOcr() async {
    final jstr =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const CameraPage();
    })) as String?;
    if (jstr == null) return;
    inputContent = jsonDecode(jstr)["content"];
    DateTime dt = jsonDecode(jstr)["limitDateTime"];
    yearValue = dt.year;
    monthValue = dt.month;
    dayValue = dt.day;
    hourValue = dt.hour;
  }

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    //年のプルダウンボタンを5個分作る。
    for (int i = now.year; i < now.year + 5; i++) {
      yearList.add(DropdownMenuItem(
          value: i,
          child: Container(
              alignment: Alignment.center,
              child: Text(
                i.toString(),
                style: const TextStyle(fontSize: 20),
              ))));
    }

    //月のプルダウンボタンを12個分作る。
    for (int i = 1; i <= 12; i++) {
      monthList.add(DropdownMenuItem(
          value: i,
          child: Container(
              alignment: Alignment.center,
              child: Text(
                i.toString(),
                style: const TextStyle(fontSize: 20),
              ))));
    }

    //時のプルダウンボタンを12個分作る。
    for (int i = 0; i <= 23; i++) {
      hourList.add(DropdownMenuItem(
          value: i,
          child: Container(
              alignment: Alignment.center,
              child: Text(
                i.toString(),
                style: const TextStyle(fontSize: 20),
              ))));
    }

    //分のプルダウンボタンを60個分作る。
    for (int i = 0; i <= 59; i++) {
      minuteList.add(DropdownMenuItem(
          value: i,
          child: Container(
              alignment: Alignment.center,
              child: Text(
                i.toString(),
                style: const TextStyle(fontSize: 20),
              ))));
    }

    //秒のプルダウンボタンを60個分作る。
    for (int i = 0; i <= 59; i++) {
      secondList.add(DropdownMenuItem(
          value: i,
          child: Container(
              alignment: Alignment.center,
              child: Text(
                i.toString(),
                style: const TextStyle(fontSize: 20),
              ))));
    }

    yearValue = now.year;
    monthValue = now.month;
    dayValue = now.day;
    hourValue = now.hour;

    refreshDays();
  }

  //テキスト
  static const yearText = Text(
    '年',
    style: TextStyle(
      color: Colors.black, //文字の色を赤色にする
      fontSize: 30, //文字の大きさを20にする
    ),
  );

  static const monthText = Text(
    '月',
    style: TextStyle(
      color: Colors.black, //文字の色を赤色にする
      fontSize: 30, //文字の大きさを20にする
    ),
  );

  static const dayText = Text(
    '日',
    style: TextStyle(
      color: Colors.black, //文字の色を赤色にする
      fontSize: 30, //文字の大きさを20にする
    ),
  );

  static const timeText = Text(
    '時',
    style: TextStyle(
      color: Colors.black, //文字の色を赤色にする
      fontSize: 30, //文字の大きさを20にする
    ),
  );

  static const minuteText = Text(
    '分',
    style: TextStyle(
      color: Colors.black, //文字の色を赤色にする
      fontSize: 30, //文字の大きさを20にする
    ),
  );

  static const secondText = Text(
    '秒',
    style: TextStyle(
      color: Colors.black, //文字の色を赤色にする
      fontSize: 30, //文字の大きさを20にする
    ),
  );

  void dummy() {
    debugPrint("押された");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: windowSize.height * 0.8,
              child: Column(
                //columnの中のchildrenの並び方はここで設定できる.
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, //縦軸方向について中心に配置
                crossAxisAlignment: CrossAxisAlignment.center, //横軸方向について中心に配置

                //mainAxisSize: MainAxisSize.min, //Columnの大きさを最小にできる.

                //Columnの子
                children: [
                  //上のROWは、年、月、日のUI
                  Row(
                    //columnの中のchildrenの並び方はここで設定できる.
                    mainAxisAlignment: MainAxisAlignment.center, //縦軸方向について中心に配置
                    crossAxisAlignment:
                        CrossAxisAlignment.center, //横軸方向について中心に配置

                    //mainAxisSize: MainAxisSize.min, //Columnの大きさを最小にできる.

                    //Rowの子
                    children: [
                      //年の数値と文字
                      Container(
                        color: Colors.blueGrey, //青い灰色
                        width: 100, //幅200
                        height: 50, //コンテナでは、カラムやローと違い子供は1人だけ持つことができる。
                        alignment: Alignment.center, //子供の位置を中央上に設定
                        padding: const EdgeInsets.all(7), //高さ130
                        child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: DropdownButton(
                                items: yearList,
                                value: yearValue,
                                onChanged: (value) {
                                  setState(() {
                                    yearValue = value;
                                    refreshDays();
                                  });
                                })), //親の内側に見えない壁があり、これ以上に子が膨らめない
                      ),
                      yearText,

                      //月の数値の文字
                      Container(
                        color: Colors.blueGrey, //青い灰色
                        width: 75, //幅200
                        height: 50, //コンテナでは、カラムやローと違い子供は1人だけ持つことができる。
                        alignment: Alignment.center, //子供の位置を中央上に設定
                        padding: const EdgeInsets.all(7), //高さ130
                        child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: DropdownButton(
                                items: monthList,
                                value: monthValue,
                                onChanged: (value) {
                                  setState(() {
                                    monthValue = value;
                                    refreshDays();
                                  });
                                })), //親の内側に見えない壁があり、これ以上に子が膨らめない
                      ),
                      monthText,

                      //日の数値と文字
                      Container(
                        color: Colors.blueGrey, //青い灰色
                        width: 75, //幅200
                        height: 50, //コンテナでは、カラムやローと違い子供は1人だけ持つことができる。
                        alignment: Alignment.center, //子供の位置を中央上に設定
                        padding: const EdgeInsets.all(7), //高さ130
                        child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: DropdownButton(
                                items: dayList,
                                value: dayValue,
                                onChanged: (value) {
                                  setState(() {
                                    dayValue = value;
                                  });
                                })), //親の内側に見えない壁があり、これ以上に子が膨らめない
                      ),
                      dayText,
                    ],
                  ),

                  //下のROWが時、分、秒のUI
                  Row(
                    //columnの中のchildrenの並び方はここで設定できる.
                    mainAxisAlignment: MainAxisAlignment.center, //縦軸方向について中心に配置
                    crossAxisAlignment:
                        CrossAxisAlignment.center, //横軸方向について中心に配置

                    //mainAxisSize: MainAxisSize.min, //Columnの大きさを最小にできる.

                    //Rowの子
                    children: [
                      //時の数値と文字
                      Container(
                        color: Colors.teal, //青い灰色
                        width: 75, //幅200
                        height: 50, //コンテナでは、カラムやローと違い子供は1人だけ持つことができる。
                        alignment: Alignment.center, //子供の位置を中央上に設定
                        padding: const EdgeInsets.all(7), //高さ130
                        child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: DropdownButton(
                                items: hourList,
                                value: hourValue,
                                onChanged: (value) {
                                  setState(() {
                                    hourValue = value;
                                  });
                                })), //親の内側に見えない壁があり、これ以上に子が膨らめない
                      ),
                      timeText,

                      //分の数値の文字
                      Container(
                        color: Colors.teal, //青い灰色
                        width: 75, //幅200
                        height: 50, //コンテナでは、カラムやローと違い子供は1人だけ持つことができる。
                        alignment: Alignment.center, //子供の位置を中央上に設定
                        padding: const EdgeInsets.all(7), //高さ130
                        child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: DropdownButton(
                                items: minuteList,
                                value: minuteValue,
                                onChanged: (value) {
                                  setState(() {
                                    minuteValue = value;
                                  });
                                })), //親の内側に見えない壁があり、これ以上に子が膨らめない
                      ),
                      minuteText,

                      //秒の数値と文字
                      Container(
                        color: Colors.teal, //青い灰色
                        width: 75, //幅200
                        height: 50, //コンテナでは、カラムやローと違い子供は1人だけ持つことができる。
                        alignment: Alignment.center, //子供の位置を中央上に設定
                        padding: const EdgeInsets.all(7), //高さ130
                        child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: DropdownButton(
                                items: secondList,
                                value: secondValue,
                                onChanged: (value) {
                                  setState(() {
                                    secondValue = value;
                                  });
                                })), //親の内側に見えない壁があり、これ以上に子が膨らめない
                      ),
                      secondText,
                    ],
                  ),

                  //フレームとラベルがある
                  SizedBox(
                      width: windowSize.width * 0.9,
                      child: TextFormField(
                        style: const TextStyle(fontSize: 25),
                        onChanged: (value) {
                          inputContent = value;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 2.0,
                            ),
                          ),
                          labelStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),

                          labelText: 'ここに予定タイトルを入力してください。', //ラベルの文字列
                          floatingLabelStyle:
                              const TextStyle(fontSize: 20), //ラベルの文字の大きさ
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              //入力前の枠
                              color: Colors.green,
                              width: 1.0,
                            ),
                          ),
                        ),
                      )),

                  SizedBox(
                    width: windowSize.width * 0.9,
                    child: TextFormField(
                      style: const TextStyle(fontSize: 25),
                      onChanged: (value) {
                        inputDescription = value;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.green,
                            width: 2.0,
                          ),
                        ),
                        labelStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                        ),

                        labelText: 'ここに詳細を入力してください。(任意)', //ラベルの文字列
                        floatingLabelStyle:
                            const TextStyle(fontSize: 20), //ラベルの文字の大きさ
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            //入力前の枠
                            color: Colors.green,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),

                  ElevatedButton(
                      onPressed: () async {
                        final completed = await NotificationData(
                                content: inputContent,
                                description: inputDescription,
                                createDateTime: DateTime.now(),
                                limitDateTime: DateTime(
                                    yearValue,
                                    monthValue,
                                    dayValue,
                                    hourValue,
                                    minuteValue,
                                    secondValue))
                            .createNotification();
                        if (completed) {
                          infoText = "作成に成功しました";
                          infoTextColor = Colors.black;
                        } else {
                          infoText = "作成に失敗しました";
                          infoTextColor = Colors.red;
                        }
                        setState(() {});
                      },
                      style: const ButtonStyle(
                          fixedSize: MaterialStatePropertyAll(Size(100, 50))),
                      child: const Text(
                        '作成',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      )),

                  ElevatedButton(
                      onPressed: useOcr,
                      style: const ButtonStyle(
                          fixedSize: MaterialStatePropertyAll(Size(240, 70))),
                      child: const Text(
                        'カメラまたは画像から\n読み取って作成',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )),
                  Text(
                    infoText,
                    style: TextStyle(color: infoTextColor, fontSize: 20),
                  )
                ], //Columnの子
              ),
            ),
            footer,
          ],
        ),
      ),
    );
  }
}

/*
ついでに、Chromeの画面でCtrl+Shift+IでDevToolsが開くんですけど、
そこの左上のスマホとタブレットが重なってるアイコンを押すと画面サイズを指定のデバイスに合わせて、
UIの具合の確認ができます。
 */

