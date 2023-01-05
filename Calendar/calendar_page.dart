import 'package:flutter/material.dart';
import 'package:kenkyuu_medicine/Calendar/calendar_add.dart';
import 'package:kenkyuu_medicine/Calendar/calendar_add_model.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalendarAddPage(),
                      fullscreenDialog: true,
                    ));
              },
              icon: Icon(Icons.add))
        ],
        backgroundColor: Colors.black,
        title: Text('カレンダー'),
      ),
      body: TableCalendar(
        // 以下必ず設定が必要
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
      ),
    );
  }
}
