import 'package:flutter/material.dart';
import 'package:kenkyuu_medicine/Calendar/calendar_page.dart';
import 'package:kenkyuu_medicine/List/list_page.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

//アイテムボタン
  Widget _bottomNavigationBarView(BuildContext context) {
    return BottomNavigationBar(
      unselectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 14),
      fixedColor: Colors.black,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'リスト',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'カレンダー',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> selectedPage = [ListPage(), CalendarPage()];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'リスト',
      theme: ThemeData(
        backgroundColor: Colors.pink[100],
      ),
      home: Scaffold(
        body: selectedPage[_selectedIndex],
        bottomNavigationBar: _bottomNavigationBarView(context),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
