class MedicineDrinkTime {
  int id;
  String date;
  String morningTime;
  String lanchTime;
  String nightTime;
  String amountDrink;

  MedicineDrinkTime({
    this.id,
    this.morningTime,
    this.lanchTime,
    this.nightTime,
    this.amountDrink,
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
    id = json['id'],
    morningTime = json['morningTime'],
    lanchTime = json['lanchTime'],
    nightTime = json['nightTime'],
    amountDrink = json['amountDrink'];
}