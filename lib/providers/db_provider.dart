import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/scan_model.dart';

export 'package:qr_scanner/models/scan_model.dart';

// Back-end database
class DBProvider {
  static Database? _database;

  /// Singleton
  static final DBProvider db = DBProvider._();

  // Private constructor
  DBProvider._();

  /// Database getter
  Future<Database?> get database async {
    // If database exists return it
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  /// Creates a table for the scans
  Future<Database> initDB() async {
    // Get database path
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');

    // Create database and return it
    return await openDatabase(
      path,
      // Change version when we call openDatabase
      version: 1,
      onOpen: (Database db) {},
      onCreate: (Database db, int version) async {
        // SQL query
        await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            type TEXT,
            value TEXT
          );
        ''');
      },
    );
  }

// INSERTS
  /// Inserts a scan with raw SQL
  Future<int> newRawScan(ScanModel newScan) async {
    final id = newScan.id;
    final type = newScan.type;
    final value = newScan.value;

    // Executes the database getter
    final db = await database;

    final res = await db!.rawInsert('''
      insert into Scans(id, type, value)
        values($id, $type, $value)
    ''');

    return res;
  }

  /// Inserts a scan with JSON from ScanModel
  Future<int> newScan(ScanModel newScan) async {
    final db = await database;
    final res = await db!.insert('Scans', newScan.toJson());

    /// ID of the last inserted row
    return res;
  }

// QUERIES
  /// Returns a scan by ID
  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    final res = await db!.query('Scans', where: 'id = ?', whereArgs: [id]);

    // Returns the first element from the list (there's just one)
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  /// Returns a list with all the scans
  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db!.query('Scans');

    return res.isNotEmpty
        ? res.map((scan) => ScanModel.fromJson(scan)).toList()
        : [];
  }

  /// Returns one type of scans
  Future<List<ScanModel>> getScansByType(String type) async {
    final db = await database;
    final res = await db!.query('Scans', where: 'type = ?', whereArgs: [type]);

    return res.isNotEmpty
        ? res.map((scan) => ScanModel.fromJson(scan)).toList()
        : [];
  }

  /// Updates a row
  Future<int> updateScan(ScanModel newScan) async {
    final db = await database;
    final res = await db!.update('Scans', newScan.toJson(),
        where: 'id = ?', whereArgs: [newScan.id]);

    return res;
  }

  /// Deletes a row
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db!.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  /// Deletes the table
  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db!.delete('Scans');

    return res;
  }
}
