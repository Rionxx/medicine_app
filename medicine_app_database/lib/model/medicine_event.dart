class MedicineEvent {
  //飲む量と時間帯のデータ
  int? medicineId;
  String medicineName;
  String drinkDate;
  String morningTime;
  String lanchTime;
  String nightTime;
  String amountDrink;

  //通知のデータ
  int? notifyId;
  int toggle;
  String notifyTime;
  bool? isOn;

  MedicineEvent({
    this.medicineId,
    required this.medicineName,
    required this.drinkDate,
    required this.morningTime,
    required this.lanchTime,
    required this.nightTime,
    required this.amountDrink,
    this.notifyId,
    required this.toggle,
    required this.notifyTime,
    this.isOn
  });

  Map<String, dynamic> toMap() {
    return {
      'medicine': medicineName,
      'drinkDate': drinkDate,
      'morningTime': morningTime,
      'lanchTime': lanchTime,
      'nightTime': nightTime,
      'amountDrink': amountDrink,
      'toggle': toggle,
      'notifyTime': notifyTime,
      'isOn': isOn == true ? 1 : 0,
    };
  }

  MedicineEvent.fromMap(Map json) :
    medicineId = json['medicineId'],
    medicineName = json['medicineName'],
    drinkDate = json['drinkDate'],
    morningTime = json['morningTime'],
    lanchTime = json['lanchTime'],
    nightTime = json['nightTime'],
    amountDrink = json['amountDrink'],
    notifyId = json['notifyId'],
    toggle = json['togggle'],
    notifyTime = json['notifyTime'],
    isOn = json['isOn'];

}