import 'package:flutter/material.dart';
import 'package:medicine_app_database/view/medicine_card.dart';
import 'package:medicine_app_database/view/search_bar.dart';

void main() {
  runApp(const MedicineApp());
}

class MedicineApp extends StatelessWidget {
  const MedicineApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        backgroundColor: Colors.black,
        appBar: SearchBar(),
        body: Center(
          child: HomePage(),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: ListView(
            children: <Widget>[
              Card(
                child: ListTile(
                  title: MedicineCard(),
              ),
              ),
              
            ],
          ),

          bottomNavigationBar: Container(
            color: Colors.blue,
            child:const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.person)),
              ],
            )
          ),
        ),
      ),
    );
  }
}
