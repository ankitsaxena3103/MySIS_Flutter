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

  static Database? _database;

  Future<Database> get database async {

    if (_database != null && _database!.isOpen) return _database!;

    _database = await _initDB(keyDataBaseName);
    return _database!;
  }
  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final pathToDatabase = join(dbPath, path);

    final db = await openDatabase(
      pathToDatabase,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );

    // // 🔥 ALWAYS apply pragmas
    await db.rawQuery('PRAGMA journal_mode=WAL');
    await db.rawQuery('PRAGMA synchronous=NORMAL');
    // await db.rawQuery('PRAGMA foreign_keys=ON');


    return db;
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

    // await db.execute('DROP VIEW IF EXISTS vwRosterDetail');

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

    await db.execute('''
      Create View vwShiftForDate AS
      select distinct
      M.shiftId
      , M.shiftName
      , M.postId
      ,M.dutyHrs
      , PD.postName
      , M.unitCode
      , D.shiftStartDate
      , D.shiftStartDate || ' ' || M.startTime shiftStartTime
      , Datetime(D.shiftStartDate || ' ' || M.startTime, '+' || CAST(CAST(STRFTIME('%H', M.dutyHrs) AS INTEGER) * 60 + CAST(STRFTIME('%M', M.dutyHrs) AS INTEGER) as STRING) || ' minutes') shiftEndTime
      , Datetime(D.shiftStartDate || ' ' || M.startTime, '-' || CAST(CAST(STRFTIME('%H', M.shiftStartBefore) AS INTEGER) * 60 + CAST(STRFTIME('%M', M.shiftStartBefore) AS INTEGER) as STRING) || ' minutes') dutyStartEnableTime
      , Datetime(D.shiftStartDate || ' ' || M.startTime, '+' || CAST(CAST(STRFTIME('%H', M.dutyHrs) AS INTEGER) * 60 + CAST(STRFTIME('%M', M.dutyHrs) AS INTEGER) as STRING) || ' minutes'
      , '-' || CAST(CAST(STRFTIME('%H', M.dutyInBefore) AS INTEGER) * 60 + CAST(STRFTIME('%M', M.dutyInBefore) AS INTEGER) as STRING) || ' minutes' ) dutyStartDisableTime
      , Datetime(D.shiftStartDate || ' ' || M.startTime, '+' || CAST(CAST(STRFTIME('%H', M.dutyHrs) AS INTEGER) * 60 + CAST(STRFTIME('%M', M.dutyHrs) AS INTEGER) as STRING) || ' minutes'
      , '+' || CAST(CAST(STRFTIME('%H', M.shiftEndAfter) AS INTEGER) * 60 + CAST(STRFTIME('%M', M.shiftEndAfter) AS INTEGER) as STRING) || ' minutes') dutyEndDisableTime
      from UnitShiftDetail M
      inner join UnitDutyPost PD on M.postId=PD.id
      cross join(SELECT DATE('now') AS shiftStartDate Union Select DATE('now', '-1 day') AS Shiftdate union select DATE('now', '+1 day') AS Shiftdate) D
      where M.deleted=0
''');


  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // 🔹 Create or update your new view safely
      await _upgradeViews(db);

    }
  }
  Future<void> _upgradeViews(Database db) async {

    await db.execute('DROP VIEW IF EXISTS vwShiftForDate');

    await db.execute('''
      CREATE VIEW vwShiftForDate AS
      select distinct
      M.shiftId
      , M.shiftName
      , M.postId
      ,M.dutyHrs
      , PD.postName
      , M.unitCode
      , D.shiftStartDate
      , D.shiftStartDate || ' ' || M.startTime shiftStartTime
      , Datetime(D.shiftStartDate || ' ' || M.startTime, '+' || CAST(CAST(STRFTIME('%H', M.dutyHrs) AS INTEGER) * 60 + CAST(STRFTIME('%M', M.dutyHrs) AS INTEGER) as STRING) || ' minutes') shiftEndTime
      , Datetime(D.shiftStartDate || ' ' || M.startTime, '-' || CAST(CAST(STRFTIME('%H', M.shiftStartBefore) AS INTEGER) * 60 + CAST(STRFTIME('%M', M.shiftStartBefore) AS INTEGER) as STRING) || ' minutes') dutyStartEnableTime
      , Datetime(D.shiftStartDate || ' ' || M.startTime, '+' || CAST(CAST(STRFTIME('%H', M.dutyHrs) AS INTEGER) * 60 + CAST(STRFTIME('%M', M.dutyHrs) AS INTEGER) as STRING) || ' minutes'
      , '-' || CAST(CAST(STRFTIME('%H', M.dutyInBefore) AS INTEGER) * 60 + CAST(STRFTIME('%M', M.dutyInBefore) AS INTEGER) as STRING) || ' minutes' ) dutyStartDisableTime
      , Datetime(D.shiftStartDate || ' ' || M.startTime, '+' || CAST(CAST(STRFTIME('%H', M.dutyHrs) AS INTEGER) * 60 + CAST(STRFTIME('%M', M.dutyHrs) AS INTEGER) as STRING) || ' minutes'
      , '+' || CAST(CAST(STRFTIME('%H', M.shiftEndAfter) AS INTEGER) * 60 + CAST(STRFTIME('%M', M.shiftEndAfter) AS INTEGER) as STRING) || ' minutes') dutyEndDisableTime
      from UnitShiftDetail M
      inner join UnitDutyPost PD on M.postId=PD.id
      cross join(SELECT DATE('now') AS shiftStartDate Union Select DATE('now', '-1 day') AS Shiftdate union select DATE('now', '+1 day') AS Shiftdate) D
      where M.deleted=0
''');


  }

  String generateCreateTableSQL(String tableName, Map<String, String> fields) {
    final columns = fields.entries
        .map((entry) => '${entry.key} ${entry.value}')
        .join(', ');

    return 'CREATE TABLE $tableName ($columns)';
  }

  Future<void> insertTableData<T>(String tableName, List<T> items, Map<String, dynamic> Function(T) toMap,) async {
    final db = await DatabaseHelper.instance.database;

    // Use a transaction to ensure atomicity
    await db.transaction((txn) async {
      for (final item in items) {
        // Convert each item to a map and insert into the table
        await txn.insert(tableName, toMap(item));
      }
    });
  }
  Future<void> insertRecords<T>(
      String tableName,
      List<T> records,
      Map<String, dynamic> Function(T) toMap,
      ) async {
    final db = await instance.database;

    await db.transaction((txn) async {
      for (final record in records) {
        await txn.insert(
          tableName,
          toMap(record),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<int> insertRecordOld<T>(String tableName, T record, Map<String, dynamic> Function(T) toMap) async {
    final db = await instance.database;
    return await db.insert(tableName, toMap(record));
  }

  Future<int> insertRecord<T>(
      String tableName,
      T record,
      Map<String, dynamic> Function(T) toMap,
      ) async {
    final db = await instance.database;

    int id = 0;

    await db.transaction((txn) async {
      id = await txn.insert(
        tableName,
        toMap(record),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    return id;
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
  Future<int> updateTableColumns(String tableName, Map<String, dynamic> row, String idField,) async {
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
  Future<void> updateTableData<T>(String tableName, List<T> items, String idField, Map<String, dynamic> Function(T) toMap,) async {
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
  Future<void> updateOrInsertTableData<T>(String tableName, List<T> items, String idField, Map<String, dynamic> Function(T) toMap,) async {
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

  //need to check these 2 methods for db lock
  Future<void> replaceTableData<T>(String tableName, List<T> newData, Map<String, dynamic> Function(T) toMap,) async {
    final db = await DatabaseHelper.instance.database;

    // Start a database transaction for atomicity
    await db.transaction((txn) async {
      // Delete all rows from the table
      await txn.delete(tableName);
      printInDebug('All rows deleted from $tableName');

      // Insert new rows into the table
      for (var item in newData) {
        await txn.insert(tableName, toMap(item));
      }
      printInDebug('New rows inserted into $tableName');
    });
  }
  Future<void> replaceTableDataSync<T>(
      String tableName,
      List<T> newData,
      Map<String, dynamic> Function(T) toMap,
      ) async {
    final db = await DatabaseHelper.instance.database;

    await db.transaction((txn) async {
      // 1. Clear the table
      await txn.delete(tableName);

      // 2. Prepare all inserts in a single batch
      final batch = txn.batch();
      for (var item in newData) {
        batch.insert(tableName, toMap(item));
      }

      // 3. Execute everything at once
      // noResult: true makes it even faster by not returning IDs
      await batch.commit(noResult: true);
    });

    printInDebug('Sync completed for $tableName');
  }
  Future<void> updateOrDeleteTableData<T>(String tableName, List<T> items, String idField, Map<String, dynamic> Function(T) toMap,) async {
    final db = await DatabaseHelper.instance.database;

    // Use a transaction for atomicity
    await db.transaction((txn) async {
      for (final item in items) {
        // Convert each item to a map
        final row = toMap(item);
        debugPrint('Saving row: $row');

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
        }
        else {
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


  Future<List<T>> getAllRecords<T>(String tableName, T Function(Map<String, dynamic>) fromMap,) async {

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
  Future<List<Map<String, dynamic>>> getTableRecordsOld() async {
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

  Future<List<Map<String, dynamic>>> getTableRecords() async {
    final db = await instance.database;

    return await db.transaction((txn) async {
      final List<Map<String, dynamic>> tables = await txn.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
      );

      List<Map<String, dynamic>> tableRecords = [];

      for (final table in tables) {
        final tableName = table['name'] as String;

        final totalRecords = Sqflite.firstIntValue(
          await txn.rawQuery("SELECT COUNT(*) FROM $tableName"),
        ) ?? 0;

        final columns = await txn.rawQuery("PRAGMA table_info($tableName)");

        final hasDirtyFlag =
        columns.any((c) => c['name'] == 'dirtyFlag');

        final hasUpdatedAt =
        columns.any((c) => c['name'] == 'updatedAt');

        int unsynced = 0;
        if (hasDirtyFlag) {
          unsynced = Sqflite.firstIntValue(
            await txn.rawQuery(
              "SELECT COUNT(*) FROM $tableName WHERE dirtyFlag = 1",
            ),
          ) ?? 0;
        }

        String? latestUpdate;
        if (hasUpdatedAt) {
          final res = await txn.rawQuery(
            "SELECT MAX(updatedAt) AS latestUpdate FROM $tableName",
          );
          latestUpdate = res.first['latestUpdate']?.toString();
        }

        tableRecords.add({
          'tableName': tableName,
          'totalRecords': totalRecords,
          'unsyncedRecords': hasDirtyFlag ? unsynced : null,
          'latestUpdateTime': hasUpdatedAt ? latestUpdate : null,
        });
      }

      return tableRecords;
    });
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
    final seenKeys = <String>{};

    final rosters1 = result.map((row) => UserRoaster.fromMap(row)).toList();

    final rosters =  rosters1.where((item) {
      final key =
          '${item.shiftName}|${item.shiftStartTime?.toIso8601String()}|${item.shiftEndTime?.toIso8601String()}';

      if (seenKeys.contains(key)) {
        return false; // duplicate → remove
      } else {
        seenKeys.add(key);
        return true; // unique → keep
      }
    }).toList();
    print('updateCurrentDayRoasterUI......fetchRosterFromView...${rosters.length}');

    printInDebug('vwRosterDetail');
    for (var roster in rosters) {
      debugPrint('📌 Roster ID: ${roster.rosterId}, '
          'Site: ${roster.siteName}, '
          'Shift: ${roster.shiftName}, '
          'Start: ${roster.shiftStartTime}, '
          'End: ${roster.shiftEndTime}'
          'actEnd: ${roster.actEndTime}'
          'actStartTime: ${roster.actStartTime}'

      );
    }
    return rosters;
  }

  Future<List<Map<String, dynamic>>> getDirtyRowsOld(String tableName) async {
    final db = await instance.database;

    return await db.query(
      tableName,
      where: "dirtyFlag = ?",
      whereArgs: [1],
    );
  }
  Future<List<Map<String, dynamic>>> getDirtyRows(String tableName) async {
    final db = await instance.database;

    return await db.transaction((txn) async {
      return await txn.query(
        tableName,
        where: 'dirtyFlag = ?',
        whereArgs: [1],
      );
    });
  }

  Future<String?> getMaxDateModifiedOld(String tableName) async {
    final db = await database;

    // Check if the column exists in the table
    final columnsResult = await db.rawQuery(
        "PRAGMA table_info($tableName);"
    );

    final columnNames = columnsResult.map((c) => c['name'] as String).toList();
    if (!columnNames.contains('dateModified')) {
      printInDebug("Column dateModified does not exist in $tableName");
      return null;
    }

    // Safe to query
    final result = await db.rawQuery(
        'SELECT MAX(dateModified) as maxDate FROM $tableName'
    );

    if (result.isNotEmpty && result.first['maxDate'] != null) {
      return result.first['maxDate'] as String;
    }
    return null; // No rows
  }
  Future<String?> getMaxDateModified(
      String tableName, {
        DatabaseExecutor? executor,
      }) async {
    final db = executor ?? await database;

    final columnsResult = await db.rawQuery(
      'PRAGMA table_info($tableName)',
    );

    final columnNames =
    columnsResult.map((c) => c['name'] as String).toList();

    if (!columnNames.contains('dateModified')) {
      printInDebug("Column dateModified does not exist in $tableName");
      return null;
    }

    final result = await db.rawQuery(
      'SELECT MAX(dateModified) AS maxDate FROM $tableName',
    );

    if (result.isNotEmpty && result.first['maxDate'] != null) {
      return result.first['maxDate'] as String;
    }

    return null;
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

  Future<List<UnitShiftDetail>> getAllowedShifts() async {
    final db = await instance.database;

    final result = await db.rawQuery('''
    SELECT 
      M.*,
      CASE WHEN D.id IS NULL THEN 1 ELSE 0 END AS allowedMark,
      CASE WHEN D.id IS NULL THEN '' ELSE 'Already Marked' END AS notAllowedReason
    FROM vwShiftForDate M
    LEFT OUTER JOIN UserAttendance D
      ON M.shiftId = D.shiftId
      AND M.shiftStartDate = D.shiftStartDate
      AND D.deleted = 0
      AND D.isAbsent = 0
    WHERE datetime('now') BETWEEN M.dutyStartEnableTime AND M.dutyStartDisableTime
  ''');

    final shifts = result.map((row) => UnitShiftDetail.fromViewMap(row)).toList();

    printInDebug('Fetched ${shifts.length} shifts from vwShiftForDate');
    for (var shift in shifts) {
      debugPrint('📌 Shift ID: ${shift.shiftId}, '
          'AllowedMark: ${shift.allowedMark}, '
          'Reason: ${shift.notAllowedReason}, '
          'Shift Name: ${shift.shiftName}, '
          'Unit: ${shift.unitCode}'
          'duty hrs: ${shift.dutyHrs}'
          'duty start time: ${shift.startTime}'
          'duty end time: ${shift.endTime}'

      );
    }

    return shifts;
  }

}



