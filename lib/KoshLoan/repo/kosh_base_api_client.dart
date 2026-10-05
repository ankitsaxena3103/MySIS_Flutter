// kosh_base_api_client.dart
//
// Flutter/Dart port of the Java `KoshBaseApiClient` (Android Volley) class.
// Uses: http  (network calls)   ->  pubspec.yaml: http: ^1.2.0
//       shared_preferences (token storage) -> pubspec.yaml: shared_preferences: ^2.2.0
//
// The public method signatures mirror the original Java class as closely as
// possible (same names, same callback style) so the port is easy to trace
// against the source file.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/SharedClasses/Preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Constants (mirrors Constants.KOSH_BASE_URL / Constants.KOSH_ENV)
// ---------------------------------------------------------------------------
class KoshConstants {
  static const String koshBaseUrl = "https://kosh.bkosh.com";

  static const String koshEnv = 'uat'; // e.g. "prod" / "staging"
// static final String KOSH_USERNAME = "sis_india";
// static final String KOSH_PASSWORD = "sis_india@kosh";
}

// ---------------------------------------------------------------------------
// Callback typedefs (mirrors ApiCallback / ApiJsonArrayCallback interfaces)
// ---------------------------------------------------------------------------
typedef ApiSuccessCallback = void Function(Map<String, dynamic> response);
typedef ApiArraySuccessCallback = void Function(List<dynamic> response);
typedef ApiErrorCallback = void Function(String errorMessage, int statusCode);

// ---------------------------------------------------------------------------
// Simple token storage (mirrors CSShearedPrefence.setKoshToken/getKoshToken)
// ---------------------------------------------------------------------------
class CSSharedPreference {
  static const _koshTokenKey = 'kosh_token';

  static Future<void> setKoshToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token == null) {
      await prefs.remove(_koshTokenKey);
    } else {
      await prefs.setString(_koshTokenKey, token);
    }
  }

  static Future<String?> getKoshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_koshTokenKey);
  }
}

// ---------------------------------------------------------------------------
// Main API client
// ---------------------------------------------------------------------------
class KoshBaseApiClient {
  final http.Client _client;

  String? accessToken;
  String? refreshToken;

  KoshBaseApiClient({http.Client? client}) : _client = client ?? http.Client();

  // ---------- 1. Login (Authentication) ----------
  Future<void> createToken(
    String username,
    String password, {
    required ApiSuccessCallback onSuccess,
    required ApiErrorCallback onError,
  }) async {
    final url = Uri.parse(
        '${KoshConstants.koshBaseUrl}/auth/${KoshConstants.koshEnv}/remote-auth/password-view/');

    final body = jsonEncode({'username': username, 'password': password});

    try {
      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final decoded = _decodeOrError(response, onError);
      if (decoded == null) return;

      accessToken = decoded['access'] as String?;
      refreshToken = decoded['refresh'] as String?;
      // await CSSharedPreference.setKoshToken(accessToken);
      Preferences.saveUserPreference(KOSH_TOKEN, accessToken ?? '');
      onSuccess(decoded);
    } catch (e) {
      onError('Failed to build/send request: $e', -1);
    }
  }

  // ---------- Refresh access token ----------
  Future<void> refreshAccessToken({
    required ApiSuccessCallback onSuccess,
    required ApiErrorCallback onError,
  }) async {
    if (refreshToken == null) {
      onError('No refresh token available. Call login() first.', -1);
      return;
    }

    final url = Uri.parse(
        '${KoshConstants.koshBaseUrl}/auth/${KoshConstants.koshEnv}/remote-auth/refresh-token/');

    try {
      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      final decoded = _decodeOrError(response, onError);
      if (decoded == null) return;

      accessToken = decoded['access'] as String?;
      onSuccess(decoded);
    } catch (e) {
      onError('Failed to build/send request: $e', -1);
    }
  }

  // ---------- 2. Create a CRM record ----------
  Future<void> createRecord(
    String pipelineKey,
    String username,
    String? alternateUsername, {
    required ApiSuccessCallback onSuccess,
    required ApiErrorCallback onError,
  }) async {
    final url = Uri.parse(
        '${KoshConstants.koshBaseUrl}/los/${KoshConstants.koshEnv}/crm/records-by-user/create-by-username/');

    final Map<String, dynamic> bodyMap = {
      'pipeline_key': pipelineKey,
      'username': username,
      'creator_is_owner': true,
    };
    if (alternateUsername != null) {
      bodyMap['alternate_username'] = alternateUsername;
    }

    await _postWithAuth(url, bodyMap, onSuccess, onError);
  }

  Future<void> createReferralRecord(
    String pipelineKey,
    String referralMobile,
    String username, {
    required ApiSuccessCallback onSuccess,
    required ApiErrorCallback onError,
  }) async {
    final url = Uri.parse(
        '${KoshConstants.koshBaseUrl}/los/${KoshConstants.koshEnv}/crm/records-by-user/create-by-username/');

    final bodyMap = {
      'pipeline_key': pipelineKey,
      'username': referralMobile,
      'referred_by': username,
      'creator_is_owner': false,
    };

    await _postWithAuth(url, bodyMap, onSuccess, onError);
  }

