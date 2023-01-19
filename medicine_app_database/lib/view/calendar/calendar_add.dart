import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app_database/model/calendar_add_model.dart';
//import 'package:kenkyuu_medicine/List/list_add_model.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class CalendarAddPage extends StatelessWidget {
  final notificationTimebars = [
    '１５分',
    '３０分',
    '１時間',
    '２時間',
    '３時間',
    '４時間',
    '５時間',
    '６時間',
    '１日',
    '２日',
    '３日'
  ];



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalnedarAddModel>.value(
      value: CalnedarAddModel(),
      child: Scaffold(
          appBar:
              AppBar(backgroundColor: Colors.black, title: const Text('追加')),
          body: Consumer<CalnedarAddModel>(builder: (context, model, child) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque, //画面外タップを検知するために必要
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      titleTextFieldView(model),
                      timeDrnkDrugTime(model, context),
                      notificationSettingWidget(model, context),
                      addButton(model, context)
                    ],
                  ),
                ),
              ),
            );
          })),
    );
  }

  Widget titleTextFieldView(CalnedarAddModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      child: TextField(
        onChanged: (String titleText) {
          model.setTitleText = titleText;
        },
        decoration: const InputDecoration(
          hintText: "お薬を入力",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
        ),
      ),
    );
  }

  Widget timeDrnkDrugTime(CalnedarAddModel model, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 5, color: Colors.black),
        color: Colors.pink[100],
      ),
      width: 360,
      height: 500,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 300,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.black),
            child: const Center(
              child: Text(
                "お薬を飲む時間",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          //日付
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  width: 300,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      border: Border.all(width: 5, color: Colors.black)),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(model.titleText),
                          IconButton(
                              onPressed: () {
                                _detePicker(context, model);
                              },
                              icon: const Icon(Icons.calendar_month))
                        ],
                      )),
                ),
                const SizedBox(height: 10),
                timeZoneBar("朝"),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: const [
                    SizedBox(width: 10),
                    Text("時間", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 200),
                    Text("服用量", style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                Row(children: [
                  morningDrinkTimeBarWidget(model, context),
                  const SizedBox(width: 10),
                  morningDosageBarWidget(model, context)
                ]),
                const SizedBox(height: 10),
                timeZoneBar("昼"),
                const SizedBox(height: 10),
                Row(
                  children: [
                    noonDrinkTimeBarWidget(model, context),
                    const SizedBox(width: 10),
                    noonDosageBarWidget(model, context)
                  ],
                ),
                const SizedBox(height: 10),
                timeZoneBar("夜"),
                const SizedBox(height: 10),
                Row(
                  children: [
                    nightDrinkTimeBarWidget(model, context),
                    const SizedBox(width: 10),
                    nightDosageBarWidget(model, context)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget notificationSettingWidget(
      CalnedarAddModel model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 5, color: Colors.black),
          color: Colors.pink[100],
        ),
        width: 360,
        height: 250,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 300,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black),
                child: const Center(
                  child: Text(
                    "通知設定",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Text('通知',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(width: 10),
                CupertinoSwitch(
                  value: model.isOn,
                  onChanged: (bool value) {
                    model.onChecked(value);
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('通知設定:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ]),
            model.isOn == true
                ? InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 250,
                            child: Column(
                              children: [
                                TextButton(
                                  child: const Text('閉じる'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Expanded(
                                  child: CupertinoPicker(
                                    itemExtent: 30,
                                    children: notificationTimebars
                                        .map((timebars) => Text("$timebars前"))
                                        .toList(),
                                    onSelectedItemChanged: (int index) {
                                      model.settingNotification(
                                          notificationTimebars[index]);
                                    },
                                    //開始位置を選択
                                    scrollController:
                                        FixedExtentScrollController(
                                      initialItem: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 300,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: <Widget>[
                          const SizedBox(width: 10),
                          const Icon(Icons.notifications),
                          const SizedBox(width: 20),
                          Text(
                            ' 通知：${model.notificationTime}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    width: 300,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const <Widget>[
                        SizedBox(width: 10),
                        SizedBox(width: 20),
                        Text('通知',
                            style: TextStyle(
                                color: Color.fromARGB(222, 244, 244, 244))),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget addButton(CalnedarAddModel model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.pink[100],
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton(
            child: Text('追加'),
            style: ElevatedButton.styleFrom(
              primary: Colors.pink[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              //お薬手帳を追加する
              await addDialog(model, context);
            }),
      ),
    );
  }

  // 追加ダイアログ
  Future addDialog(CalnedarAddModel model, BuildContext context) async {
    try {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('追加しました。'),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(e.toString()),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
  }

  Widget morningDosageBarWidget(CalnedarAddModel model, BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 5, color: Colors.black)),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Expanded(child: Text(model.morningDoasgeText)),
          const Text("錠"),
          Expanded(
              child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 250,
                          child: Column(
                            children: [
                              TextButton(
                                child: const Text('閉じる'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Expanded(
                                child: CupertinoPicker(
                                  looping: true,
                                  itemExtent: 30,
                                  onSelectedItemChanged: (int index) {
                                    model.morningDoasgeText =
                                        model.dosageList()[index];
                                  },
                                  //開始位置を選択
                                  scrollController: FixedExtentScrollController(
                                    initialItem: 0,
                                  ),
                                  children: model
                                      .dosageList()
                                      .map((doasge) => Text("$doasge錠"))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.keyboard_arrow_down))),
        ],
      ),
    );
  }

  Widget noonDosageBarWidget(CalnedarAddModel model, BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 5, color: Colors.black)),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Expanded(child: Text(model.noonDoasgeText)),
          const Text("錠"),
          Expanded(
              child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 250,
                          child: Column(
                            children: [
                              TextButton(
                                child: const Text('閉じる'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Expanded(
                                child: CupertinoPicker(
                                  looping: true,
                                  itemExtent: 30,
                                  onSelectedItemChanged: (int index) {
                                    model.noonDoasgeText =
                                        model.dosageList()[index];
                                  },
                                  //開始位置を選択
                                  scrollController: FixedExtentScrollController(
                                    initialItem: 0,
                                  ),
                                  children: model
                                      .dosageList()
                                      .map((doasge) => Text("$doasge錠"))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.keyboard_arrow_down))),
        ],
      ),
    );
  }

  Widget nightDosageBarWidget(CalnedarAddModel model, BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 5, color: Colors.black)),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Expanded(child: Text(model.nightDoasgeText)),
          const Text("錠"),
          Expanded(
              child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 250,
                          child: Column(
                            children: [
                              TextButton(
                                child: const Text('閉じる'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Expanded(
                                child: CupertinoPicker(
                                  looping: true,
                                  itemExtent: 30,
                                  onSelectedItemChanged: (int index) {
                                    model.nightDoasgeText =
                                        model.dosageList()[index];
                                  },
                                  //開始位置を選択
                                  scrollController: FixedExtentScrollController(
                                    initialItem: 0,
                                  ),
                                  children: model
                                      .dosageList()
                                      .map((doasge) => Text("$doasge錠"))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.keyboard_arrow_down))),
        ],
      ),
    );
  }

  Widget timeZoneBar(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Center(
              child: Text(
            title,
            style: TextStyle(color: Colors.white),
          )),
          width: 100,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.black),
        ),
      ],
    );
  }

  Widget morningDrinkTimeBarWidget(
      CalnedarAddModel model, BuildContext context) {
    return Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 5, color: Colors.black)),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Expanded(flex: 3, child: Text(model.morningDrinkTimeText)),
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 250,
                          child: Column(
                            children: [
                              TextButton(
                                child: const Text('閉じる'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Expanded(
                                child: CupertinoDatePicker(
                                  minimumDate: model.toDay,
                                  initialDateTime: model.toDay,
                                  use24hFormat: true,
                                  mode: CupertinoDatePickerMode.time,
                                  onDateTimeChanged: (DateTime dateTime) {
                                    model.settingMorningTimeDrink(dateTime);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.keyboard_arrow_down)),
            )
          ],
        ));
  }

  Widget noonDrinkTimeBarWidget(CalnedarAddModel model, BuildContext context) {
    return Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 5, color: Colors.black)),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Expanded(flex: 3, child: Text(model.noonDrinkTimeText)),
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 250,
                          child: Column(
                            children: [
                              TextButton(
                                child: const Text('閉じる'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Expanded(
                                child: CupertinoDatePicker(
                                  minimumDate: model.toDay,
                                  initialDateTime: model.toDay,
                                  use24hFormat: true,
                                  mode: CupertinoDatePickerMode.time,
                                  onDateTimeChanged: (DateTime dateTime) {
                                    model.settingNoonTimeDrink(dateTime);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.keyboard_arrow_down)),
            )
          ],
        ));
  }

  _detePicker(BuildContext context, CalnedarAddModel model) async {
    final DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: model.toDay,
        firstDate: DateTime(2003),
        lastDate: DateTime(2023));
    if (datePicked != null && datePicked != model.toDay) {
      model.setTimeText = datePicked.toString();
    }
  }

  Widget nightDrinkTimeBarWidget(CalnedarAddModel model, BuildContext context) {
    return Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 5, color: Colors.black)),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Expanded(flex: 3, child: Text(model.nigthDrinkTimeText)),
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 250,
                          child: Column(
                            children: [
                              TextButton(
                                child: const Text('閉じる'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Expanded(
                                child: CupertinoDatePicker(
                                  minimumDate: model.toDay,
                                  initialDateTime: model.toDay,
                                  use24hFormat: true,
                                  mode: CupertinoDatePickerMode.time,
                                  onDateTimeChanged: (DateTime dateTime) {
                                    model.settingNightTimeDrink(dateTime);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.keyboard_arrow_down)),
            )
          ],
        ));
  }
}
