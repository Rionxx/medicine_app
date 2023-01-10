import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medicine/Common/base_helper.dart';
import 'package:medicine/Common/db_provider.dart';
import 'package:medicine/Common/file_conroller.dart';
import 'package:medicine/model/medicine.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqflite/sql.dart';
import 'package:image_cropper/image_cropper.dart';

class AddModel extends ChangeNotifier {
  String hospitalText = "";
  String examinationText = "";
  int current = 0;
  File? imageFile;
  XFile? _pickedFile;
  XFile? _croppedImageFile;
  List<String> base64ImageStringList = [];
  List<File> imageFileList = [];

  //カメラの起動
  Future getImageCamera(int? index) async {
    final picker = ImagePicker();
    _pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (_pickedFile != null) {
      //撮った写真を撮り直している
      if (index != null) {
        //DBに保存するために保存先のパスを作る
        imageFileList[index] = await FileController.getImagePath(_pickedFile!);

        //DBへ保存するため、base64文字列へ変換する
        base64ImageStringList[index] =
            Base64Helper().base64String(imageFileList[index].readAsBytesSync());
      } else {
        //あたらしい写真を取得して、保存先のパスを作る
        imageFileList.add(await FileController.getImagePath(_pickedFile!));
        base64ImageStringList.add(
            Base64Helper().base64String(imageFileList.last.readAsBytesSync()));
      }
      //切り取る予定の写真を入れる
      _croppedImageFile = _pickedFile;
      //画像を切りとる
      await _cropImage(_croppedImageFile!);
      //切り終えた画像を入れる
      if (index != null) {
        //切り終えた画像をDBに保存するために保存先のパスを作る
        imageFileList[index] =
            await FileController.getImagePath(_croppedImageFile!);
        //切り終えた画像をDBに保存するために保存先のパスを作る
        base64ImageStringList[index] =
            Base64Helper().base64String(imageFileList[index].readAsBytesSync());
      } else {
        imageFileList.last =
            await FileController.getImagePath(_croppedImageFile!);
        base64ImageStringList.last =
            Base64Helper().base64String(imageFileList.last.readAsBytesSync());
      }
    }
    notifyListeners();
  }

  void onPageIndex(int index) {
    current = index;
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
      _croppedImageFile = XFile(croppedFile.path);
    }
    notifyListeners();
  }

  //時間を取得する
  String getTime() {
    initializeDateFormatting('jp');
    final now = DateTime.now();
    final time = DateFormat('yyyy/MM/dd(E) HH:mm', "ja").format(now);
    return time;
  }

  //追加
  Future add() async {
    if (base64ImageStringList.isEmpty) {
      throw ('写真がありません');
    }
    if (examinationText == "" && hospitalText == "") {
      throw ('病院名と診察科目を入力してください');
    } else if (examinationText == "") {
      throw ('病院名を入力してください');
    } else if (hospitalText == "") {
      throw ('診療科目を入力してください');
    }

    final medicineSaveData = Medicine(
        hospitalText: hospitalText,
        examinationText: examinationText,
        image: base64ImageStringList.toString(),
        time: getTime());
    //データベースに保存する
    insert(medicineSaveData);
    notifyListeners();
  }

  Future<void> insert(Medicine medicine) async {
    final db = await DBProvider.db.database;
    await db.insert('medicine', medicine.fromMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
