import 'package:flutter/foundation.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/EscortDuty/EscortDuty.dart';
import 'package:mysis/GeneralQuestions/HelpMaster.dart';
import 'package:mysis/HomeView/UserAttendance.dart';
import 'package:mysis/HomeView/UserRoaster.dart';
import 'package:mysis/Leaves/LeaveType.dart';
import 'package:mysis/Leaves/UserLeaves.dart';
import 'package:mysis/Notifications/UserNotification.dart';
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

    _database = await _initDB(keyDataBaseName);
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final pathToDatabase = join(dbPath, path);

    return await openDatabase(pathToDatabase, version: 1, onCreate: _createDB);
  }


  void _createDB(Database db, int version) async {
    // Create all tables
    await db.execute(generateCreateTableSQL(keyTableUserProfile, UserProfile.fields));
    await db.execute(generateCreateTableSQL(keyTableUnitDutyPost, UnitDutyPost.fields));
    await db.execute(generateCreateTableSQL(keyTableUnitShiftDetail, UnitShiftDetail.fields));
    await db.execute(generateCreateTableSQL(keyTableUserPosting, UserPosting.fields));
    await db.execute(generateCreateTableSQL(keyTableContactSIS, ContactSIS.fields));
    await db.execute(generateCreateTableSQL(keyTableUserRoster, UserRoaster.fields));
    await db.execute(generateCreateTableSQL(keyTableUserNotification, UserNotification.fields));
    await db.execute(generateCreateTableSQL(keyTableUserAttendance, UserAttendance.fields));
    await db.execute(generateCreateTableSQL(keyTableLeaveType, LeaveType.fields));
    await db.execute(generateCreateTableSQL(keyTableUserLeave, UserLeaves.fields));
    await db.execute(generateCreateTableSQL(keyTableHelpMaster, HelpMaster.fields));
    await db.execute(generateCreateTableSQL(keyTableEscortDuty, EscortDuty.fields));

    //  Create all views
    await _createViews(db);
  }

  Future<void> _createViews(Database db) async {
    await db.execute('''
    CREATE VIEW IF NOT EXISTS vwUnitShift AS
    SELECT DISTINCT shiftId, dutyHrs, shiftStartBefore, shiftEndAfter, dutyInBefore, startTime, endTime
    FROM UnitShiftDetail
  ''');

    await db.execute('''
    CREATE VIEW IF NOT EXISTS vwRoster AS
    SELECT 
        unitCode, siteName, shiftId, shiftName,
        strftime('%Y-%m-%d', rosterDate) AS rosterDate,
        strftime('%H:%M:%S', startTime)  AS startTime,
        strftime('%H:%M:%S', endTime)    AS endTime,
        dutyHrs,
        strftime('%Y-%m-%d %H:%M:%S', shiftStartTime) AS shiftStartTime,
        strftime('%Y-%m-%d %H:%M:%S', shiftEndTime)   AS shiftEndTime,
        strftime('%Y-%m-%d %H:%M:%S', dutyStartEnableTime)  AS dutyStartEnableTime,
        strftime('%Y-%m-%d %H:%M:%S', dutyStartDisableTime) AS dutyStartDisableTime,
        strftime('%Y-%m-%d %H:%M:%S', dutyEndDisableTime)   AS dutyEndDisableTime,
        regNo, dutyPostId, postName, qrId, dutyPostAddress,
        geoFenceRange, isGeoFenceAllow, geoLocation
    FROM UserRoster
    UNION
    SELECT 
        M.unitCode, M.siteName, M.shiftId, M.shiftName,
        strftime('%Y-%m-%d', M.shiftStartDate) AS rosterDate,
        strftime('%H:%M:%S', D.startTime)      AS startTime,
        strftime('%H:%M:%S', D.endTime)        AS endTime,
        M.shiftHrs dutyHrs,
        strftime('%Y-%m-%d %H:%M:%S', M.shiftStartTime) AS shiftStartTime,
        strftime('%Y-%m-%d %H:%M:%S', M.shiftEndTime)   AS shiftEndTime,
        strftime('%Y-%m-%d %H:%M:%S', datetime(M.shiftStartTime, '-' || shiftStartBefore)) AS dutyStartEnableTime,
        strftime('%Y-%m-%d %H:%M:%S', datetime(M.shiftEndTime, '-1 hours'))                 AS dutyStartDisableTime,
        strftime('%Y-%m-%d %H:%M:%S', datetime(M.shiftEndTime, shiftEndAfter))              AS dutyEndDisableTime,
        M.regNo, M.dutyPostId, M.dutyPostName AS postName,
        E.qrId, E.address AS dutyPostAddress, E.allowDistance AS geoFenceRange,
        E.isGeoFenceAllow AS isGeoFenceAllow, E.geoLocation AS geoLocation
    FROM UserAttendance M
    INNER JOIN vwUnitShift D ON M.shiftId=D.shiftId
    INNER JOIN UnitDutyPost E ON M.dutyPostId=E.Id
    ORDER BY rosterDate
  ''');

    await db.execute('DROP VIEW IF EXISTS vwRosterDetail');

    await db.execute('''
  CREATE VIEW vwRosterDetail AS
  SELECT M.*, D.dutyStatus, D.actStartTime, D.actEndTime
  FROM vwRoster M
  LEFT OUTER JOIN UserAttendance D
    ON M.regNo=D.regNo
   AND M.unitCode=D.unitCode
   AND M.shiftId=D.shiftId
   AND M.rosterDate= strftime('%Y-%m-%d', D.shiftStartDate)
   AND M.dutyPostId=D.dutyPostId
  WHERE strftime('%Y-%m-%d', datetime('now')) >= date('now')
''');

    //   await db.execute('''
  //   CREATE VIEW IF NOT EXISTS vwRosterDetail AS
  //   SELECT M.*, D.dutyStatus, D.actStartTime, D.actEndTime
  //   FROM vwRoster M
  //   LEFT OUTER JOIN UserAttendance D
  //     ON M.regNo=D.regNo
  //    AND M.unitCode=D.unitCode
  //    AND M.shiftId=D.shiftId
  //    AND M.rosterDate= strftime('%Y-%m-%d', D.shiftStartDate)
  //    AND M.dutyPostId=D.dutyPostId
  //    WHERE date(dutyStartEnableTime) >= date('now')
  //   // WHERE strftime('%Y-%m-%d', dutyStartEnableTime)
  //   //       BETWEEN strftime('%Y-%m-%d', datetime('now'))
  //   //           AND strftime('%Y-%m-%d', datetime('now', '1 day'))
  // ''');
  }

  String generateCreateTableSQL(String tableName, Map<String, String> fields) {
    final columns = fields.entries
        .map((entry) => '${entry.key} ${entry.value}')
        .join(', ');

    return 'CREATE TABLE $tableName ($columns)';
  }


  Future<void> insertTableData<T>(
      String tableName,
      List<T> items,
      Map<String, dynamic> Function(T) toMap,
      ) async {
    final db = await DatabaseHelper.instance.database;

    // Use a transaction to ensure atomicity
    await db.transaction((txn) async {
      for (final item in items) {
        // Convert each item to a map and insert into the table
        await txn.insert(tableName, toMap(item));
      }
    });
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


  /// Returns the number of rows affected by the update.
  Future<int> updateTableColumns(
      String tableName,
      Map<String, dynamic> row,
      String idField,
      ) async {
    final db = await instance.database;

    // Extract the ID value from the row
    final id = row[idField];

    // Perform the update
    return await db.update(
      tableName,
      row,
      where: '$idField = ?',
      whereArgs: [id],
    );
  }


  Future<void> updateTableData<T>(
      String tableName,
      List<T> items,
      String idField,
      Map<String, dynamic> Function(T) toMap,
      ) async {
    final db = await DatabaseHelper.instance.database;

    // Use a transaction for atomicity
    await db.transaction((txn) async {
      for (final item in items) {
        // Convert each item to a map
        final row = toMap(item);

        // Extract the ID value using the idField
        final id = row[idField];

        // Perform the update query
        await txn.update(
          tableName,
          row,
          where: '$idField = ?',
          whereArgs: [id],
        );
      }
    });
  }



  Future<void> updateOrDeleteTableData<T>(
      String tableName,
      List<T> items,
      String idField,
      Map<String, dynamic> Function(T) toMap,
      ) async {
    final db = await DatabaseHelper.instance.database;

    // Use a transaction for atomicity
    await db.transaction((txn) async {
      for (final item in items) {
        // Convert each item to a map
        final row = toMap(item);

        // Extract the ID value using the idField
        final id = row[idField];

        // Check if the item already exists in the table
        final existingRecords = await txn.query(
          tableName,
          where: '$idField = ?',
          whereArgs: [id],
        );

        if (row['deleted'] == 1) {
          if (existingRecords.isNotEmpty) {
            // If 'deleted' is 1 and the record exists, delete it
            await txn.delete(
              tableName,
              where: '$idField = ?',
              whereArgs: [id],
            );
          }
          else {
            // Log or handle the case where the record doesn't exist
            printInDebug('Record with ID $id marked as deleted but does not exist.');
          }
        } else {
          if (existingRecords.isNotEmpty) {
            // If the record exists, update it
            await txn.update(
              tableName,
              row,
              where: '$idField = ?',
              whereArgs: [id],
            );
          } else {
            // If the record doesn't exist, insert it
            await txn.insert(tableName, row);
          }
        }
      }
    });
  }




  Future<void> updateOrInsertTableData<T>(
      String tableName,
      List<T> items,
      String idField,
      Map<String, dynamic> Function(T) toMap,
      ) async {
    final db = await DatabaseHelper.instance.database;

    // Use a transaction for atomicity
    await db.transaction((txn) async {
      for (final item in items) {
        // Convert each item to a map
        final row = toMap(item);

        // Extract the ID value using the idField
        final id = row[idField];

        // Check if the row exists
        final existingRows = await txn.query(
          tableName,
          where: '$idField = ?',
          whereArgs: [id],
        );

        if (existingRows.isNotEmpty) {
          // Row exists: Perform update
          await txn.update(
            tableName,
            row,
            where: '$idField = ?',
            whereArgs: [id],
          );
        } else {
          // Row does not exist: Perform insert
          await txn.insert(tableName, row);
        }
      }
    });
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
    printInDebug('$tableName retrieved:');
    if (kDebugMode) {
      print(maps);
    }

    // Use the generic fromMapList method to convert the maps to a list of type T
    List<T> data = maps.map((map) => fromMap(map)).toList();


    return data;
  }

  Future<int> deleteTableData(String tableName, String idField, dynamic idValue) async {
    final db = await instance.database;

    return await db.delete(
      tableName,
      where: '$idField = ?',
      whereArgs: [idValue],
    );
  }



  Future<List<Map<String, dynamic>>> getTableRecords() async {
    // Fetch all table names
    final db = await instance.database;

    final List<Map<String, dynamic>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'");

    List<Map<String, dynamic>> tableRecords = [];

    for (var table in tables) {
      String tableName = table['name'];

      // Get total record count
      int totalRecords = Sqflite.firstIntValue(
          await db.rawQuery("SELECT COUNT(*) FROM $tableName")) ?? 0;

      // Check if the table has a `dirtyFlag` column
      bool hasDirtyFlag = (await db.rawQuery("PRAGMA table_info($tableName)"))
          .any((column) => column['name'] == 'dirtyFlag');

      int unSyncedRecords = 0;
      if (hasDirtyFlag) {
        // Get unSynced record count
        unSyncedRecords = Sqflite.firstIntValue(await db.rawQuery(
            "SELECT COUNT(*) FROM $tableName WHERE dirtyFlag = 1")) ?? 0;
      }

      // Check if the table has an `updated_at` column
      bool hasUpdatedAt = (await db.rawQuery("PRAGMA table_info($tableName)"))
          .any((column) => column['name'] == 'updatedAt');

      String? latestUpdateTime;
      if (hasUpdatedAt) {
        // Get the latest `updated_at` datetime
        final result = await db.rawQuery(
            "SELECT MAX(updatedAt) as latestUpdateTime FROM $tableName");
        latestUpdateTime = result.isNotEmpty && result[0]['latestUpdateTime'] != null
            ? result[0]['latestUpdateTime'].toString()
            : null;
      }

      // Add table data to the list
      tableRecords.add({
        'tableName': tableName,
        'totalRecords': totalRecords,
        'unsyncedRecords': hasDirtyFlag ? unSyncedRecords : null,
        'latestUpdateTime': hasUpdatedAt ? latestUpdateTime : null,
      });
    }

    return tableRecords;
  }


  Future<bool> clearTable(String tableName) async {
    final db = await instance.database;

    try {
      // 🔹 Check if table has a dirtyFlag column
      final columnInfo = await db.rawQuery("PRAGMA table_info($tableName)");
      final hasDirtyFlag = columnInfo.any((col) => col['name'] == 'dirtyFlag');

      if (hasDirtyFlag) {
        final result = await db.rawQuery(
            "SELECT COUNT(*) as cnt FROM $tableName WHERE dirtyFlag = 1"
        );

        final unsyncedCount = Sqflite.firstIntValue(result) ?? 0;

        if (unsyncedCount > 0) {
          printInDebug("Skipped clearing $tableName → $unsyncedCount unsynced rows exist");
          return false; // Do not clear if unsynced data exists
        }
      }

      // 🔹 Safe to clear (either no dirtyFlag or no unsynced rows)
      await db.rawDelete("DELETE FROM $tableName");
      printInDebug("Cleared table: $tableName");
      return true;
    } catch (e) {
      printInDebug("Error clearing table $tableName: $e");
      return false;
    }
  }
  Future<bool> clearAllTables(List<Map<String, dynamic>> tables) async {
    final db = await instance.database;

    try {
      // Create a list of futures for clearing tables
      List<Future<void>> clearTableFutures = tables.map((table) async {
        String tableName = table['tableName'];
        await db.rawQuery("DELETE FROM $tableName");
      }).toList();

      // Wait for all the delete operations to complete
      await Future.wait(clearTableFutures);

      // Return true when all tables are cleared
      return true;
    } catch (e) {
      // Handle any errors and return false
      printInDebug("Error clearing tables: $e");
      return false;
    }
  }

  Future<int> countMonthExtraDuties(String empId, int month, int year) async {
    final db = await instance.database;

    final result = await db.rawQuery('''
    SELECT COUNT(DISTINCT duty_date) as total_extra_duty
    FROM (
      SELECT DATE(shiftStartDate) as duty_date, COUNT(*) as total_shifts
      FROM UserAttendance
      WHERE strftime('%m', shiftStartDate) = ? 
        AND strftime('%Y', shiftStartDate) = ? 
        AND regNo = ?
        AND shiftMin = 720
      GROUP BY duty_date
      HAVING total_shifts > 1
    ) 
  ''', [month.toString().padLeft(2, '0'), year.toString(), empId]);

    return result.isNotEmpty ? result.first['total_extra_duty'] as int : 0;
  }

  Future<int> getTotalDutyMinutes(String empId, int date, int month, int year) async {
    final db = await instance.database;

    final result = await db.rawQuery('''
    SELECT SUM(shiftMin) as total_duty_minutes
    FROM UserAttendance
    WHERE strftime('%m', shiftStartDate) = ? 
      AND strftime('%Y', shiftStartDate) = ? 
      AND strftime('%d', shiftStartDate) = ? 
      AND regNo = ?
  ''', [month.toString().padLeft(2, '0'), year.toString(), date.toString().padLeft(2, '0'), empId]);

    return result.isNotEmpty && result.first['total_duty_minutes'] != null
        ? result.first['total_duty_minutes'] as int
        : 0;
  }


  Future<List<UserRoaster>> fetchRosterFromView() async {
    final db = await instance.database;
    final result = await db.query('vwRosterDetail');
    final rosters = result.map((row) => UserRoaster.fromMap(row)).toList();

    printInDebug('vwRosterDetail');
    for (var roster in rosters) {
      debugPrint('📌 Roster ID: ${roster.rosterId}, '
          'Site: ${roster.siteName}, '
          'Shift: ${roster.shiftName}, '
          'Start: ${roster.shiftStartTime}, '
          'End: ${roster.shiftEndTime}');
    }
    return rosters;
  }

  Future<List<Map<String, dynamic>>> getDirtyRows(String tableName) async {
    final db = await instance.database;

    return await db.query(
      tableName,
      where: "dirtyFlag = ?",
      whereArgs: [1],
    );
  }

  Future<void> markRowSynced(String tableName, String idColumn, dynamic idValue) async {
    final db = await instance.database;

    await db.update(
      tableName,
      {"dirtyFlag": 0},
      where: "$idColumn = ?",
      whereArgs: [idValue],
    );
  }


}
