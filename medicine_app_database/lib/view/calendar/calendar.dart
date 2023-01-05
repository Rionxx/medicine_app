import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:medicine_app_database/view/calendar/event_add.dart';
import 'package:medicine_app_database/model/medicine_event.dart';

DateTime _focused = DateTime.now();
DateTime? _selected;

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarState();
}

class _CalendarState extends State<CalendarPage> {
  int _counter = 0;
  List<MedicineEvent> medicineEventList = [
    MedicineEvent(
        medicineId: 1,
        medicineName: 'アレグラ',
        drinkDate: '',
        morningTime: '5時00分',
        lanchTime: '13時00分',
        nightTime: '18時00分',
        amountDrink: '',
        notifyId: 1,
        toggle: 1,
        notifyTime: '15分前',
        isOn: true),
  ];

  //関数の追加
  //カレンダーの表示
  Widget _medicineCalender() {
    return Scaffold(
      body: Center(
        child: TableCalendar(
          firstDay: DateTime.utc(2022, 4, 1),
          lastDay: DateTime.utc(2025, 12, 31),
          focusedDay: _focused,
        ),
      ),
    );
  }

  // 通知リストの表示
  Widget _eventList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: medicineEventList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 20.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  flex: 2,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: '削除',
                  onPressed: (BuildContext context) async {
                    // add delete event function
                  },
                ),
              ],
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Colors.pink[100],
              title: Container(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('お薬名：${medicineEventList[index].medicineName}'),
                        const SizedBox(height: 10),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text("カレンダー"),
          ),
          body: Stack(
            children: [_medicineCalender()],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventAddPage(),
                  fullscreenDialog: true,
                ),
              );
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
