

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mysis/SharedClasses/Preferences.dart';
import 'package:mysis/PreAuthViews/SelectLanguageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/languages.dart';
import 'package:mysis/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:mysis/UserAuthViews/EnterPINView.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        // Add other providers if needed
      ],
      child: EasyLocalization(
        supportedLocales: Languages.supportedLocales,
        path: 'assets/translations',
        fallbackLocale: Languages.defaultLocale,
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: MyHomePage()
    );
  }
}


class MyHomePage extends StatelessWidget {

  @override
Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: FutureBuilder<bool?>(
          future: futureBuilderData(),
          builder: (context, snapshot) {
            final isLoggedIn = snapshot.data ?? false;
            if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }
           else if(snapshot.connectionState == ConnectionState.done){
             if (snapshot.hasError) {
              // Error occurred while retrieving data, handle the error
              return Text('Error: ${snapshot.error}');
            }
            else if (isLoggedIn) {
              return EnterPINView();
            }
            else {
              return const SelectLanguageView(isFirstScreen: true);
            }
            }
            else {
              return const SelectLanguageView(isFirstScreen: true);
            }
          },
        ),
      ),
    );
  }


}
Future<void> initPackageInfo() async {
  final info = await PackageInfo.fromPlatform();
  packageInfo = info;
}

Future<bool> futureBuilderData() async {

  bool isLoggedIn = true;
  initPackageInfo();
  token = await Preferences.getUserPreference(keyUserToken) ?? '';
  userName = await Preferences.getUserPreference(keyUserName) ?? '';
  String userIdString = await Preferences.getUserPreference(keyUserID) ?? '0';
  userId = int.tryParse(userIdString) ?? 0;

  if (token.isNotEmpty && userName.isNotEmpty && userId != null) {
    isLoggedIn = true;
  }


  return isLoggedIn;

}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}



