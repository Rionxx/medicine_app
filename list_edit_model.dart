import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kenkyuu_medicine/List/base_helper.dart';
import 'package:kenkyuu_medicine/db_datebase.dart';
import 'package:kenkyuu_medicine/file_conroller.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sqflite/sqflite.dart';
import '../medicine.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class EditModel extends ChangeNotifier {
  EditModel(this.titleText, this.ocrText, this.image, this.id) {
    textController.text = titleText!;
    textController2.text = ocrText!;
    id = id;
    image = image;
  }
  final textController = TextEditingController();
  final textController2 = TextEditingController();
  String? titleText;
  String? ocrText;
  String? image;
  int? id;
  XFile? croppedImageFile;
  File? imageFile;
  XFile? _pickedFile;

  //カメラの起動
  Future getImagecamera() async {
    final picker = ImagePicker();
    _pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (_pickedFile != null) {
      imageFile = await FileController.getImagePath(_pickedFile!);
      //切り取る予定の写真を入れる
      croppedImageFile = _pickedFile;
      await _cropImage(croppedImageFile!);
      imageFile = await FileController.getImagePath(croppedImageFile!);
      final baseImage =
          Base64Helper().base64String(imageFile!.readAsBytesSync());
      image = baseImage;
    }
    notifyListeners();
  }

  //画像を切り取る
  Future _cropImage(XFile croppedImageFile) async {
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: croppedImageFile.path,
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

  //現在の時間を取得
  String getTime() {
    initializeDateFormatting('jp');
    final now = DateTime.now();
    final time = DateFormat.yMMMd('ja').format(now);
    return time;
  }

  //更新
  Future update() async {
    titleText = textController.text;
    ocrText = textController2.text;

    final updateData = Medicine(
        id: id,
        titleText: titleText,
        ocrText: ocrText,
        image: image,
        time: getTime());

    await _update(updateData);
    notifyListeners();
  }

  Future _update(Medicine medicine) async {
    final db = await DBProvider.db.database;
    await db.update('medicine', medicine.toMap(),
        where: "id = ?",
        whereArgs: [medicine.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
