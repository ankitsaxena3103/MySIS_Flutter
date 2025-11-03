import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> loadServerData() async {

    debugPrint('background service called');

    try {
      await onLoadNotificationData();
      debugPrint('onLoadNotificationData finished');
    } catch (e, st) {
      debugPrint('Error in onLoadNotificationData: $e\n$st');
    }

    try {
      await onLoadAttendanceData();
      debugPrint('onLoadAttendanceData finished');
    } catch (e, st) {
      debugPrint('Error in onLoadAttendanceData: $e\n$st');
    }

    try {
      await onLoadProfileData();
      debugPrint('onLoadProfileData finished');
    } catch (e, st) {
      debugPrint('Error in onLoadProfileData: $e\n$st');
    }

    try {
      await onLoadUserPostingData();
      debugPrint('onLoadUserPostingData finished');
    } catch (e, st) {
      debugPrint('Error in onLoadUserPostingData: $e\n$st');
    }
    try {
      await onLoadRoasterData();
      debugPrint('onLoadRoasterData finished');
    } catch (e, st) {
      debugPrint('Error in onLoadRoasterData: $e\n$st');
    }

  }


  Future<void> onLoadNotificationData() async {
    Map deviceDetails = await getDeviceDetail();
    final appInfo = await getPackageInfo();
    Map<String, String> inputData = {
      "run": "sync",
      'app Version': '${appInfo.version}(${appInfo.buildNumber})',
      'plateform version ':deviceDetails[keyPlateformVersion],
      'Model': deviceDetails[keyDeviceModel],

    };

    await ServerService.getData(
      userNotificationApi,
      inputData,
          (data) async {
        if (data.isNotEmpty) {
          printInDebug('user notification fetched from server');

          // Parse JSON to model
          List<UserNotification> notificationData = data
              .map((json) => UserNotification.fromJson(json))
              .toList();

          // Sync to local DB or storage
          await syncUserNotificationData(notificationData);

          print('onLoadNotificationData finished');
        }
      },
          (error) {
        print('Error fetching notifications: $error');
      },
    );
  }
   Future<void> onLoadAttendanceData() async {
    Map<String, String> inputData = {};

    await getData(userAttendanceApi, inputData, (data) async {
      if (data.isNotEmpty) {
        List<UserAttendance> dataList =
        data.map((json) => UserAttendance.fromJson(json)).toList();
        for (var data in dataList) {
          print('Attendance ID: ${data.id}, site: ${data.siteName}');
        }
        if (dataList.isNotEmpty) await syncUserAttendanceData(dataList);
        print('onLoadAttendanceData finished');
      }
    }, (error) {
      print('Error fetching attendance: $error');
    });
  }

   Future<void> onLoadProfileData() async {
    Map<String, String> inputData = {};

    await getData(profileApi, inputData, (data) async {
      if (data.isNotEmpty) {
        List<UserProfile> userProfiles =
        data.map((json) => UserProfile.fromJson(json)).toList();
        for (var profile in userProfiles) {
          print(
              'Profile ID: ${profile.id}, name: ${profile.empName}, manager: ${profile.managerMobile}');
        }
        if (userProfiles.isNotEmpty) await syncUserProfileData(userProfiles);
        print('onLoadProfileData finished');
      }
    }, (error) {
      print('Error fetching profile: $error');
    });
  }

   Future<void> onLoadUserPostingData() async {
    Map<String, String> inputData = {};

    await getUserData(userPostingApi, inputData, (data) async {
      if (data.isNotEmpty) {
        if (data.containsKey('UserPosting')) {
          final userPostings = (data['UserPosting'] as List)
              .map((json) => UserPosting.fromJson(json))
              .toList();
          await syncUserPostingData(userPostings);
        }
        if (data.containsKey('UnitDutyPost')) {
          final unitDutyPosts = (data['UnitDutyPost'] as List)
              .map((json) => UnitDutyPost.fromJson(json))
              .toList();
          await syncUnitDutyPostData(unitDutyPosts);
        }
        if (data.containsKey('UnitShiftDetail')) {
          final unitShiftDetailData = (data['UnitShiftDetail'] as List)
              .map((json) => UnitShiftDetail.fromJson(json))
              .toList();
          final filtered = unitShiftDetailData.where((d) => d.deleted == 0).toList();

          final Set<String> shiftIds = {};
          final userShiftDetailsData = filtered.where((data) {
            if (shiftIds.contains(data.shiftId)) return false;
            shiftIds.add(data.shiftId);
            return true;
          }).toList();

          await syncUnitShiftDetailData(userShiftDetailsData);
        }
        print('onLoadUserPostingData finished');
      }
    }, (error) {
      print('Error fetching user posting data: $error');
    });
  }

   Future<void> onLoadRoasterData() async {
    Map<String, String> inputData = {};

    await getData(userRosterApi, inputData, (data) async {
      if (data.isNotEmpty) {
        final roasters =
        data.map((json) => UserRoaster.fromJson(json)).toList();
        await syncUserRoasterData(roasters);
        print('onLoadRoasterData finished');
      }
    }, (error) {
      print('Error fetching roaster: $error');
    });
  }

   Future<void> syncUserNotificationData(List<UserNotification> userNotification) async {

    // Update multiple rows using a generic update function
    await DatabaseHelper.instance.updateTableData<UserNotification>(
      keyTableUserNotification,
      userNotification,
      'id',
          (data) => data.toMap(),

    );

  }
   Future<void> syncUserAttendanceData(   List <UserAttendance> userAttendance) async {
    await DatabaseHelper.instance.updateOrDeleteTableData<UserAttendance>(
        keyTableUserAttendance,
        userAttendance,
        'id',
            (userAttendance) => userAttendance.toMap()
    );



  }
   Future<void> syncUserProfileData(   List <UserProfile> userProfile) async {
    await DatabaseHelper.instance.replaceTableData<UserProfile>(keyTableUserProfile, userProfile, (userProfile) =>
        userProfile.toMap());

  }
   Future<void> syncUnitShiftDetailData( List<UnitShiftDetail> userShiftDetailsData) async {
    await DatabaseHelper.instance.replaceTableData<UnitShiftDetail>(keyTableUnitShiftDetail, userShiftDetailsData, (unitShiftDetail) =>
        unitShiftDetail.toMap());

  }
   Future<void> syncUnitDutyPostData( List<UnitDutyPost> unitDutyPosts) async {
    await DatabaseHelper.instance.replaceTableData<UnitDutyPost>(keyTableUnitDutyPost, unitDutyPosts, (unitDutyPosts) =>
        unitDutyPosts.toMap());

  }
   Future<void> syncUserPostingData(List<UserPosting> userPostings) async {
    await DatabaseHelper.instance.replaceTableData<UserPosting>(
        keyTableUserPosting,
        userPostings,
            (userPosting) => userPosting.toMap());

  }
   Future<void> syncUserRoasterData(List <UserRoaster> userRoaster) async {

    await DatabaseHelper.instance.updateOrDeleteTableData<UserRoaster>(
        keyTableUserRoster,
        userRoaster,
        'id',
            (userRoaster) => userRoaster.toMap()
    );

  }

  static Future<void> getData(
      String apiName,
      Map<String, String> queryParams,
      Function(List<dynamic>) completion,
      Function(Map<String, dynamic>) error,
      ) async {
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
        completion(responseData);
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

  Future<void> getUserData(
      String apiName,
      Map<String, String> queryParams,
      Function(Map<String, dynamic>) completion,
      Function(Map<String, dynamic>) error,
      ) async {
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

        // bool isForceLogout = (responseError['ForceLogout'] ?? 0) == 1;

        // if (isForceLogout) {
        //   Preferences.saveUserPreferenceBool(keyIsForcedLogOut, true);
        // } else {
        //   recallGetToken();
        // }

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



  Future<PackageInfo> getPackageInfo() async {
    // Fetch actual package info if available
    PackageInfo info = await PackageInfo.fromPlatform();

    // Override package name for iOS
    return PackageInfo(
      appName: info.appName.isNotEmpty ? info.appName : 'MySIS',
      packageName: Platform.isIOS ? 'com.sisindia.mysis.guard' : 'com.sisindia.mysis',
      version: info.version.isNotEmpty ? info.version : '1',
      buildNumber: info.buildNumber.isNotEmpty ? info.buildNumber : '1',
      buildSignature: info.buildSignature.isNotEmpty ? info.buildSignature : 'Unknown',
      installerStore: info.installerStore ?? 'Unknown',
    );
  }

  Future<Map<String,String>> getDeviceDetail() async {
    Map<String,String> deviceDetail = {};
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceDetail[keyDeviceModel] = androidInfo.model ;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      deviceDetail[keyPlateformVersion] = 'Android $release (SDK $sdkInt), $manufacturer' ;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceDetail[keyDeviceModel] = iosInfo.model;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      deviceDetail[keyPlateformVersion] ='$systemName $version, $name';
    }
    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      deviceDetail[keyDeviceModel] = webBrowserInfo.userAgent ?? "";
      deviceDetail[keyPlateformVersion] =webBrowserInfo.appVersion ?? "";
    }

    return deviceDetail;
  }

}


