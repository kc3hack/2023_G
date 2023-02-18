import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reminder/flutter_data.dart';

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
  void readImage() async {
    final jstr = await doOcr(imageFile!);
    Navigator.of(context).pop(jstr);
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
                    Text(
                      'カメラで撮影または選択した画像から日付と内容を読み取り、予定に追加します。',
                      style: TextStyle(fontSize: 20),
                    ),
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
                    const Text(
                      'カメラで撮影',
                      style: TextStyle(fontSize: 20),
                    ),
                    FloatingActionButton(
                      heroTag: 'camera',
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
                    const Text(
                      '写真を選択',
                      style: TextStyle(fontSize: 20),
                    ),
                    FloatingActionButton(
                      heroTag: 'picture',
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
                            heroTag: 'cancel',
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
                            heroTag: 'read',
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
