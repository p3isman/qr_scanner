import 'dart:io';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  static Database? _database;

  // Create a unique instance (singleton)
  static final DBProvider dbProvider = DBProvider._();

  // Private constructor
  DBProvider._();

  get database async {
    // If database exists return it
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    // Get database path
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);

    // Create database and return it
    return await openDatabase(
      path,
      // Change version when we call openDatabase
      version: 1,
      onOpen: (db) {},
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
}
