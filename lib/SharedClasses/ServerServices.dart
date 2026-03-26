import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../CommonViews/Utility.dart';
import '../HomeView/UserAttendance.dart';
import '../HomeView/UserRoaster.dart';
import '../Notifications/UserNotification.dart';
import '../Profile/UnitDutyPost.dart';
import '../Profile/UnitShiftDetail.dart';
import '../Profile/UserPosting.dart';
import '../Profile/UserProfile.dart';

import 'DatabaseHelper.dart';


class ServerService {
  ServerService._internal();

  static final ServerService _instance = ServerService._internal();
  static ServerService get instance => _instance;

  final StreamController<bool> _syncController =
  StreamController<bool>.broadcast();

  Stream<bool> get onSyncCompleted => _syncController.stream;
  Future<void> loadServerData() async {
    debugPrint('background service started');

    try {
      await onLoadNotificationData();
    } catch (e, st) {
      debugPrint('Error in onLoadNotificationData: $e\n$st');
    }

    try {
      await onLoadAttendanceData();
    } catch (e, st) {
      debugPrint('Error in onLoadAttendanceData: $e\n$st');
    }

    try {
      await onLoadProfileData();
    } catch (e, st) {
      debugPrint('Error in onLoadProfileData: $e\n$st');
    }

    try {
      await onLoadUserPostingData();
    } catch (e, st) {
      debugPrint('Error in onLoad User Posting Data: $e\n$st');
    }

    try {
      await onLoadRoasterData();
    } catch (e, st) {
      debugPrint('Error in onLoadRoasterData: $e\n$st');
    }

    debugPrint('background service finished');

  }
  Future<void> onLoadNotificationData() async {
    // final Map deviceDetails = await getDeviceDetail();
    // final appInfo = await getPackageInfo();

    final Map<String, String> inputData = {
      "run": "sync",
    };

    await ServerService.getData(
      userNotificationApi,
      inputData,
          (data) async {
        if (data.isEmpty) return;

        printInDebug('user notification fetched from server');

        final List<UserNotification> notificationData =
        data.map((json) => UserNotification.fromJson(json)).toList();


        // final List<Future<void>> dbTasks = [];

        if (notificationData.isNotEmpty) {
          await cacheData<UserNotification>(
            cacheKey: keyTableUserNotification,
            list: notificationData,
            toJson: (e) => e.toJson(),
          );
          // dbTasks.add(syncUserNotificationData(notificationData));
        }

        // 🔒 sequential execution (NO parallel writes)
        // for (final task in dbTasks) {
        //   await task;
        // }

        printInDebug('onLoadNotificationData finished');
      },
          (error) {
        printInDebug('Error fetching notifications: $error');
      },
    );
  }
  Future<void> onLoadAttendanceData() async {
    final Map<String, String> inputData = {};

    await getData(
      userAttendanceApi,
      inputData,
          (data) async {
        if (data.isEmpty) return;

        final List<UserAttendance> dataList =
        data.map((json) => UserAttendance.fromJson(json)).toList();

        // final List<Future<void>> dbTasks = [];

        if (dataList.isNotEmpty) {
          await cacheData<UserAttendance>(
            cacheKey: keyTableUserAttendance,
            list: dataList,
            toJson: (e) => e.toJson(),
          );
          // dbTasks.add(syncUserAttendanceData(dataList));
        }

        // safest execution
        // for (final task in dbTasks) {
        //   await task;
        // }
        debugPrint('onLoadAttendanceData finished');
      },
          (error) {
        debugPrint('Error fetching attendance: $error');
      },
    );
  }
  Future<void> onLoadProfileData() async {
    final Map<String, String> inputData = {};

    await getData(
      profileApi,
      inputData,
          (data) async {
        if (data.isEmpty) return;

        final List<UserProfile> userProfiles =
        data.map((json) => UserProfile.fromJson(json)).toList();

        // final List<Future<void>> dbTasks = [];

        if (userProfiles.isNotEmpty) {
          await cacheData<UserProfile>(
            cacheKey: keyTableUserProfile,
            list: userProfiles,
            toJson: (e) => e.toJson(),
          );
          // dbTasks.add(syncUserProfileData(userProfiles));
        }

        // 🔒 sequential DB write
        // for (final task in dbTasks) {
        //   await task;
        // }

        debugPrint('onLoadProfileData finished');
      },
          (error) {
        debugPrint('Error fetching profile: $error');
      },
    );
  }
  Future<void> onLoadUserPostingData() async {
    final Map<String, String> inputData = {};

    await getPostingData(
      userPostingApi,
      inputData,
          (data) async {
        if (data.isEmpty) return;

        // final List<Future<void>> dbTasks = [];

        // 🔹 User Posting
        if (data.containsKey('UserPosting')) {
          final userPostings = (data['UserPosting'] as List)
              .map((json) => UserPosting.fromJson(json))
              .toList();

          if (userPostings.isNotEmpty) {
            await cacheData<UserPosting>(
              cacheKey: keyTableUserPosting,
              list: userPostings,
              toJson: (e) => e.toJson(),
            );
            // dbTasks.add(syncUserPostingData(userPostings));
          }
        }

        // 🔹 Unit Duty Post
        if (data.containsKey('UnitDutyPost')) {
          final unitDutyPosts = (data['UnitDutyPost'] as List)
              .map((json) => UnitDutyPost.fromJson(json))
              .toList();
          if (unitDutyPosts.isNotEmpty) {
            await cacheData<UnitDutyPost>(
              cacheKey: keyTableUnitDutyPost,
              list: unitDutyPosts,
              toJson: (e) => e.toJson(),
            );
            // dbTasks.add(syncUnitDutyPostData(unitDutyPosts));
          }
        }

        // 🔹 Unit Shift Detail
        if (data.containsKey('UnitShiftDetail')) {
          final unitShiftDetailData = (data['UnitShiftDetail'] as List)
              .map((json) => UnitShiftDetail.fromJson(json))
              .toList();
        print('UnitShiftDetail......length...${unitShiftDetailData.length}');
          final filtered = unitShiftDetailData.where((d) => d.deleted == 0).toList();

          // final Set<String> shiftIds = {};
          // final userShiftDetailsData = filtered.where((data) {
          //   if (shiftIds.contains(data.shiftId)) return false;
          //   shiftIds.add(data.shiftId);
          //   return true;
          // }).toList();
          print('UnitShiftDetail......filtered...${filtered.length}');

          await syncUnitShiftDetailData(unitShiftDetailData);
        }

        // ✅ Execute DB writes (serialized internally if queued)
        // await Future.wait(dbTasks);

        debugPrint('onLoadUserPostingData finished');
      },
          (error) {
        debugPrint('Error fetching user posting data: $error');
      },
    );
  }
  Future<void> onLoadRoasterData() async {
    final Map<String, String> inputData = {};

    await getData(
      userRosterApi,
      inputData,
          (data) async {
        if (data.isEmpty) return;

        List<UserRoaster> roasters = data.map((json) => UserRoaster.fromJson(json)).toList();
        debugPrint('onLoadRoasterData finished');

        // final List<Future<void>> dbTasks = [];

        if (roasters.isNotEmpty) {
          debugPrint('roaster data not  empty');

          await cacheData<UserRoaster>(
            cacheKey: keyTableUserRoster,
            list: roasters,
            toJson: (e) => e.toJson(),
          );

          // dbTasks.add(syncUserRoasterData(roasters));
        }

        // 🔒 Sequential DB execution (no parallel writes)
        // for (final task in dbTasks) {
        //   await task;
        // }

        debugPrint('onLoadRoasterData finished');
      },
          (error) {
        debugPrint('Error fetching roaster: $error');
      },
    );
  }

