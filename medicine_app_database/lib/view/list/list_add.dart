import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicine_app_database/view/memo_page.dart';
import 'package:medicine_app_database/database/db_helper.dart';
import 'package:medicine_app_database/model/medicine.dart';
import 'package:medicine_app_database/view/list/list_page.dart';
//import 'package:medicine_app_database/model/file_controller.dart';

class ListAddPage extends StatefulWidget {
  final Medicine? medicine;
  const ListAddPage({Key? key, this.medicine}) : super(key: key);
  @override
  State<ListAddPage> createState() => _ListAddPageState();
}

class _ListAddPageState extends State<ListAddPage> {
  XFile? _pickedFile;
  late String titleText;
  String ocrText = '';
  List<Medicine> medicineList = [];

  late int _id;
  late String _title;
  late String _image;
  late String _ocrtext;
  late String _time;

  @override
  void initState() {
    super.initState();
    _id = widget.medicine?.id ?? 0;
    _title = widget.medicine?.title ?? '';
    _image = widget.medicine?.image ?? '';
    _ocrtext = widget.medicine?.ocrtext ?? '';
    _time = widget.medicine?.time ?? '';
  }

  void _addItem() async {
    final medicine = Medicine(
      id: _id,
      title: _title,
      image: _image,
      ocrtext: _ocrtext,
      time: _time
    );

    await MedicineData.instance.insert(medicine);
  }

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
          width: 350,
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
                width: 250,
                child: TextField(
                  decoration: const InputDecoration(
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
        width: 350,
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
                //カメラを起動
                
              },
              child: _pickedFile != null
                  ? Image.file(File(_pickedFile!.path))
                  : Container(
                      child: Icon(Icons.camera_alt),
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
            const SizedBox(),
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
                    decoration: const InputDecoration(
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
        onPressed: () async {
          //データを追加する関数
          _addItem();
          Navigator.pop(context);
        },
        child: const Text(
            '追加',
            style: TextStyle(
              color: Colors.black, 
              fontWeight: FontWeight.bold
            )
          ),
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
