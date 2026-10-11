/*
 * Created by Ankit Saxena on 11-10-2026.
 */


class CredentialModel {
  final String userName;
  final String deviceToken;
  final String password;
  final String pin;

  CredentialModel({
    required this.userName,
    required this.deviceToken,
    required this.password,
    required this.pin,
  });

  Map<String, dynamic> toJson() {
    return {
      // 'UserName': userName,
      // 'DeviceToken': deviceToken,
      // 'Password': password,
      // 'MPIN': pin,
      'UserName': "PAT069548",
      'DeviceToken': deviceToken,
      'Password': "0000",
      'MPIN': "1234",
      'AuthType': 'DEVICE',
      'AppType': 'GUARD',
      'VERSION': "2.3.6",
      'CompanyCode':"",
      'AUTH_TOKEN': "",
      'VERSION_CODE': "169"
    };
  }
}