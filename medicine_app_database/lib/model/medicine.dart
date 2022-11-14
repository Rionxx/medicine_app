class Medicine {
  int id;
  String title;
  String image;
  String ocrtext;
  String time;

  Medicine({
    this.id, 
    this.title, 
    this.image,
    this.ocrtext,
    this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'ocrtext': ocrtext,
      'time' : time, 
    };
  }

  Medicine.fromMap(Map json) 
    : id = json['id'],
      title = json['image'],
      ocrtext = json['ocrtext'],
      time = json['time'];
}