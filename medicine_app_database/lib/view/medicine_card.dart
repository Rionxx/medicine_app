import 'package:flutter/material.dart';
//import 'package:medicine_app_database/model/medicine.dart';

class MedicineCard extends StatefulWidget {
  const MedicineCard({Key key}) : super(key: key);

  @override
  State<MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {

  @override
  Widget build(BuildContext context) {
    String title = "田中病院";
    String ocrtext = "";
    String time = "2022年11月1日";

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            width: 350,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xffe3a1e4),
            ),

            child: Stack(
              children: [
                Positioned(
                  left: 27,
                  top: 7,
                  child: SizedBox(
                    width: 166,
                    height: 40,
                    child: Text(
                      "病院名：$title",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 14,
                  top: 34,
                  child: SizedBox(
                    width: 223,
                    height: 40,
                    child: Text(
                      "日付 : $time",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}