import 'package:flutter/material.dart';
import 'package:qr_scanner/models/scan_model.dart';
import 'package:qr_scanner/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String selectedType = 'http';

  /// Stores a new scan
  void newScan(String value) async {
    // Create a new ScanModel
    final scan = new ScanModel(value: value);
    final id = await DBProvider.db.newScan(scan);
    scan.id = id;

    // Add scan to list if scan has the same type
    if (scan.type == selectedType) {
      scans.add(scan);
      notifyListeners();
    }
  }

  void loadScans() async {
    final allScans = await DBProvider.db.getAllScans();
    scans = [...allScans];
  }
}
