class Medicine {
  int? id;
  String? titleText;
  String? image;
  String? ocrText;
  String? time;
  Medicine(
      {this.id,
      required this.titleText,
      required this.image,
      required this.ocrText,
      required this.time});

  Map<String, dynamic> toMap() {
    return {
      'titleText': titleText,
      'image': image,
      'ocrText': ocrText,
      'time': time
    };
  }

  Medicine.fromMap(Map json)
      : id = json['id'],
        image = json['image'],
        ocrText = json['ocrText'],
        time = json['time'];
}
