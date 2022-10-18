import 'package:flutter/material.dart';

/*キーワード検索とかに病院名か薬の名前、インターフェースの機能
名前、日付、飲む時間（いつからいつまでどの時間に飲むか）

薬を飲むタイミング別の票でどれだけ登録したか
登録したデータベースの方から通知で呼び出す
*/

void main() => runApp(const SearchApp());

class SearchApp extends StatelessWidget {
  const SearchApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> hospitalList = [
    "さとうメディカルクリニック",
    "博多メディカルクリニック",
    "JCHO久留米総合病院",
    "のぞえの丘病院",
    "久留米大学病院",
    "筑後市立病院",
    "くるめ病院",
    "田主丸中央病院",
    "楠病院",
    "安本病院",
    "福岡市民病院",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Autocomplete(
            optionsBuilder: (textEditingValue) {
              return hospitalList.where(
                (element) => element.contains(textEditingValue.text)
              );
            },
          ),
        ),
      ),
    );
  }
}