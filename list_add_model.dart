import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kenkyuu_medicine/List/base_helper.dart';
import 'package:kenkyuu_medicine/db_datebase.dart';
import 'package:kenkyuu_medicine/file_conroller.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kenkyuu_medicine/medicine.dart';
import 'package:sqflite/sqflite.dart';

class ListAddModel extends ChangeNotifier {
  String? titleText = "";
  String? ocrText = "";
  int? id;
  XFile? croppedImageFile;
  File? image;
  XFile? _pickedFile;
  String? baseImage;
  var textController = TextEditingController();

  //カメラの起動
  Future getImagecamera() async {
    final picker = ImagePicker();
    _pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (_pickedFile != null) {
      //切り取る予定の写真を入れる
      croppedImageFile = _pickedFile;
      await _cropImage(croppedImageFile!);
      image = await FileController.getImagePath(croppedImageFile!);
      baseImage = Base64Helper().base64String(image!.readAsBytesSync());
    }
    notifyListeners();
  }

  //画像を切り取る
  Future _cropImage(XFile croppedImage) async {
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: croppedImage.path,
      uiSettings: [
        IOSUiSettings(
            hidesNavigationBar: false,
            aspectRatioPickerButtonHidden: false,
            doneButtonTitle: "次へ",
            cancelButtonTitle: "キャンセル"),
      ],
      cropStyle: CropStyle.rectangle,
    );
    if (croppedFile != null) {
      croppedImageFile = XFile(croppedFile.path);
    }
    notifyListeners();
  }

  //現在の時間を取得
  String getTime() {
    initializeDateFormatting('jp');
    final now = DateTime.now();
    final time = DateFormat.yMMMd('ja').format(now);
    return time;
  }

  //文字認識
  Future<void> ocr() async {
    if (image == null) {
      throw ("認識する写真がありません");
    }
    final InputImage imageFile =
        InputImage.fromFilePath(croppedImageFile!.path.toString());
    //読み取る言語を設定する

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    //文字を読み取る処理
    final RecognizedText recognizedText =
        await textRecognizer.processImage(imageFile);

    String text = recognizedText.text;
    ocrText = text;
    textController.text = ocrText!;
    print(ocrText);
    notifyListeners();
  }

  //更新
  Future add() async {
    if (titleText!.isEmpty) {
      throw ("タイトルがありません");
    }
    if (image == null) {
      throw ("写真がありません");
    }

    final addData = Medicine(
        id: id,
        titleText: titleText,
        ocrText: ocrText,
        image: baseImage,
        time: getTime());

    await _update(addData);
    notifyListeners();
  }

  Future _update(Medicine medicine) async {
    final db = await DBProvider.db.database;
    await db.insert('medicine', medicine.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
