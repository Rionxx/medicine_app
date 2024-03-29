import 'package:intl/intl.dart';

class Medicine {
  int? id;
  String title;
  String image;
  String ocrtext;
  DateTime time;

  Medicine({
    this.id, 
    required this.title, 
    required this.image,
    required this.ocrtext,
    required this.time,
  });

  Medicine copy({
    int? id,
    String? title,
    String? image,
    String? ocrtext,
    DateTime? time
  }) => Medicine(
    id: this.id,
    title: this.title,
    image: this.image,
    ocrtext: this.ocrtext,
    time: this.time
  );

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'ocrtext': ocrtext,
      'time' : DateFormat('yyyy/MM/dd(E) H:m').format(time), 
    };
  }

  Medicine.fromMap(Map json) 
    : id = json['id'],
      image = json['image'],
      title = json['title'],
      ocrtext = json['ocrtext'],
      time = json['time'];
}