  static Future<void> getData(String apiName,
      Map<String, String> queryParams,
      Function(List<dynamic>) completion,
      Function(Map<String, dynamic>) error,) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(keyUserToken) ?? '';

    List<dynamic> responseData = [];
    Map<String, dynamic> responseError = {};

    var apiUrl = Uri.https(baseUrl, apiName);
    var url = queryParams.isNotEmpty
        ? Uri.parse('$apiUrl').replace(queryParameters: queryParams)
        : apiUrl;

    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('request url=$url headers=$headers');

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        final Map<String, dynamic> jsonResponse =
        jsonDecode(response.body) as Map<String, dynamic>;

        if (jsonResponse.containsKey('data')) {
          responseData = jsonResponse['data'];
        } else {
          responseData = [jsonResponse];
        }
        await completion(responseData);
      } else {
        print('Request failed with status: ${response.statusCode}');
        responseError = {'ErrorMessage': 'Unexpected error'};
        error(responseError);
      }
    } catch (e) {
      print('Error: $e');
      responseError = {'ErrorMessage': 'Unexpected error'};
      error(responseError);
    }
  }


  Future<void> getPostingData(String apiName,
      Map<String, String> queryParams,
      Function(Map<String, dynamic>) completion,
      Function(Map<String, dynamic>) error,) async {
    Map<String, dynamic> responseData = {};
    Map<String, dynamic> responseError = {};

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(keyUserToken) ?? '';

    var apiIURL = Uri.https(baseUrl, apiName);
    var url = queryParams.isNotEmpty
        ? Uri.parse('$apiIURL').replace(queryParameters: queryParams)
        : apiIURL;

    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token', // use fetched token
    };

    try {
      final response = await http.get(url, headers: headers);
      debugPrint('Request url=$url headers=$headers');

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        final Map<String, dynamic> jsonResponse =
        jsonDecode(response.body) as Map<String, dynamic>;

        if (jsonResponse.containsKey('data')) {
          responseData = jsonResponse['data'];
          completion(responseData);
        } else {
          // fallback if no "data" key
          completion(jsonResponse);
        }
      } else if (response.statusCode == 401 && apiName != tokenApi) {
        final Map<String, dynamic> jsonResponse =
        jsonDecode(response.body) as Map<String, dynamic>;

        responseError = jsonResponse.containsKey('data')
            ? jsonResponse['data'] as Map<String, dynamic>
            : {'ErrorMessage': 'Unexpected error'};

        error(responseError);
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Error body: ${response.body}');

        final Map<String, dynamic> jsonResponse =
        jsonDecode(response.body) as Map<String, dynamic>;

        responseError = jsonResponse.containsKey('data')
            ? jsonResponse['data'] as Map<String, dynamic>
            : {'ErrorMessage': 'Unexpected error'};

        error(responseError);
      }
    } catch (e) {
      print('Error: $e');
      responseError = {'ErrorMessage': 'Unexpected error'};
      error(responseError);
    }
  }


  Future<void> replaceTableData<T>(String tableName,
      List<T> newData,
      Map<String, dynamic> Function(T) toMap,) async {
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

    printInDebug('Background Sync completed for $tableName');
    // await db.close();

  }

  Future<void> updateOrDeleteTableData<T>(String tableName,
      List<T> items,
      String idField,
      Map<String, dynamic> Function(T) toMap,) async {
    final db = await DatabaseHelper.instance.database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final item in items) {
        final row = toMap(item);
        debugPrint('Saving row: $row');

        final id = row[idField];

        // Query must be awaited (batch doesn't support conditional logic)
        final existingRecords = await txn.query(
          tableName,
          where: '$idField = ?',
          whereArgs: [id],
          limit: 1,
        );

        if (row['deleted'] == 1) {
          if (existingRecords.isNotEmpty) {
            batch.delete(
              tableName,
              where: '$idField = ?',
              whereArgs: [id],
            );
          } else {
            printInDebug(
                'Record with ID $id marked as deleted but does not exist.');
          }
        } else {
          if (existingRecords.isNotEmpty) {
            batch.update(
              tableName,
              row,
              where: '$idField = ?',
              whereArgs: [id],
            );
          } else {
            batch.insert(
              tableName,
              row,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        }
      }

      // Commit batch in ONE native call
      await batch.commit(noResult: true);
    });
    printInDebug('Background Sync completed for $tableName');
    // await  db.close();

  }

  Future<void> updateTableData<T>(String tableName,
      List<T> items,
      String idField,
      Map<String, dynamic> Function(T) toMap,) async {
    final db = await DatabaseHelper.instance.database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final item in items) {
        final row = toMap(item);
        final id = row[idField];

        batch.update(
          tableName,
          row,
          where: '$idField = ?',
          whereArgs: [id],
        );
      }

      // Execute all updates at once
      await batch.commit(noResult: true);
    });
    printInDebug('Background Sync completed for $tableName');

    // await db.close();

  }


  Future<void>saveServerData_old()async{
    debugPrint('[SYNC] Started');

    try {
      await syncCachedData<UserNotification>(
        cacheKey: keyTableUserNotification,
        fromJson: (json) => UserNotification.fromJson(json),
        onSyncToDb: (list) async => await syncUserNotificationData(list),
      );
      await syncCachedData<UserAttendance>(
        cacheKey: keyTableUserAttendance,
        fromJson: (json) => UserAttendance.fromJson(json),
        onSyncToDb: (list) async => await syncUserAttendanceData(list),
      );
      await syncCachedData<UserProfile>(
        cacheKey: keyTableUserProfile,
        fromJson: (json) => UserProfile.fromJson(json),
        onSyncToDb: (list) async => await syncUserProfileData(list),
      );

      await syncCachedData<UserPosting>(
        cacheKey: keyTableUserPosting,
        fromJson: (json) => UserPosting.fromJson(json),
        onSyncToDb: (list) async => await syncUserPostingData(list),
      );
      await syncCachedData<UnitDutyPost>(
        cacheKey: keyTableUnitDutyPost,
        fromJson: (json) => UnitDutyPost.fromJson(json),
        onSyncToDb: (list) async => await syncUnitDutyPostData(list),
      );
      await syncCachedData<UnitShiftDetail>(
        cacheKey: keyTableUnitShiftDetail,
        fromJson: (json) => UnitShiftDetail.fromJson(json),
        onSyncToDb: (list) async => await syncUnitShiftDetailData(list),
      );
      await syncCachedData<UserRoaster>(
        cacheKey: keyTableUserRoster,
        fromJson: (json) => UserRoaster.fromJson(json),
        onSyncToDb: (list) async => await syncUserRoasterData(list),
      );

    debugPrint('[SYNC] Completed');
    _syncController.add(true);

    } catch (e, st) {
      debugPrint('[SYNC] Failed: $e\n$st');
      _syncController.add(false);
    }

  }
  Future<void> saveServerData() async {
    debugPrint('[SYNC] Started');

    bool anyTableUpdated = false;

    try {
      anyTableUpdated |= await syncCachedData<UserNotification>(
        cacheKey: keyTableUserNotification,
        fromJson: UserNotification.fromJson,
        onSyncToDb: syncUserNotificationData,
      );

      anyTableUpdated |= await syncCachedData<UserAttendance>(
        cacheKey: keyTableUserAttendance,
        fromJson: UserAttendance.fromJson,
        onSyncToDb: syncUserAttendanceData,
      );

      anyTableUpdated |= await syncCachedData<UserProfile>(
        cacheKey: keyTableUserProfile,
        fromJson: UserProfile.fromJson,
        onSyncToDb: syncUserProfileData,
      );

      anyTableUpdated |= await syncCachedData<UserPosting>(
        cacheKey: keyTableUserPosting,
        fromJson: UserPosting.fromJson,
        onSyncToDb: syncUserPostingData,
      );

      anyTableUpdated |= await syncCachedData<UnitDutyPost>(
        cacheKey: keyTableUnitDutyPost,
        fromJson: UnitDutyPost.fromJson,
        onSyncToDb: syncUnitDutyPostData,
      );

      anyTableUpdated |= await syncCachedData<UnitShiftDetail>(
        cacheKey: keyTableUnitShiftDetail,
        fromJson: UnitShiftDetail.fromJson,
        onSyncToDb: syncUnitShiftDetailData,
      );

      anyTableUpdated |= await syncCachedData<UserRoaster>(
        cacheKey: keyTableUserRoster,
        fromJson: UserRoaster.fromJson,
        onSyncToDb: syncUserRoasterData,
      );

      debugPrint('[SYNC] Completed. Updated=$anyTableUpdated');

      if (anyTableUpdated) {
        _syncController.add(true); // refresh UI
      }

    } catch (e, st) {
      debugPrint('[SYNC] Failed: $e\n$st');
      _syncController.add(false);
    }
  }

  Future<void> syncUserNotificationData(List<UserNotification> userNotification) async {
    await DbWriteQueue.instance.run(() async {
      await updateTableData<UserNotification>(
        keyTableUserNotification,
        userNotification,
        'id',
            (data) => data.toMap(),

      );
    });
  }
  Future<void> syncUserAttendanceData(List<UserAttendance> userAttendance) async {
    await DbWriteQueue.instance.run(() async {
      await updateOrDeleteTableData<UserAttendance>(
          keyTableUserAttendance,
          userAttendance,
          'id',
              (userAttendance) => userAttendance.toMap()
      );
    });
  }
  Future<void> syncUserProfileData(List<UserProfile> userProfile) async {
    await DbWriteQueue.instance.run(() async {
      await replaceTableData<UserProfile>(
        keyTableUserProfile,
        userProfile,
            (p) => p.toMap(),
      );
    });
  }
  Future<void> syncUnitShiftDetailData(List<UnitShiftDetail> userShiftDetailsData) async {
    await DbWriteQueue.instance.run(() async {
      await replaceTableData<UnitShiftDetail>(
        keyTableUnitShiftDetail,
        userShiftDetailsData,
            (s) => s.toMap(),
      );
    });
  }
  Future<void> syncUnitDutyPostData(List<UnitDutyPost> unitDutyPosts) async {
    await DbWriteQueue.instance.run(() async {
      await replaceTableData<UnitDutyPost>(
        keyTableUnitDutyPost,
        unitDutyPosts,
            (u) => u.toMap(),
      );
    });
  }
  Future<void> syncUserPostingData(List<UserPosting> userPostings) async {
    await DbWriteQueue.instance.run(() async {
      await replaceTableData<UserPosting>(
        keyTableUserPosting,
        userPostings,
            (u) => u.toMap(),
      );
    });
  }
  Future<void> syncUserRoasterData(List<UserRoaster> userRoaster) async {
    await DbWriteQueue.instance.run(() async {
      await updateOrDeleteTableData<UserRoaster>(
          keyTableUserRoster,
          userRoaster,
          'id',
              (userRoaster) => userRoaster.toMap()
      );

    });
  }

  Future<void> cacheData<T>({
    required String cacheKey,
    required List<T> list,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    debugPrint('cache data called');

    try {
      if (list.isEmpty) {
        debugPrint('[CACHE][$cacheKey] No data to cache');
        return;
      }

      debugPrint('list not empty');

      final dir = await getApplicationSupportDirectory();
      final file = File('${dir.path}/${cacheKey}_cache.json');

      final jsonList = list.map(toJson).toList();
      await file.writeAsString(jsonEncode(jsonList));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('${cacheKey}_pending_sync', true);

      debugPrint(
        '[CACHE][$cacheKey] Cached ${list.length} records at ${file.path}',
      );
    } catch (e, stackTrace) {
      debugPrint('[CACHE][$cacheKey] Cache FAILED');
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }


  Future<void> syncCachedData_old<T>({
    required String cacheKey,
    required Future<void> Function(List<T>) onSyncToDb,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final hasPending = prefs.getBool('${cacheKey}_pending_sync') ?? false;

    if (!hasPending) return;

    printInDebug(' syncing $cacheKey');
    final dataList = await loadCachedData<T>(
      cacheKey: cacheKey,
      fromJson: fromJson,
    );

    if (dataList.isNotEmpty) {
      printInDebug('[SYNC][$cacheKey] Records to sync: ${dataList.length}');
      try {
        await onSyncToDb(dataList);
        printInDebug('[SYNC][$cacheKey] DB sync finished');
      } catch (e, st) {
        printInDebug('[SYNC][$cacheKey] DB sync FAILED: $e');
        debugPrintStack(stackTrace: st);
        return; // ⛔ do NOT cleanup on failure
      }
    }


    // Cleanup
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/${cacheKey}_cache.json');
    if (file.existsSync()) await file.delete();

    await prefs.setBool('${cacheKey}_pending_sync', false);
  }

  Future<bool> syncCachedData<T>({
    required String cacheKey,
    required T Function(Map<String, dynamic>) fromJson,
    required Future<void> Function(List<T>) onSyncToDb,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final hasPending = prefs.getBool('${cacheKey}_pending_sync') ?? false;
    if (!hasPending) {
      printInDebug('[SYNC][$cacheKey] No pending sync');
      return false;
    }

    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/${cacheKey}_cache.json');

    if (!await file.exists()) {
      printInDebug('[SYNC][$cacheKey] Cache file missing');
      return false;
    }

    final raw = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(raw);

    if (jsonList.isEmpty) {
      printInDebug('[SYNC][$cacheKey] Cache empty');
      return false;
    }

    final dataList = jsonList.map((e) => fromJson(e)).toList();

    /// 🔐 DB sync guarded
    try {
      await onSyncToDb(dataList);
      printInDebug('[SYNC][$cacheKey] DB sync finished');
    } catch (e, st) {
      printInDebug('[SYNC][$cacheKey] DB sync FAILED: $e');
      debugPrintStack(stackTrace: st);
      return false; // ⛔ do NOT cleanup on failure
    }

    /// ✅ Cleanup only on success
    await prefs.setBool('${cacheKey}_pending_sync', false);

    printInDebug(
      '[SYNC][$cacheKey] Synced ${dataList.length} records successfully',
    );

    return true;
  }

  Future<List<T>> loadCachedData<T>({
    required String cacheKey,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/${cacheKey}_cache.json');

    if (!file.existsSync()) return [];

    final List<dynamic> data =
    jsonDecode(await file.readAsString());

    return data
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
  }

}
class DbWriteQueue {
  static final DbWriteQueue _instance = DbWriteQueue._();
  DbWriteQueue._();

  static DbWriteQueue get instance => _instance;

  Future<void> _last = Future.value();

  Future<void> run(Future<void> Function() action) {
    _last = _last.then((_) async {
      await action();
    });
    return _last;
  }
}
