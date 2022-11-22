import 'dart:io';
import 'package:flutter/material.dart';

class NotifyAddPage extends StatefulWidget {
  @override
  State<NotifyAddPage> createState() => _NotifyAddPageState();
}

class _NotifyAddPageState extends State<NotifyAddPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('追加'),
      ),
    );
  }
}