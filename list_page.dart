import 'package:flutter/material.dart';
import 'package:kenkyuu_medicine/medicine.dart';
import 'package:kenkyuu_medicine/memo_page.dart';
import 'list_add.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListPage extends StatefulWidget {
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool _searchBoolean = false;
  List<Medicine> medicineList = [
    Medicine(
        id: 0, titleText: '田中病院', image: '', time: '5月12日(月)', ocrText: '田中病院')
  ];

  Widget _searchTextField() {
    return const TextField(
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

  Widget imageView(BuildContext context, int index) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MemoPage(ocrText: medicineList[index].ocrText!)));
      },
      child: Container(
        width: 250,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget iconButtonWidget(BuildContext context, int index) {
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
                  onPressed: () {},
                  iconSize: 60,
                ),
                //ノートボタン
                IconButton(
                  color: Colors.black,
                  onPressed: () async{
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MemoPage(ocrText: medicineList[index].ocrText!),
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
          body: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: medicineList.length,
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
                                //削除ボタン
                                SlidableAction(
                                    flex: 2,
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: '削除',
                                    onPressed: (BuildContext context) async {}),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '病院名：${medicineList[index].titleText!}\n日付：${medicineList[index].time}'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        imageView(context, index) //写真
                                      ],
                                    ),
                                    iconButtonWidget(context, index) //アイコンボタン
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
            ],
          ),
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
