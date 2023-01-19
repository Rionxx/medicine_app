import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:kenkyuu_medicine/Calendar/calendar_add.dart';
import 'package:kenkyuu_medicine/db_datebase.dart';
import 'package:kenkyuu_medicine/event.dart';
import 'package:table_calendar/table_calendar.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => CalendarState();
}

class CalendarState extends State<CalendarPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  final DateTime _today = DateTime.now();
  Map<DateTime, List> _eventsList = {};
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future getEventList() async {
    _selectedDay = _focusedDay;
    await initializeDateFormatting("ja_JP");
    final db = await DBProvider.db.database;
    final res = await db.query('event');
    //データの読み込み
    if (mounted) {
      setState(() {
        final eventsList = res.map((data) => Event.fromMap(data)).toList();
        if (eventsList.isNotEmpty) {
          _getEvents(eventsList);
        } else {
          _eventsList = {};
        }
      });
    }
  }

  Future _delete(int id) async {
    final db = await DBProvider.db.database;
    await db.delete('event', where: "id = ?", whereArgs: [id]);
  }

  Future<void> _cancelNotifiacation(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  _getEvents(List<Event> events) {
    var _formatter = DateFormat('yyyy/MM/dd(E) HH:mm', "ja");
    _eventsList = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    events.forEach((event) {
      final time = _formatter.parse(event.date!);
      DateTime date = DateTime.utc(time.year, time.month, time.day, time.hour);
      if (_eventsList[date] == null) _eventsList[date] = [];
      //今日の日付より前の日だったら消す。
      if (date.isBefore(_today)) {
        _delete(event.id!);
      } else {
        _eventsList[date]!.add(event);
      }
    });
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    getEventList();
  }

  @override
  Widget build(BuildContext context) {
    List _getEventForDay(DateTime day) {
      return _eventsList[day] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalendarAddPage(),
                    fullscreenDialog: true,
                  ),
                );
                getEventList();
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          //カレンダー
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.black),
              child: TableCalendar(
                locale: 'ja_JP',
                firstDay: DateTime.now(),
                lastDay: DateTime.utc(2050, 12, 31),
                focusedDay: _focusedDay,
                eventLoader: _getEventForDay, //追記
                calendarFormat: _calendarFormat,
                headerStyle: const HeaderStyle(
                    titleTextStyle: TextStyle(color: Colors.white),
                    formatButtonVisible: false,
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: Colors.white),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: Colors.white)),
                calendarStyle: const CalendarStyle(
                  todayTextStyle: TextStyle(color: Colors.black),
                  selectedTextStyle: TextStyle(color: Colors.black),
                  rangeStartTextStyle: TextStyle(color: Colors.white),
                  weekendTextStyle: TextStyle(color: Colors.white),
                  weekNumberTextStyle: TextStyle(color: Colors.white),
                  holidayTextStyle: TextStyle(color: Colors.white),
                  disabledTextStyle: TextStyle(color: Colors.white),
                  rangeHighlightColor: Colors.white,
                  withinRangeTextStyle: TextStyle(color: Colors.white),
                  outsideTextStyle: TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  markerDecoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.white),
                    weekendStyle: TextStyle(color: Colors.white)),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarBuilders: CalendarBuilders(
                  disabledBuilder: (BuildContext context, DateTime day,
                      DateTime focusedDay) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: EdgeInsets.zero,
                      alignment: Alignment.topCenter,
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                  defaultBuilder: (BuildContext context, DateTime day,
                      DateTime focusedDay) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: EdgeInsets.zero,
                      alignment: Alignment.topCenter,
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  //曜日のデザインを設定
                  dowBuilder: (BuildContext context, DateTime day) {
                    // アプリの言語設定読み込み
                    final locale = Localizations.localeOf(context).languageCode;
                    // アプリの言語設定に曜日の文字を対応させる
                    final dowText = const DaysOfWeekStyle()
                            .dowTextFormatter
                            ?.call(day, locale) ??
                        DateFormat.E(locale).format(day);
                    return Container(
                      child: Center(
                        child: Text(
                          dowText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          //リスト
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: _getEventForDay(_selectedDay!)
                  .map(
                    (event) => Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            //削除ボタン
                            SlidableAction(
                                flex: 2,
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: '削除',
                                onPressed: (BuildContext context) async {
                                  await deleteDialog(context, event);
                                }),
                            //編集ボタン
                            SlidableAction(
                                flex: 2,
                                backgroundColor: Colors.brown,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: '編集',
                                onPressed: (BuildContext context) async {
                                  getEventList();
                                }),
                          ],
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          tileColor: const Color.fromARGB(255, 248, 200, 218),
                          title: Text(
                            '予定： ${event.titleText}\n日時： ${event.timeText}\n通知：${event.notificationTime}\nメモ： ${event.memoText}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          //アイコン
                          trailing: const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Icon(
                                Icons.arrow_left,
                                color: Colors.white,
                                size: 40,
                              )),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  //削除ダイアログ
  Future deleteDialog(BuildContext context, Event event) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('削除しますか?'),
          actions: <Widget>[
            TextButton(
              child: const Text("はい"),
              onPressed: () async {
                if (event.morningDrinkTimeId != null) {
                  await _cancelNotifiacation(event.morningDrinkTimeId!);
                }
                await _delete(event.id!);
                await getEventList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('いいえ'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
