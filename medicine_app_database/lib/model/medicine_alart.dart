class MedicineAlart {
  int medicineId;
  int notifyId;
  int toggle;
  String notifyTime;
  bool isOn; 

  MedicineAlart({
    this.medicineId,
    this.notifyId,
    this.toggle,
    this.notifyTime,
    this.isOn
  });

  Map<String, dynamic> toMap() {
    return {
      'toggle': toggle,
      'notifyTime': notifyTime,
      'isOn':isOn == true ? 1:0 
    };
  }

  MedicineAlart.fromMap(Map json) :
    medicineId = json['medicineId'],
    notifyId = json['notifyId'],
    toggle = json['toggle'],
    notifyTime = json['notifyTime'],
    isOn = json['isOn'];
}