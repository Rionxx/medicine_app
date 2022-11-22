class MedicineDrinkTime {
  int medicineId;
  String date;
  String morningTime;
  String lanchTime;
  String nightTime;
  String amountDrink;

  MedicineDrinkTime({
    this.medicineId,
    this.morningTime,
    this.lanchTime,
    this.nightTime,
    this.amountDrink, date,
  });

  Map<String, dynamic> toMAp() {
    return {
      'morningTime': morningTime,
      'lanchTime': lanchTime,
      'nightTime': nightTime,
      'amountDrink': amountDrink,
    };
  }

  MedicineDrinkTime.fromMap(Map json):
    medicineId = json['medicineId'],
    date = json['date'],
    morningTime = json['morningTime'],
    lanchTime = json['lanchTime'],
    nightTime = json['nightTime'],
    amountDrink = json['amountDrink'];
}