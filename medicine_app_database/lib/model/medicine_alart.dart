class MedicineAlart {
  int medicineId;
  int notifyId;
  bool toggle;
  String notifyTime;

  MedicineAlart({
    this.medicineId,
    this.notifyId,
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
    medicineId = json['medicineId'],
    notifyId = json['notifyId'],
    toggle = json['toggle'],
    notifyTime = json['notifyTime'];
}