  // ---------- Fetch lead(s) / converted lead(s) ----------
  Future<void> fetchLeadNDConvertedLead(
    String? afterStage,
    String userId, {
    required ApiArraySuccessCallback onSuccess,
    required ApiErrorCallback onError,
  }) async {
    var url = Uri.parse(
        '${KoshConstants.koshBaseUrl}/los/${KoshConstants.koshEnv}/crm/records/gl-borrower-records/');

    final queryParams = <String, String>{'gl_user_id': userId};
    if (afterStage != null) {
      queryParams['after_stage'] = 'loan_approved';
    }
    url = url.replace(queryParameters: queryParams);

    try {
      final headers = await _authHeaders();
      final response = await _client.get(url, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as List<dynamic>;
        onSuccess(decoded);
      } else {
        onError(response.body, response.statusCode);
      }
    } catch (e) {
      onError('Request failed: $e', -1);
    }
  }

  Future<void> fetchWallet(
    String userId, {
    required ApiSuccessCallback onSuccess,
    required ApiErrorCallback onError,
  }) async {
    var url = Uri.parse(
        '${KoshConstants.koshBaseUrl}/lms/${KoshConstants.koshEnv}/wallet/dashboard/summary/');
    url = url.replace(queryParameters: {'user_id': userId});

    await _getWithAuth(url, onSuccess, onError);
  }

  /// Generic GET-by-URL fetch (mirrors fetchConvertedLead / fetchConvertedLead_v2).
  /// Both Java variants were identical, so they're merged into one method with
  /// a 60s timeout and a single retry, matching the original DefaultRetryPolicy.
  Future<void> fetchConvertedLead(
    String url, {
    required ApiSuccessCallback onSuccess,
    required ApiErrorCallback onError,
  }) async {
    final uri = Uri.parse(url);
    const timeout = Duration(seconds: 60);
    const maxAttempts = 2; // initial attempt + 1 retry

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final headers = await _authHeaders();
        final response =
            await _client.get(uri, headers: headers).timeout(timeout);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          onSuccess(jsonDecode(response.body) as Map<String, dynamic>);
        } else {
          onError(response.body, response.statusCode);
        }
        return;
      } catch (e) {
        if (attempt == maxAttempts) {
          onError('Request failed after $attempt attempt(s): $e', -1);
        }
      }
    }
  }

  // Kept for parity with the Java "_v2" method name (same behavior).
  Future<void> fetchConvertedLeadV2(
    String url, {
    required ApiSuccessCallback onSuccess,
    required ApiErrorCallback onError,
  }) =>
      fetchConvertedLead(url, onSuccess: onSuccess, onError: onError);

  Future<void> findPersonByUser(
    String username, {
    required ApiSuccessCallback onSuccess,
    required ApiErrorCallback onError,
  }) async {
    final url = Uri.parse(
        '${KoshConstants.koshBaseUrl}/auth/${KoshConstants.koshEnv}/remote-auth/user/user-ids-by-usernames/');

    final bodyMap = {
      'usernames': [username],
    };

    await _postWithAuth(url, bodyMap, onSuccess, onError);
  }

  Future<void> fetchUserMobileNoBaseOnUserID(
    Map<String, dynamic> body, {
    required ApiSuccessCallback onSuccess,
    required ApiErrorCallback onError,
  }) async {
    final url = Uri.parse(
        '${KoshConstants.koshBaseUrl}/auth/${KoshConstants.koshEnv}/remote-auth/user/usernames-by-user-ids/');

    await _postWithAuth(url, body, onSuccess, onError);
  }

  // ---------- 3. View a CRM record ----------
  Future<void> viewRecord(
    String pipelineKey,
    String username, {
    required ApiSuccessCallback onSuccess,
    required ApiErrorCallback onError,
  }) async {
    final url = Uri.parse(
            '${KoshConstants.koshBaseUrl}/los/${KoshConstants.koshEnv}/crm/records-by-user/by-username/')
        .replace(queryParameters: {
      'pipeline_key': pipelineKey,
      'username': username,
    });

    await _getWithAuth(url, onSuccess, onError);
  }

  // ---------- Helpers ----------
  Future<Map<String, String>> _authHeaders() async {
    final token = await Preferences.getUserPreference(KOSH_TOKEN);
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<void> _postWithAuth(
    Uri url,
    Map<String, dynamic> bodyMap,
    ApiSuccessCallback onSuccess,
    ApiErrorCallback onError,
  ) async {
    try {
      final headers = await _authHeaders();
      final response = await _client.post(
        url,
        headers: headers,
        body: jsonEncode(bodyMap),
      );
      final decoded = _decodeOrError(response, onError);
      if (decoded != null) onSuccess(decoded);
    } catch (e) {
      onError('Request failed: $e', -1);
    }
  }

  Future<void> _getWithAuth(
    Uri url,
    ApiSuccessCallback onSuccess,
    ApiErrorCallback onError,
  ) async {
    try {
      final headers = await _authHeaders();
      final response = await _client.get(url, headers: headers);
      final decoded = _decodeOrError(response, onError);
      if (decoded != null) onSuccess(decoded);
    } catch (e) {
      onError('Request failed: $e', -1);
    }
  }

  /// Decodes a successful JSON response, or forwards the error to [onError].
  /// Returns null when an error was reported (mirrors Java's handleError).
  Map<String, dynamic>? _decodeOrError(
      http.Response response, ApiErrorCallback onError) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return <String, dynamic>{};
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      onError(response.body, response.statusCode);
      return null;
    }
  }

  void dispose() => _client.close();
}
