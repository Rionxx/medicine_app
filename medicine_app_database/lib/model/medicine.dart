class Medicine {
  int id;
  String title;
  String ocrtext;

  Medicine({
    this.id, 
    this.title, 
    this.ocrtext
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ocrtext': ocrtext,
    };
  }

  Medicine.fromMap(Map json) 
    : id = json['id'],
      title = json['title'],
      ocrtext = json['ocrtext'];
}