import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';
import 'package:kenkyuu_medicine/db_datebase.dart';
import 'package:kenkyuu_medicine/event.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CalnedarAddModel extends ChangeNotifier {
  String _titleText = "";
  String _dateText = "";
  String _morningDoasgeText = "";
  String _noonDoasgeText = "";
  String _nightDoasgeText = "";
  List<int>? notificationIdList;
  DateTime time = DateTime.now();
  DateTime toDay = DateTime.now();
  DateTime morningDrinkTime = DateTime.now();
  DateTime noonDrinkTime = DateTime.now();
  DateTime nigthDrinkTime = DateTime.now();
  int? morningTimeId;
  int? noonTimeId;
  int? nigthTimeId;
  String morningDrinkTimeText = "";
  String noonDrinkTimeText = "";
  String nigthDrinkTimeText = "";
  String notificationTime = '１５分前';
  bool isOn = false;
  final _formatter = DateFormat('yyyy/MM/dd(E)', "ja");

  String get dateText => _dateText;
  String get titleText => _titleText;
  // 朝の服用量
  String get morningDoasgeText => _morningDoasgeText;
  //昼の服用量
  String get noonDoasgeText => _noonDoasgeText;
  //夜の服用量
  String get nightDoasgeText => _nightDoasgeText;

  set setTitleText(String titleText) {
    _titleText = titleText;
    notifyListeners();
  }

  set setTimeText(String timeText) {
    _dateText = timeText;
    notifyListeners();
  }

  set morningDoasgeText(String doasge) {
    _morningDoasgeText = doasge;
    notifyListeners();
  }

  set noonDoasgeText(String doasge) {
    _noonDoasgeText = doasge;
    notifyListeners();
  }

  set nightDoasgeText(String doasge) {
    _nightDoasgeText = doasge;
    notifyListeners();
  }

  void settingMorningTimeDrink(DateTime dateTime) {
    initializeDateFormatting("ja_JP");
    var formatter = DateFormat('HH:mm', "ja");
    final time = formatter.format(dateTime);
    morningDrinkTime = dateTime;
    morningDrinkTimeText = time;
    notifyListeners();
  }

  void settingNoonTimeDrink(DateTime dateTime) {
    initializeDateFormatting("ja_JP");
    var formatter = DateFormat('HH:mm', "ja");
    final time = formatter.format(dateTime);
    noonDrinkTime = dateTime;
    noonDrinkTimeText = time;
    notifyListeners();
  }

  void settingNightTimeDrink(DateTime dateTime) {
    initializeDateFormatting("ja_JP");
    var formatter = DateFormat('HH:mm', "ja");
    final time = formatter.format(dateTime);
    nigthDrinkTime = dateTime;
    nigthDrinkTimeText = time;
    notifyListeners();
  }

  List<String> dosageList() {
    List<String> doasgeDataList = [];
    for (int i = 0; i < 100; i++) {
      doasgeDataList.add(i.toString());
    }
    return doasgeDataList;
  }

  void onChecked(bool value) {
    isOn = value;
    notifyListeners();
  }

  Future getNotificationId() async {
    morningTimeId = Random().nextInt(10000);
    noonTimeId = Random().nextInt(10000);
    nigthTimeId = Random().nextInt(10000);
    final db = await DBProvider.db.database;
    var res = await db.query('event');
    notificationIdList != null
        ? res.map((data) => Event.fromMap(data).morningDrinkTimeId).toList()
        : null;
    if (notificationIdList == null) return;
    //通知IDが同じ物だったらその都度新しいIDを設定する。
    while (notificationIdList!
        .any((notificationId) => morningTimeId == notificationId)) {
      morningTimeId = Random().nextInt(10000);
      noonTimeId = Random().nextInt(1000);
      nigthTimeId = Random().nextInt(1000);
    }
  }

  void settingNotification(String notificationTimebars) {
    notificationTime = "$notificationTimebars前";
    notifyListeners();
  }

  Future _setNotify(
      {int? id, DateTime? time, DateTime? drinkTime, String? message}) async {
    final scheduleTime = tz.TZDateTime(tz.local, time!.year, time.month,
        time.day, drinkTime!.hour, drinkTime.minute);
    print("時間：${scheduleTime.toString()}");
    final now = DateTime.now();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    NotificationDetails platformChannelSpecifics = const NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      android: null,
    );
    if (scheduleTime.isAfter(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          id!,
          'お薬手アプリKanry',
          '${notificationTime.replaceAll("前", "")}後に${message}になります.',
          scheduleTime,
          platformChannelSpecifics,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    }
  }

  void selectionNotificationTime(String notificationTime) {
    switch (notificationTime) {
      case '１５分前':
        if (morningDrinkTimeText.isNotEmpty) {
          morningDrinkTime =
              morningDrinkTime.subtract(const Duration(minutes: 15));
        }
        if (noonDrinkTimeText.isNotEmpty) {
          noonDrinkTime = noonDrinkTime.add(const Duration(minutes: 15) * -1);
        }
        if (nigthDrinkTimeText.isNotEmpty) {
          nigthDrinkTime = nigthDrinkTime.add(const Duration(minutes: 15) * -1);
        }
        break;
      case '３０分前':
        if (morningDrinkTimeText.isNotEmpty) {
          morningDrinkTime =
              morningDrinkTime.add(const Duration(minutes: 30) * -1);
        }
        if (noonDrinkTimeText.isNotEmpty) {
          noonDrinkTime = noonDrinkTime.add(const Duration(minutes: 30) * -1);
        }
        if (nigthDrinkTimeText.isNotEmpty) {
          nigthDrinkTime = nigthDrinkTime.add(const Duration(minutes: 30) * -1);
        }
        break;
      case '１時間前':
        if (morningDrinkTimeText.isNotEmpty) {
          morningDrinkTime =
              morningDrinkTime.add(const Duration(hours: 1) * -1);
        }
        if (noonDrinkTimeText.isNotEmpty) {
          noonDrinkTime = noonDrinkTime.add(const Duration(hours: 1) * -1);
        }
        if (nigthDrinkTimeText.isNotEmpty) {
          nigthDrinkTime = nigthDrinkTime.add(const Duration(hours: 1) * -1);
        }
        break;
      case '２時間前':
        if (morningDrinkTimeText.isNotEmpty) {
          morningDrinkTime =
              morningDrinkTime.add(const Duration(hours: 2) * -1);
        }
        if (noonDrinkTimeText.isNotEmpty) {
          noonDrinkTime = noonDrinkTime.add(const Duration(hours: 2) * -1);
        }
        if (nigthDrinkTimeText.isNotEmpty) {
          nigthDrinkTime = nigthDrinkTime.add(const Duration(hours: 2) * -1);
        }
        break;
      case '1日前':
        time = time.add(const Duration(days: 1) * -1);
        break;
      case '2日前':
        time = time.add(const Duration(days: 2) * -1);
        break;
      default:
    }
  }

  Future add() async {
    if (titleText == "") {
      throw ('タイトルが入力されていません');
    }
    if (_dateText.isEmpty) {
      throw ('日時が設定されていません');
    }
    if (isOn == true) {
      selectionNotificationTime(notificationTime);
      await getNotificationId();
      if (morningDrinkTimeText.isNotEmpty) {
        await _setNotify(
            id: morningTimeId,
            time: time,
            drinkTime: morningDrinkTime,
            message: "朝のお薬の時間");
      }
      if (noonDrinkTimeText.isNotEmpty) {
        await _setNotify(
            id: noonTimeId,
            time: time,
            drinkTime: noonDrinkTime,
            message: "昼のお薬の時間");
      }
      if (nigthDrinkTimeText.isNotEmpty) {
        await _setNotify(
            id: nigthTimeId,
            time: time,
            drinkTime: nigthDrinkTime,
            message: "夜のお薬の時間");
      }
    }

    Event notificationSave = Event(
        titleText: titleText,
        date: _dateText,
        morningDrinkTime: morningDrinkTimeText,
        morningDoasge: morningDoasgeText,
        noonDoasge: noonDoasgeText,
        noonDrinkTime: noonDrinkTimeText,
        nightDoasge: nightDoasgeText,
        nightDrinkTime: nigthDrinkTimeText,
        morningDrinkTimeId: morningTimeId,
        noonDrinkId: noonTimeId,
        nightDoasgeId: nigthTimeId,
        notificationTime: notificationTime,
        isOn: isOn ? 1 : 0);
    print(notificationSave.toMap());
    await _eventInsert(notificationSave);
  }

  Future _eventInsert(Event event) async {
    print(event.toMap());
    final db = await DBProvider.db.database;
    await db.insert('event', event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
