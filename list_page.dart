import 'package:flutter/material.dart';
import 'package:kenkyuu_medicine/Calendar/calendar_add.dart';
import 'package:kenkyuu_medicine/List/base_helper.dart';
import 'package:kenkyuu_medicine/List/list_edit.dart';
import 'package:kenkyuu_medicine/List/list_edit_model.dart';
import 'package:kenkyuu_medicine/List/list_model.dart';
import 'package:kenkyuu_medicine/db_datebase.dart';
import 'package:kenkyuu_medicine/medicine.dart';
import 'package:kenkyuu_medicine/memo_page.dart';
import 'package:kenkyuu_medicine/photo.dart';
import 'list_add.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListPage extends StatefulWidget {
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool _searchBoolean = false;
  String _sertchText = "";
  List<Medicine> medicineList = [];
  List<Medicine> searchList = [];
  @override
  void initState() {
    super.initState();
    getList();
  }

  Future getList() async {
    final db = await DBProvider.db.database;
    var res = await db.query('medicine');
    print("データー${res}");
    //データの読み込み
    if (mounted) {
      setState(() {
        medicineList = res.map((data) => Medicine.fromMap(data)).toList();
        print("データー${medicineList}");
      });
    }
  }

  Future delete(int id) async {
    final db = await DBProvider.db.database;
    await db.delete('medicine', where: "id = ?", whereArgs: [id]);
  }

  void search(String keyword) {
    if (keyword == "") {
      setState(() {
        getList();
      });
    } else {
      setState(() {
        searchList = medicineList
            .where((data) => data.titleText!.contains(keyword))
            .toList();
      });
      searchList = medicineList
          .where((data) =>
              data.titleText!.contains(keyword) ||
              data.ocrText!.contains(keyword))
          .toList();
    }
  }

  Widget _searchTextField() {
    return TextField(
      onChanged: (seartchText) {
        _sertchText = seartchText;
        search(_sertchText);
      },
      autofocus: true, //TextFieldが表示されるときにフォーカスする（キーボードを表示する）
      cursorColor: Colors.white, //カーソルの色
      style: TextStyle(
        //テキストのスタイル
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search, //キーボードのアクションボタンを指定
      decoration: InputDecoration(
        //TextFiledのスタイル
        enabledBorder: UnderlineInputBorder(
            //デフォルトのTextFieldの枠線
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: UnderlineInputBorder(
            //TextFieldにフォーカス時の枠線
            borderSide: BorderSide(color: Colors.white)),
        hintText: '検索', //何も入力してないときに表示されるテキスト
        hintStyle: TextStyle(
          //hintTextのスタイル
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget imageView(BuildContext context, Medicine medicine) {
    return InkWell(
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MemoPage(ocrText: medicine.ocrText!)));
        },
        child: Container(
            width: 250,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Photo(medicineImage: medicine.image),
                    fullscreenDialog: true,
                  ),
                );

                await getList();
              },
              child: medicine.image != null
                  ? SizedBox(
                      width: 45,
                      height: 50,
                      child:
                          Base64Helper().imageFromBase64String(medicine.image!))
                  : Container(
                      width: 250,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
            )));
  }

  Widget listWidget(List<Medicine> list) {
    return Column(
      children: [
        Expanded(
          child: ListView(
              children: list
                  .map(
                    (medicine) => Card(
                      elevation: 20.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
                                  await delete(medicine.id!);
                                  await getList();
                                }),
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
                                    Text("${medicine.titleText}"),
                                    Text("${medicine.time}"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    imageView(context, medicine) //写真
                                  ],
                                ),
                                iconButtonWidget(context, medicine) //アイコンボタン
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList()),
        ),
      ],
    );
  }

  Widget iconButtonWidget(BuildContext context, Medicine medicine) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                //編集ボタン
                IconButton(
                  icon: Icon(Icons.edit),
                  color: Colors.black,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPage(medicine.titleText!,
                            medicine.ocrText!, medicine.image!, medicine.id!),
                        fullscreenDialog: true,
                      ),
                    );
                    getList();
                  },
                  iconSize: 60,
                ),
                //ノートボタン
                IconButton(
                  color: Colors.black,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MemoPage(ocrText: medicine.ocrText!),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  icon: Icon(Icons.notes),
                  iconSize: 60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            //検索機能
            backgroundColor: Colors.black,
            title: !_searchBoolean ? const Text('リスト') : _searchTextField(),
            actions: !_searchBoolean
                ? [
                    IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _searchBoolean = true;
                          });
                        })
                  ]
                : [
                    IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _searchBoolean = false;
                          });
                        })
                  ],
          ),
          body: listWidget(_sertchText == "" ? medicineList : searchList),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListAddPage(),
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
