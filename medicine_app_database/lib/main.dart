import 'package:flutter/material.dart';
import 'package:medicine_app_database/view/list/list_page.dart';
import 'package:medicine_app_database/view/calendar/calendar_page.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //アイテムbottom
  Widget _bottomNavigationBarView(BuildContext context) {
    return BottomNavigationBar(
      unselectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 24),
      fixedColor: Colors.black,
      onTap: _onItemTapped,
      items: const<BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt, size: 36),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today, size: 36),
          label: '',
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
        backgroundColor:Colors.pink[100],
      ),
      home: Scaffold(
        body: selectedPage[_selectedIndex],
        bottomNavigationBar: _bottomNavigationBarView(context),
      ),
    );
  }
}