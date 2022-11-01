class photo {
  int id;
  String photoName;

  photo({this.id, this.photoName});

  Map <String, dynamic> toMap() {
    var map = <String, dynamic> {
      'id' : id,
      'photoName' : photoName, 
    };
    return map;
  }

  photo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    photoName = map['photoName'];
  }
}