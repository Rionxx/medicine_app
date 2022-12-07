class MedicineEvent {
  //飲む量と時間帯のデータ
  int medicineId;
  String drinkDate;
  String morningTime;
  String lanchTime;
  String nightTime;
  String amountDrink;

  //通知のデータ
  int notifyId;
  int toggle;
  String notifyTime;
  bool isOn;

  MedicineEvent({
    this.medicineId,
    this.drinkDate,
    this.morningTime,
    this.lanchTime,
    this.nightTime,
    this.amountDrink,
    this.notifyId,
    this.toggle,
    this.notifyTime,
    this.isOn
  });

  Map<String, dynamic> toMap() {
    return {
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