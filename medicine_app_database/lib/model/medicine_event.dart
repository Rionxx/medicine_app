class MedicineEvent {
  //飲む量と時間帯のデータ
  int? medicineId;
  String medicineName;
  String drinkDate;
  int? morningTimeId;
  String morningTime;
  String morningDoasgeText;
  int? noonTimeId;
  String noonTime;
  String noonDoasgeText;
  int? nightTimeId;
  String nightTime;
  String nightDoasgeText;

  //通知のデータ
  int? notifyId;
  int? toggle;
  String notifyTime;
  bool? isOn;

  MedicineEvent({
    this.medicineId,
    required this.medicineName,
    required this.drinkDate,
    this.morningTimeId,
    required this.morningTime,
    required this.morningDoasgeText,
    this.noonTimeId,
    required this.noonTime,
    required this.noonDoasgeText,
    this.nightTimeId,
    required this.nightTime,
    required this.nightDoasgeText,
    this.notifyId,
    this.toggle,
    required this.notifyTime,
    this.isOn
  });

  Map<String, dynamic> toMap() {
    return {
      'medicine': medicineName,
      'drinkDate': drinkDate,
      'morningTime': morningTime,
      'morningDoasgeText' : morningDoasgeText,
      'noonTime': noonTime,
      'noonDoasgeText': noonDoasgeText,
      'nightTime': nightTime,
      'nightDoasgeText':nightDoasgeText, 
      'toggle': toggle,
      'notifyTime': notifyTime,
      'isOn': isOn == true ? 1 : 0,
    };
  }

  MedicineEvent.fromMap(Map json) :
    medicineId = json['medicineId'],
    medicineName = json['medicineName'],
    drinkDate = json['drinkDate'],
    morningTimeId = json['morningTimeId'],
    morningTime = json['morningTime'],
    morningDoasgeText = json['morningDoasgeText'],
    noonTimeId = json['noonTimeId'],
    noonTime = json['noonTime'],
    noonDoasgeText = json['noonDoasgeText'],
    nightTimeId = json['nightTimeId'],
    nightTime = json['nightTime'],
    nightDoasgeText = json['nightDoasgeText'],
    notifyId = json['notifyId'],
    toggle = json['togggle'],
    notifyTime = json['notifyTime'],
    isOn = json['isOn'];
}