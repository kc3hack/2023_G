import 'package:flutter/material.dart';
//import 'package:alert_app_test1/study.dart'; //勉強したときの関数を別クラスから呼ぶ。

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
}

class PulldownBTNPage extends StatefulWidget {
  const PulldownBTNPage({super.key});

  final String title = 'Flutter Demo Home Page';

  @override
  State<PulldownBTNPage> createState() => _PulldownBTNPageState();
}

class _PulldownBTNPageState extends State<PulldownBTNPage> {
  //プルダウンボタンのリストや現在選択されている値を保持するための変数。
  List<DropdownMenuItem> year_list = [];
  int year_index = 1;
  List<DropdownMenuItem> month_list = [];
  int month_index = 1;
  List<DropdownMenuItem> day_list = [];
  int day_index = 1;

  List<DropdownMenuItem> time_list = [];
  int time_index = 1;
  List<DropdownMenuItem>minute_list = [];
  int minute_index = 1;
  List<DropdownMenuItem> second_list = [];
  int second_index = 1;

  //int bdBTNtfs = 20; //ボトムダウンボタンのテキストのフォントサイズ


  @override
  void initState() {
    super.initState();

    //年のプルダウンボタンを5個分作る。
    for (int i = 1; i < 5; i++) {
      year_list.add(DropdownMenuItem(
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
      month_list.add(DropdownMenuItem(
          value: i,
          child: Container(
              alignment: Alignment.center,
              child: Text(
                i.toString(),
                style: const TextStyle(fontSize: 20),
              ))));
    }

    //日のプルダウンボタンを31個分作る。
    for (int i = 1; i <= 31; i++) {
      day_list.add(DropdownMenuItem(
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
      time_list.add(DropdownMenuItem(
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
       minute_list.add(DropdownMenuItem(
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
      second_list.add(DropdownMenuItem(
          value: i,
          child: Container(
              alignment: Alignment.center,
              child: Text(
                i.toString(),
                style: const TextStyle(fontSize: 20),
              ))));
    }
  }



  //テキスト
  static const year_txt = Text(
    '年',
    style: TextStyle(
      color: Colors.black, //文字の色を赤色にする
      fontSize: 30, //文字の大きさを20にする
    ),
  );

  static const month_txt = Text(
    '月',
    style: TextStyle(
      color: Colors.black, //文字の色を赤色にする
      fontSize: 30, //文字の大きさを20にする
    ),
  );

  static const day_txt = Text(
    '日',
    style: TextStyle(
      color: Colors.black, //文字の色を赤色にする
      fontSize: 30, //文字の大きさを20にする
    ),
  );


  static const time_txt = Text(
    '時',
    style: TextStyle(
      color: Colors.black, //文字の色を赤色にする
      fontSize: 30, //文字の大きさを20にする
    ),
  );

  static const minute_txt = Text(
    '分',
    style: TextStyle(
      color: Colors.black, //文字の色を赤色にする
      fontSize: 30, //文字の大きさを20にする
    ),
  );


  static const second_txt = Text(
    '秒',
    style: TextStyle(
      color: Colors.black, //文字の色を赤色にする
      fontSize: 30, //文字の大きさを20にする
    ),
  );




  void dummy() {
    print("押された");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          //columnの中のchildrenの並び方はここで設定できる.
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, //縦軸方向について中心に配置
          crossAxisAlignment: CrossAxisAlignment.center, //横軸方向について中心に配置

          //mainAxisSize: MainAxisSize.min, //Columnの大きさを最小にできる.

          //Columnの子
          children: [

            //上のROWは、年、月、日のUI
            Row(
              //columnの中のchildrenの並び方はここで設定できる.
              mainAxisAlignment: MainAxisAlignment.center, //縦軸方向について中心に配置
              crossAxisAlignment: CrossAxisAlignment.center, //横軸方向について中心に配置

              //mainAxisSize: MainAxisSize.min, //Columnの大きさを最小にできる.

              //Rowの子
              children: [

                //年の数値と文字
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
                          items: year_list,
                          value: year_index,
                          onChanged: (value) {
                            setState(() {
                              year_index = value;
                            });
                          })), //親の内側に見えない壁があり、これ以上に子が膨らめない
                ),
                year_txt,

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
                          items: month_list,
                          value: month_index,
                          onChanged: (value) {
                            setState(() {
                              month_index = value;
                            });
                          })), //親の内側に見えない壁があり、これ以上に子が膨らめない
                ),
                month_txt,

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
                          items: day_list,
                          value: day_index,
                          onChanged: (value) {
                            setState(() {
                              day_index = value;
                            });
                          })), //親の内側に見えない壁があり、これ以上に子が膨らめない
                ),
                day_txt,

              ],
            ),

            //下のROWが時、分、秒のUI
            Row(
              //columnの中のchildrenの並び方はここで設定できる.
              mainAxisAlignment: MainAxisAlignment.center, //縦軸方向について中心に配置
              crossAxisAlignment: CrossAxisAlignment.center, //横軸方向について中心に配置

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
                          items: time_list,
                          value: time_index,
                          onChanged: (value) {
                            setState(() {
                              time_index = value;
                            });
                          })), //親の内側に見えない壁があり、これ以上に子が膨らめない
                ),
                time_txt,

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
                          items: minute_list,
                          value: minute_index,
                          onChanged: (value) {
                            setState(() {
                              minute_index = value;
                            });
                          })), //親の内側に見えない壁があり、これ以上に子が膨らめない
                ),
                minute_txt,

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
                          items: second_list,
                          value: second_index,
                          onChanged: (value) {
                            setState(() {
                              second_index = value;
                            });
                          })), //親の内側に見えない壁があり、これ以上に子が膨らめない
                ),
                second_txt,

              ],
            ),


            //フレームとラベルがある
            TextFormField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2.0,
                   ),
                  ),
                  labelStyle: const TextStyle(
                  fontSize: 30,
                  color: Colors.green,
                ),

                  labelText: '予定を1つ書いてください。(ex賞味、課題、テストの期限)',  //ラベルの文字列
                  floatingLabelStyle: const TextStyle(fontSize: 15), //ラベルの文字の大きさ
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide( //入力前の枠
                      color: Colors.green,
                      width: 1.0,
                    ),
                  ),
                ),
              ),

              //画面遷移ボタン
              TextButton(
                  onPressed : () => dummy(),
                  /*
                  onPressed: () async {
                    await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const XXXXXPage();
                    }));
                  },
                   */
                  child: const Text(
                        'Next',
                        style: TextStyle(
                        fontSize: 30,
                    ),
                  )
              )

            ], //Columnの子

        )

      ),
    );
  }
}

/*
ついでに、Chromeの画面でCtrl+Shift+IでDevToolsが開くんですけど、
そこの左上のスマホとタブレットが重なってるアイコンを押すと画面サイズを指定のデバイスに合わせて、
UIの具合の確認ができます。
 */


