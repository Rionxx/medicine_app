import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kenkyuu_medicine/memo_page.dart';

class ListAddPage extends StatefulWidget {
  @override
  State<ListAddPage> createState() => _ListAddPageState();
}

class _ListAddPageState extends State<ListAddPage> {
  XFile? _pickedFile;
  String? titleText;
  String ocrText = '';

  //タイトル入力フォーム
  Widget titleTextFieldView(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
        ),
        child: Container(
          height: 60,
          width: 370,
          decoration: BoxDecoration(
            border: Border.all(width: 5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "タイトル",
                  ),
                  onChanged: (titleText) {
                    titleText = titleText;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///カメラコーナー
  Widget cameraCornerView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 250,
        width: 370,
        decoration: BoxDecoration(
          color: Colors.pink[50],
          border: Border.all(width: 5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: 280,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '写真',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: 200,
            height: 180,
            child: InkWell(
              onTap: () async {
                //　カメラを起動
              },
              child: _pickedFile != null
                  ? Image.file(File(_pickedFile!.path))
                  : Container(
                      child: const Icon(Icons.camera_alt),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
        ]),
      ),
    );
  }

  //文字認識コーナー
  Widget characterRecognitionCornerView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 500,
        width: 370,
        decoration: BoxDecoration(
          color: Colors.pink[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black,
            width: 5,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '文字認識',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            SizedBox(),
            //入力欄
            Container(
              height: 400,
              width: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onLongPress: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MemoPage(ocrText: ocrText)));
                  },
                  child: TextField(
                    //改行を可能にする
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "文字認識された文字が入る",
                    ),
                    onChanged: (ocrText) {
                      ocrText = ocrText;
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //追加ボタン
  Widget addButton() {
    return Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 5,
        ),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.pink[50]),
        ),
        onPressed: () {},
        child: Text('追加', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('追加')),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, //画面外タップを検知するために必要
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              titleTextFieldView(context),
              cameraCornerView(),
              characterRecognitionCornerView(),
              addButton()
            ],
          ),
        ),
      ),
    );
  }
}
