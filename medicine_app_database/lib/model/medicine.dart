class Medicine {
  int id;
  String title;
  String ocrtext;
  String time;

  Medicine({
    this.id, 
    this.title, 
    this.ocrtext,
    this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ocrtext': ocrtext,
      'time' : time, 
    };
  }

  Medicine.fromMap(Map json) 
    : id = json['id'],
      title = json['title'],
      ocrtext = json['ocrtext'],
      time = json['time'];
}