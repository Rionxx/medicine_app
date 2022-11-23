class MedicineDrinkTime {
  int medicineId;
  String drinkDate;
  String morningTime;
  String lanchTime;
  String nightTime;
  String amountDrink;

  MedicineDrinkTime({
    this.medicineId,
    this.drinkDate,
    this.morningTime,
    this.lanchTime,
    this.nightTime,
    this.amountDrink,
  });

  Map<String, dynamic> toMAp() {
    return {
      'drinkDate': drinkDate,
      'morningTime': morningTime,
      'lanchTime': lanchTime,
      'nightTime': nightTime,
      'amountDrink': amountDrink,
    };
  }

  MedicineDrinkTime.fromMap(Map json):
    medicineId = json['medicineId'],
    drinkDate = json['drinkDate'],
    morningTime = json['morningTime'],
    lanchTime = json['lanchTime'],
    nightTime = json['nightTime'],
    amountDrink = json['amountDrink'];
}