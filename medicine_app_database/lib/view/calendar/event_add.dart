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
  String? dateText;
  String isSelectedAmountValue = "1個";
  String isSelectedTimeMorningValue = "6時";
  String isSelectedTimeLunchValue = "12時";
  String isSelectedTimeNightValue = "18時";
  final isSelectedAmountValueList = <String>["1個", "2個", "3個", "4個", "5個"];
  final isSelectedTimeMorningValueList = <String>[
    "6時",
    "7時",
    "8時",
    "9時",
    "10時",
    "11時"
  ];
  final isSelectedTimeLunchValueList = <String>[
    "12時",
    "13時",
    "14時",
    "15時",
    "16時",
    "17時"
  ];
  final isSelectedTimeNightValueList = <String>[
    "18時",
    "19時",
    "20時",
    "21時",
    "22時",
    "23時"
  ];

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
            color: Colors.white,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 200),
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: 80,
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

          //エラー：テキストのピクセルオーバーフロー
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Row(
              children: const [
                SizedBox(width: 30),
                Text("時間",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(width: 150),
                Text("服用量",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ),
          ),
          const SizedBox(height: 10),

          //朝の飲む時間と服用量のドロップダウン
          Row(children: <Widget>[
            const SizedBox(width: 30),
            Container(
              width: 170,
              decoration: BoxDecoration(
                //朝の時間帯のドロップダウン
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                alignment: Alignment.bottomRight,
                underline: Container(),
                isExpanded: false,
                value: isSelectedTimeMorningValue,
                items: isSelectedTimeMorningValueList
                    .map((String morning) => DropdownMenuItem(
                          value: morning,
                          child: Text(morning),
                        ))
                    .toList(),
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? value) {
                  setState(() {
                    isSelectedTimeMorningValue = value!;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                //朝の服用量のドロップダウン
                underline: Container(),
                value: isSelectedAmountValue,
                items: isSelectedAmountValueList
                    .map((String amount) => DropdownMenuItem(
                          value: amount,
                          child: Text(amount, textAlign: TextAlign.right),
                        ))
                    .toList(),
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? value) {
                  setState(() {
                    isSelectedAmountValue = value!;
                  });
                },
              ),
            ),
          ]),
          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 200),
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '昼',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          //昼の飲む時間と服用量のドロップダウン
          Row(children: <Widget>[
            const SizedBox(width: 30),
            Container(
              width: 170,
              decoration: BoxDecoration(
                //昼の時間帯のドロップダウン
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                underline: Container(),
                value: isSelectedTimeLunchValue,
                items: isSelectedTimeLunchValueList
                    .map((String lunch) => DropdownMenuItem(
                          value: lunch,
                          child: Text(lunch),
                        ))
                    .toList(),
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? value) {
                  setState(() {
                    isSelectedTimeLunchValue = value!;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                //昼の服用量のドロップダウン
                underline: Container(),
                value: isSelectedAmountValue,
                items: isSelectedAmountValueList
                    .map((String amount) => DropdownMenuItem(
                          value: amount,
                          child: Text(amount),
                        ))
                    .toList(),
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? value) {
                  setState(() {
                    isSelectedAmountValue = value!;
                  });
                },
              ),
            ),
          ]),
          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 200),
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '夜',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          //夜に飲む時間帯と服用量のドロップダウン
          Row(children: <Widget>[
            const SizedBox(width: 30),
            Container(
              width: 170,
              decoration: BoxDecoration(
                //夜の時間帯のドロップダウン
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                underline: Container(),
                value: isSelectedTimeNightValue,
                items: isSelectedTimeNightValueList
                    .map((String night) => DropdownMenuItem(
                          value: night,
                          child: Text(night),
                        ))
                    .toList(),
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? value) {
                  setState(() {
                    isSelectedTimeNightValue = value!;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                //朝の服用量のドロップダウン
                underline: Container(),
                alignment: Alignment.center,
                value: isSelectedAmountValue,
                items: isSelectedAmountValueList
                    .map((String amount) => DropdownMenuItem(
                          value: amount,
                          child: Text(amount),
                        ))
                    .toList(),
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? value) {
                  setState(() {
                    isSelectedAmountValue = value!;
                  });
                },
              ),
            ),
          ]),
        ],
      ),
    );
  }

  //お薬の飲む時間コーナー
  Widget informListView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 550,
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
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("通知",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(width: 10),
              CupertinoSwitch(
                  value: isOn,
                  onChanged: (bool value) {
                    if (value != null) {
                      setState(() {
                        isOn = value;
                      });
                    }
                  })
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 160),
            child: Text(
              '通知時間',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          timeAgoTextFieldView(context)
        ]),
      ),
    );
  }

  Widget timeAgoTextFieldView(BuildContext context) {
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
            color: Colors.white,
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
                    hintText: "時間",
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
