class MedicineAlart {
  int id;
  bool toggle;
  String notifyTime;

  MedicineAlart({
    this.id,
    this.toggle,
    this.notifyTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'toggle': toggle,
      'notifyTime': notifyTime
    };
  }

  MedicineAlart.fromMap(Map json) :
    id = json['id'],
    toggle = json['toggle'],
    notifyTime = json['notifyTime'];
}