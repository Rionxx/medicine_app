import 'package:medicine_app_database/database/db_helper.dart';
import 'package:medicine_app_database/model/medicine.dart';

class MedicineRepository {
  final MedicineData _medicineData;

  MedicineRepository(this._medicineData);

  Future<List<Medicine>> loadAllMedicine() => _medicineData.loadAllMedicine();

  Future<List<Medicine>> search(String keyword) => _medicineData.search(keyword);

  Future insert(Medicine medicine) => _medicineData.insert(medicine);

  Future update(Medicine medicine) => _medicineData.update(medicine);

  Future delete(Medicine medicine) => _medicineData.delete(medicine);
}