import 'package:flutter/material.dart';
import 'package:medicine_app_database/database/db_helper.dart';
import 'package:medicine_app_database/model/medicine.dart';
import 'package:medicine_app_database/view/memo_page.dart';
import 'package:medicine_app_database/view/update_page/list_update_page.dart';
import 'list_add.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPage extends StatefulWidget {
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool _searchBoolean = false;
  bool isLoading = false;
  List<Medicine> medicineList = [
    Medicine(
        id: 0,
        title: '田中病院',
        image: 'lib/images/sample.jpg',
        time: '5月12日(月)',
        ocrtext: '田中病院'),
    Medicine(
        id: 1,
        title: '博多病院',
        image: 'lib/images/sample2.jpg',
        time: '8月14日(水)',
        ocrtext: '博多病院'),
    Medicine(
        id: 2,
        title: '平山病院',
        image: 'lib/images/sample3.jpg',
        time: '8月14日(水)',
        ocrtext: '博多病院'),
  ];
  List<int> searchIndexMedicine = [];
  //DateTime _lastChangedDate = DateTime.now();

  List<String> keywordStorage = [];
  final controller = TextEditingController();
  String word = "";
  String value = '';

  /*関数の追加*/
  //データの取得
  // @override
  // void initState() {
  //   super.initState();
  //   getMedicineList();
  // }

  // Future getMedicineList() async {
  //   setState(() => isLoading = true);
  //   medicineList = await MedicineData.instance.loadAllMedicine();
  //   setState(() => isLoading = false);
  // }

  //データの削除
  void _deleteItem(id) async {
    MedicineData.instance.delete;
    setState(() {
      medicineList.removeWhere((element) => element.id == id);
      print("Delete Success $id");
    });
  }

  //検索機能の関数
  void _search(String keyword) async {
    MedicineData.instance.search;
    setState(() {
      searchIndexMedicine = [];
      _searchBoolean = true;
      for (int i = 0; i < medicineList.length; i++) {
        if (medicineList[i].title.contains(keyword)) {
          searchIndexMedicine.add(i);
        }
      }
      print(keyword);
    });
  }

  //並び替え処理の関数
  void _onReorder(List<Medicine> medicines, int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    medicines.insert(newIndex, medicines.removeAt(oldIndex));
  }

  /*viewの追加*/
  Widget _searchTextField() {
    return TextField(
      controller: controller,
      onChanged: _search,
      autofocus: true, //TextFieldが表示されるときにフォーカスする（キーボードを表示する）
      cursorColor: Colors.white, //カーソルの色
      style: const TextStyle(
        //テキストのスタイル
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search, //キーボードのアクションボタンを指定
      decoration: const InputDecoration(
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

  //データの検索結果の表示
  Widget _searchResultView() {
    return ListView.builder(
      itemCount: searchIndexMedicine.length,
      itemBuilder: (context, index) {
        index = searchIndexMedicine[index];
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
                    onPressed: (BuildContext context) async {
                      //add delete function
                      _deleteItem(medicineList[index].id);
                    }),
              ],
            ),
            //薬のデータの内容
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
                        Text(
                            '病院名：${medicineList[index].title}\n日付：${medicineList[index].time}'),
                        const SizedBox(
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
      },
    );
  }

  //登録している薬のリスト表示
  Widget _defaultListView() {
    return ReorderableListView.builder(
      itemCount: medicineList.length,
      onReorder: (int oldIndext, int newIndex) {
        //薬のデータの並び替え処理
        _onReorder(medicineList, oldIndext, newIndex);
      },
      itemBuilder: (context, index) {
        return Card(
          key: Key('$index'),
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
                      //add delete function
                      _deleteItem(medicineList[index].id);
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
                        Text(
                            '病院名：${medicineList[index].title}\n日付：${medicineList[index].time}'),
                        const SizedBox(
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
      },
    );
  }

  Widget imageView(BuildContext context, int index) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MemoPage(ocrText: medicineList[index].ocrtext)));
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
    final medicine = medicineList[index];
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Column(
        children: [
          Container(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 40,
                ),
                //編集ボタン
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.black,
                  onPressed: () async {
                    //add Edit function
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ListUpdatePage(id: medicine.id),
                        fullscreenDialog: true,
                      ),
                    );
                    //getMedicineList();
                  },
                  iconSize: 50,
                ),
                //ノートボタン
                IconButton(
                  color: Colors.black,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MemoPage(ocrText: medicineList[index].ocrtext),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  icon: const Icon(Icons.notes),
                  iconSize: 50,
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
                            searchIndexMedicine = [];
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
          body: !_searchBoolean ? _defaultListView() : _searchResultView(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListAddPage(),
                  fullscreenDialog: true,
                ),
              );
              //getMedicineList();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
