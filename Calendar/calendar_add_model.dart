import 'dart:ffi';
import 'dart:math';

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
  int? _notificationId;
  List<int>? notificationIdList;
  DateTime _time = DateTime.now();
  DateTime toDay = DateTime.now();
  DateTime? morningDrinkTime;
  DateTime? noonDrinkTime;
  DateTime? nigthDrinkTime;
  int? morningTimeId;
  int? noonTimeId;
  int? nigthTimeId;
  String morningDrinkTimeText = "";
  String noonDrinkTimeText = "";
  String nigthDrinkTimeText = "";
  String notificationTime = '１５分前';
  bool isOn = false;
  final _formatter = DateFormat('yyyy/MM/dd(E) HH:mm', "ja");

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
    morningDrinkTimeText = time;
    notifyListeners();
  }

  void settingNoonTimeDrink(DateTime dateTime) {
    initializeDateFormatting("ja_JP");
    var formatter = DateFormat('HH:mm', "ja");
    final time = formatter.format(dateTime);
    noonDrinkTimeText = time;
    notifyListeners();
  }

  void settingNightTimeDrink(DateTime dateTime) {
    initializeDateFormatting("ja_JP");
    var formatter = DateFormat('HH:mm', "ja");
    final time = formatter.format(dateTime);
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
    }
  }

  void settingNotification(String notificationTimebars) {
    notificationTime = "$notificationTimebars前";
    notifyListeners();
  }

  void covertDataTime(
      {String? time,
      String? morningDrinkTimeText,
      String? noonDrinkTimeText,
      String? nigthDrinkTimeText}) {
    if (time!.isEmpty) {
      if (morningDrinkTimeText!.isEmpty) {
        morningDrinkTime = DateTime.parse(time + morningDrinkTimeText);
      } else if (noonDrinkTimeText!.isEmpty) {
        noonDrinkTime = DateTime.parse(time + noonDrinkTimeText);
      } else if (nigthDrinkTimeText!.isEmpty) {
        nigthDrinkTime = DateTime.parse(time + nigthDrinkTimeText);
      }
    }
  }

  Future _setNotify({int? id, DateTime? time, String? message}) async {
    final scheduleTime = tz.TZDateTime(
        tz.local, time!.year, time.month, time.day, time.hour, time.minute);
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
          '${notificationTime.replaceAll("前", "")}後に${message}になります。\n$titleText',
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
        _time = _time.add(const Duration(minutes: 15) * -1);
        if (morningDrinkTimeText.isNotEmpty) {
          morningDrinkTime!.add(const Duration(minutes: 15) * -1);
        }
        if (noonDrinkTimeText.isNotEmpty) {
          noonDrinkTime!.add(const Duration(minutes: 15) * -1);
        }
        if (nigthDrinkTimeText.isNotEmpty) {
          nigthDrinkTime!.add(const Duration(minutes: 15) * -1);
        }
        break;
      case '３０分前':
        _time = _time.add(const Duration(minutes: 30) * -1);
        if (morningDrinkTimeText.isNotEmpty) {
          morningDrinkTime!.add(const Duration(minutes: 30) * -1);
        }
        if (noonDrinkTimeText.isNotEmpty) {
          noonDrinkTime!.add(const Duration(minutes: 30) * -1);
        }
        if (nigthDrinkTimeText.isNotEmpty) {
          nigthDrinkTime!.add(const Duration(minutes: 30) * -1);
        }
        break;
      case '１時間前':
        _time = _time.add(const Duration(hours: 1) * -1);
        if (morningDrinkTimeText.isNotEmpty) {
          morningDrinkTime!.add(const Duration(hours: 1) * -1);
        }
        if (noonDrinkTimeText.isNotEmpty) {
          noonDrinkTime!.add(const Duration(hours: 1) * -1);
        }
        if (nigthDrinkTimeText.isNotEmpty) {
          nigthDrinkTime!.add(const Duration(hours: 1) * -1);
        }
        break;
      case '２時間前':
        _time = _time.add(const Duration(hours: 2) * -1);
        if (morningDrinkTimeText.isNotEmpty) {
          morningDrinkTime!.add(const Duration(hours: 2) * -1);
        }
        if (noonDrinkTimeText.isNotEmpty) {
          noonDrinkTime!.add(const Duration(hours: 2) * -1);
        }
        if (nigthDrinkTimeText.isNotEmpty) {
          nigthDrinkTime!.add(const Duration(hours: 2) * -1);
        }
        break;
      case '1日前':
        _time = _time.add(const Duration(days: 1) * -1);
        if (morningDrinkTimeText.isNotEmpty) {
          morningDrinkTime!.add(const Duration(days: 1) * -1);
        }
        if (noonDrinkTimeText.isNotEmpty) {
          noonDrinkTime!.add(const Duration(days: 1) * -1);
        }
        if (nigthDrinkTimeText.isNotEmpty) {
          nigthDrinkTime!.add(const Duration(days: 1) * -1);
        }
        break;
      case '2日前':
        _time = _time.add(const Duration(days: 2) * -1);
        if (morningDrinkTimeText.isNotEmpty) {
          morningDrinkTime!.add(const Duration(days: 2) * -1);
        } else if (noonDrinkTimeText.isEmpty) {
          noonDrinkTime!.add(const Duration(days: 2) * -1);
        } else if (nigthDrinkTimeText.isEmpty) {
          nigthDrinkTime!.add(const Duration(days: 2) * -1);
        }
        break;
      default:
    }
  }

  void add() async {
    if (titleText == '') {
      throw ('タイトルが入力されていません');
    }
    if (dateText.isEmpty) {
      throw ('日時が設定されていません');
    }
    if (isOn == true) {
      covertDataTime(
          time: dateText,
          morningDrinkTimeText: morningDrinkTimeText,
          noonDrinkTimeText: noonDrinkTimeText,
          nigthDrinkTimeText: nigthDrinkTimeText);
      if (morningDrinkTimeText.isEmpty) {
        _setNotify(
            id: morningTimeId, time: morningDrinkTime, message: "昼のお薬の時間");
        _setNotify(
            id: morningTimeId, time: morningDrinkTime, message: "夜のお薬の時間");
      }
      if (noonDrinkTimeText.isEmpty) {
        _setNotify(
            id: morningTimeId, time: morningDrinkTime, message: "朝のお薬の時間");
        _setNotify(id: nigthTimeId, time: morningDrinkTime, message: "夜のお薬の時間");
      }
      if (nigthDrinkTimeText.isEmpty) {
        _setNotify(
            id: morningTimeId, time: morningDrinkTime, message: "朝のお薬の時間");
        _setNotify(id: nigthTimeId, time: morningDrinkTime, message: "夜のお薬の時間");
      }
      selectionNotificationTime(notificationTime);
    }
    final calendarSave = Event(
        name: titleText,
        morningDrinkTime: morningDrinkTimeText,
        morningDoasge: morningDoasgeText,
        noonDoasge: noonDoasgeText,
        nightDoasge: nightDoasgeText,
        noonDrinkTime: noonDrinkTimeText,
        nightDrinkTime: nigthDrinkTimeText,
        morningDrinkTimeId: morningTimeId,
        noonDrinkId: noonTimeId,
        nightDoasgeId: nigthTimeId);
    _insert(calendarSave);
  }

  Future _insert(Event event) async {
    final db = await DBProvider.db.database;
    await db.insert('event', event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
