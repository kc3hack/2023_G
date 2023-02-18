import 'package:flutter/material.dart';


/*
main.dartで

import 'package:alert_app_test1/input_UI_rows.dart';


//HomePageの書式で、画面遷移の実装が保障される。
void main() {
  runApp(const input_ui_rows());
}

を書くと動く。
*/

class input_ui_rows extends StatelessWidget {
  const input_ui_rows({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TXTinputPage(),
    );
  }
}

class TXTinputPage extends StatefulWidget {
  const TXTinputPage({super.key});

  final String title = 'Flutter Demo Home Page';

  @override
  State<TXTinputPage> createState() => _TXTinputPageState();
}

class _TXTinputPageState extends State<TXTinputPage> {

  @override
  void initState() {
    super.initState();

  }

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

              //フレームとラベルがある
              TextFormField(
                maxLines: 20,
                minLines: 20,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration.collapsed(
                  hintText: '例 2023年2月19日 プロダクト提出',
                  //fillColor: Colors.green[100],
                  filled: true,
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