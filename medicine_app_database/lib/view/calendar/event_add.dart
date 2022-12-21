import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app_database/database/db_event_helper.dart';
import 'package:medicine_app_database/model/medicine_event.dart';
import 'package:medicine_app_database/view/calendar/calendar.dart';

class EventAddPage extends StatefulWidget {
  @override
  State<EventAddPage> createState() => _EventAddPageState();
}

class _EventAddPageState extends State<EventAddPage> {
  String dateText;
  bool isOn = false;

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
                    hintText: "お薬名",
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

  //日付の入力フォーム
  Widget dateTextFieldView(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
        ),
        child: Container(
          height: 60,
          width: 280,
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
                    fillColor: Colors.white,
                    filled: true,
                    border: InputBorder.none,
                    hintText: "日付",
                  ),
                  onChanged: (dateText) {
                    dateText = dateText;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //飲む時間帯と量の入力フォーム
  Widget medicineDropDownForm(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: const Text("朝"),
          ),
          Row(
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
                    '朝', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //お薬の飲む時間コーナー
  Widget informListView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 500,
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
                'お薬を飲む時間',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          dateTextFieldView(context),
          medicineDropDownForm(context),
        ]),
      ),
    );
  }

  //通知設定コーナー
  Widget eventListView() {
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
                '通知',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topRight,
            child: Text("通知"),
          ),
          ListTile(
            //title: const Text("通知"),
            trailing: CupertinoSwitch(
                value: isOn,
                onChanged: (bool value) {
                  if (value != null) {
                    setState(() {
                      isOn = value;
                    });
                  }
                }),
          ),
          const Align(alignment: Alignment.centerLeft, child: Text("通知時間")),
        ]),
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
        onPressed: () {
          //データを追加する関数
          //_addItem();
        },
        child: const Text('追加',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('追加'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              titleTextFieldView(context),
              informListView(),
              eventListView(),
              addButton(),
            ],
          ),
        ),
      ),
    );
  }
}
