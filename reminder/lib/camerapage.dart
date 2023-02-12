import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//参考： https://qiita.com/konatsu_p/items/eb0e8a7ab62ab9d31315

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  final String title = 'Camera Page';

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final picker = ImagePicker();
  File? imageFile;

  //カメラを起動して画像を取得
  Future<void> getPictureFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;
    imageFile = File(pickedFile.path);
  }

  //ギャラリーから写真を選択して取得
  Future<void> getPictureFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    imageFile = File(pickedFile.path);
  }

  //画像から文字を読み取るAPIを使う。名前は要変更
  void readImage() {
    //画像を送信に適した形式に変換
    //APIで送信
    //読み取った日時と内容を受信
    //予定追加画面に遷移し、受信した日時と内容で初期化
    //その後は予定追加画面で修正と追加の確定
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('OCR 予定作成',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            //画像表示(未選択ではそのように表示)
            imageFile == null
                ? Column(children: const <Widget>[
                    Text('カメラで撮影または選択した画像から日付と内容を読み取り、予定に追加します。'),
                    SizedBox(
                      height: 50,
                    )
                  ])
                : Column(children: <Widget>[
                    Image.file(imageFile!),
                  ]),
            Row(
              //カメラ・ギャラリーのボタンを横に並べて表示
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Text('カメラで撮影'),
                    FloatingActionButton(
                      onPressed: () async {
                        await getPictureFromCamera();
                        setState(() {});
                      },
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.photo_camera),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  children: <Widget>[
                    const Text('写真を選択'),
                    FloatingActionButton(
                      onPressed: () async {
                        await getPictureFromGallery();
                        setState(() {});
                      },
                      backgroundColor: Colors.orange,
                      child: const Icon(Icons.photo),
                    ),
                  ],
                ),
                SizedBox(
                  width: imageFile == null ? 0 : 20,
                ),
                imageFile != null
                    ? Column(
                        children: <Widget>[
                          const Text('キャンセル'),
                          FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                imageFile = null;
                              });
                            },
                            backgroundColor: Colors.red,
                            child: const Icon(Icons.cancel),
                          ),
                        ],
                      )
                    : const SizedBox(),
                SizedBox(
                  width: imageFile == null ? 0 : 20,
                ),
                imageFile != null
                    ? Column(
                        children: <Widget>[
                          const Text('読み取り'),
                          FloatingActionButton(
                            onPressed: () {
                              readImage();
                            },
                            backgroundColor: Colors.green,
                            child: const Icon(Icons.text_snippet_outlined),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
