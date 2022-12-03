import 'package:flutter/material.dart';
import 'package:medicine_app_database/model/medicine.dart';
import 'package:medicine_app_database/model/repository/medicine_repository.dart';

class MedicineListVewModel extends ChangeNotifier{
  final MedicineRepository _repository;
  MedicineListVewModel(this._repository) {
    loadAllMedicine();
  }

  List<Medicine> _medicines = [];
  
  List<Medicine> get medicines => _medicines;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void loadAllMedicine() async {
    _startLoading();
    _medicines = await _repository.loadAllMedicine();
    _finishLoading();
  }

  void search(String keyword) async {
    _startLoading();
    _medicines = await _repository.search(keyword);
    _finishLoading();
  }

  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void _finishLoading() {
    _isLoading = false;
    notifyListeners();
  }
}