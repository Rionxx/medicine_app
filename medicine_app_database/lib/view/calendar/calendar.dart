import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:medicine_app_database/view/calendar/notify_add.dart';

DateTime _focused = DateTime.now();

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarState();
}

class _CalendarState extends State<CalendarPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("カレンダー"),
      ),
      body: Center(
        child: TableCalendar(
          firstDay: DateTime.utc(2022, 4, 1),
          lastDay: DateTime.utc(2025, 12, 31),
          focusedDay: _focused,
        ),
      ),

      floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotifyAddPage(),
                  fullscreenDialog: true,
                ),
              );
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
    );
  }
}