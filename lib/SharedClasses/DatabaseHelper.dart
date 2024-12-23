import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/HomeView/UserRoaster.dart';
import 'package:mysis/Profile/ContactSIS.dart';
import 'package:mysis/Profile/UserPosting.dart';
import 'package:mysis/Profile/UserProfile.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Profile/UnitDutyPost.dart';
import '../Profile/UnitShiftDetail.dart';

class DatabaseHelper {

  DatabaseHelper._() {}
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._();
  // Getter for the instance
  static DatabaseHelper get instance => _instance;


  // static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  // DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('mysis_database.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final pathToDatabase = join(dbPath, path);

    return await openDatabase(pathToDatabase, version: 1, onCreate: _createDB);
  }



  void _createDB(Database db, int version) async {
    await db.execute(generateCreateTableSQL(keyTableUserProfile, UserProfile.fields));
    await db.execute(generateCreateTableSQL(keyTableUnitDutyPost, UnitDutyPost.fields));
    await db.execute(generateCreateTableSQL(keyTableUnitShiftDetail, UnitShiftDetail.fields));
    await db.execute(generateCreateTableSQL(keyTableUserPosting, UserPosting.fields));
    await db.execute(generateCreateTableSQL(keyTableContactSIS, ContactSIS.fields));
    await db.execute(generateCreateTableSQL(keyTableUserRoster, UserRoaster.fields));

  }

  String generateCreateTableSQL(String tableName, Map<String, String> fields) {
    final columns = fields.entries
        .map((entry) => '${entry.key} ${entry.value}')
        .join(', ');

    return 'CREATE TABLE $tableName ($columns)';
  }


  Future<int> insertTableData(String tableName, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(tableName, row);
  }

  Future<void> insertRecords<T>(String tableName, List<T> records, Map<String, dynamic> Function(T) toMap) async {
    final db = await instance.database;
    for (var record in records) {
      await db.insert(tableName, toMap(record));
    }
  }

  Future<int> insertRecord<T>(String tableName, T record, Map<String, dynamic> Function(T) toMap) async {
    final db = await instance.database;
    return await db.insert(tableName, toMap(record));
  }


  Future<Map<String, dynamic>?> getSingleRow(String tableName, String column, String value) async {
    final db = await instance.database;

    // Querying the database to get a single row based on the column value
    final List<Map<String, dynamic>> result = await db.query(
        tableName,
        where: '$column = ?',  // Adding where clause to filter by column value
        whereArgs: [value],    // Providing the value for the condition
        limit: 1               // Ensures only one row is returned
    );

    // If result is not empty, return the first row, else return null
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }


  Future<int> updateTableData(String tableName, Map<String, dynamic> row, String idField) async {
    final db = await instance.database;

    final id = row[idField];
    return await db.update(
      tableName,
      row,
      where: '$idField = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTableData(String tableName, String idField, dynamic idValue) async {
    final db = await instance.database;

    return await db.delete(
      tableName,
      where: '$idField = ?',
      whereArgs: [idValue],
    );
  }


  Future<void> replaceTableData<T>(String tableName, List<T> newData, Map<String, dynamic> Function(T) toMap,) async {
    final db = await DatabaseHelper.instance.database;

    // Start a database transaction for atomicity
    await db.transaction((txn) async {
      // Delete all rows from the table
      await txn.delete(tableName);
      print('All rows deleted from $tableName');

      // Insert new rows into the table
      for (var item in newData) {
        await txn.insert(tableName, toMap(item));
      }
      print('New rows inserted into $tableName');
    });
  }

  Future<List<T>> getAllRecords<T>(
      String tableName,
      T Function(Map<String, dynamic>) fromMap,
      ) async {
    final db = await instance.database;

    // Query all rows from the given table
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    print('User data retrieved:');
    print(maps);

    // Use the generic fromMapList method to convert the maps to a list of type T
    List<T> data = maps.map((map) => fromMap(map)).toList();


    return data;
  }

}
