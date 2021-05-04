import 'package:flutter/material.dart';
import 'package:qr_scanner/models/scan_model.dart';
import 'package:qr_scanner/providers/db_provider.dart';

// Front-end for the scans
class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String selectedType = 'http';

  /// Stores a new scan
  Future<ScanModel> newScan(String value) async {
    // Create a new ScanModel
    final scan = new ScanModel(value: value);

    // Store scan in database and generate an ID
    final id = await DBProvider.db.newScan(scan);
    scan.id = id;

    // Add scan to current list if its type is the currently selected
    if (scan.type == selectedType) {
      scans.add(scan);
      notifyListeners();
    }

    return scan;
  }

  void loadScans() async {
    final allScans = await DBProvider.db.getAllScans();
    this.scans = [...allScans];
    notifyListeners();
  }

  void loadScansByType(String type) async {
    final loadedScans = await DBProvider.db.getScansByType(type);
    this.scans = [...loadedScans];
    this.selectedType = type;
    notifyListeners();
  }

  void deleteAllScans() async {
    await DBProvider.db.deleteAllScans();
    this.scans = [];
    notifyListeners();
  }

  void deleteScanById(int id) async {
    await DBProvider.db.deleteScan(id);
    // Reload list
    loadScansByType(selectedType);
    notifyListeners();
  }
}
