import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kenkyuu_medicine/List/list_add_model.dart';
import 'package:kenkyuu_medicine/memo_page.dart';

class ListAddPage extends StatelessWidget {
  //タイトル入力フォーム
  Widget titleTextFieldView(BuildContext context, ListAddModel model) {
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
                    model.titleText = titleText;
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
  Widget cameraCornerView(ListAddModel model) {
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
                model.getImagecamera();
              },
              child: model.croppedImageFile != null
                  ? Image.file(File(model.croppedImageFile!.path))
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

  //文字認識
  Widget characterRecognitionView(ListAddModel model, BuildContext context) {
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
              child: InkWell(
                onTap: () async {
                  try {
                    await model.ocr();
                  } catch (e) {
                    print("エラー起きました:$e");
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(e.toString()),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        });
                  }
                },
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
                            builder: (context) => MemoPage(
                                ocrText: model.ocrText != ""
                                    ? model.ocrText!
                                    : "")));
                  },
                  child: TextField(
                    controller: model.textController,
                    //改行を可能にする
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "文字認識された文字が入る",
                    ),
                    onChanged: (ocrText) {
                      model.ocrText = ocrText;
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
  Widget addButton(ListAddModel model, BuildContext context) {
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
        onPressed: () {
          addDialog(model, context);
        },
        child: Text('追加', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  // 追加ダイアログ
  Future addDialog(ListAddModel model, BuildContext context) async {
    try {
      await model.add();
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('追加しました。'),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(e.toString()),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListAddModel>.value(
      value: ListAddModel(),
      child: Scaffold(
          appBar:
              AppBar(backgroundColor: Colors.black, title: const Text('追加')),
          body: Consumer<ListAddModel>(builder: (context, model, child) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque, //画面外タップを検知するために必要
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    titleTextFieldView(context, model),
                    cameraCornerView(model),
                    characterRecognitionView(model, context),
                    addButton(model, context)
                  ],
                ),
              ),
            );
          })),
    );
  }
}
