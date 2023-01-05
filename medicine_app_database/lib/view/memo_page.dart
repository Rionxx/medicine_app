import 'package:flutter/material.dart';

class MemoPage extends StatefulWidget {
  MemoPage({Key? key, required this.ocrText}) : super(key: key) {
    ocrTextController.text = ocrText;
  }
  String ocrText;
  var ocrTextController = TextEditingController();
  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  String _ocrText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: widget.ocrTextController,
              onChanged: (ocrText) {
                _ocrText = ocrText;
              },
            )),
      ),
    );
  }
}
