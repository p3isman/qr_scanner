import 'package:flutter/material.dart';

import 'db_provider.dart';

// Front-end for the scans
class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String selectedType = 'http';

  /// Stores a new scan
  Future<ScanModel?> newScan(String value) async {
    // Create a new ScanModel
    final scan = new ScanModel(value: value);

    if (scan.type == null) {
      return null;
    }

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

  Future<void> loadScans() async {
    final allScans = await DBProvider.db.getAllScans();
    this.scans = [...allScans];
    notifyListeners();
  }

  Future<void> loadScansByType(String type) async {
    final loadedScans = await DBProvider.db.getScansByType(type);
    this.scans = [...loadedScans];
    this.selectedType = type;
    notifyListeners();
  }

  Future<void> deleteAllScans() async {
    await DBProvider.db.deleteAllScans();
    this.scans = [];
    notifyListeners();
  }

  Future<void> deleteScanById(int id) async {
    await DBProvider.db.deleteScan(id);
    // Reload list
    loadScansByType(selectedType);
    notifyListeners();
  }
}
