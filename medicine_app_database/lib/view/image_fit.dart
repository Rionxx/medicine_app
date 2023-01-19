import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app_database/model/medicine.dart';

class ImageFitView extends StatefulWidget {
  ImageFitView({Key? key, required this.medicine}) : super(key: key);
  final Medicine? medicine;

  @override 
  State<ImageFitView> createState() => ImageFitViewState();
}

class ImageFitViewState extends State<ImageFitView> {
  late String _image;

  @override
  void initState() {
    super.initState();
    _image = widget.medicine?.image ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: 500,
        height: 500,
        child: Image.asset(
          _image,
          fit: BoxFit.fitWidth,
        ),
      )
    );
  }

}