import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mysis/SharedClasses/LanguageProvider.dart';
import 'package:mysis/SharedClasses/Preferences.dart';
import 'package:mysis/Language/SelectLanguageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/SharedClasses/languages.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:mysis/UserAuthViews/EnterPINView.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'HomeView/route_observer.dart';
import 'SharedClasses/ServerServices.dart';
import 'UserAuthViews/PINLockScreen.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

    await ServerService.instance.loadServerData();

    return Future.value(true);
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  printInDebug('Handling background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  // Initialize Workmanager safely
  await _initializeWorkmanager();
  await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('PIN....OFUSER...${await Preferences.getUserPreference(keyPIN)}');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
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

Future<void> _initializeWorkmanager() async {
  try {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
    printInDebug('Workmanager initialized successfully');
  } catch (e) {
    printInDebug('Error initializing Workmanager: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _isPinScreenOpen = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Future.delayed(Duration(seconds: 10), () {
      _isPinScreenOpen = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // if (state == AppLifecycleState.inactive && !_isPinScreenOpen) {
    //   // Future.delayed(Duration(milliseconds: 100), _showPinScreen);
    // }

    if (state == AppLifecycleState.resumed) {
      Future.delayed(Duration(milliseconds: 200), () async {
        await ServerService.instance.saveServerData();
      });
    }
  }

  Future<void> _showPinScreen() async {
    if (_isPinScreenOpen) return;

    final currentPin = await Preferences.getUserPreference(keyPIN) ?? '';
    if (currentPin.isEmpty) return;

    _isPinScreenOpen = true;

    // ✅ Use the global navigator key instead of context
    navigatorKey.currentState
        ?.push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => PINLockScreen(currentPIN: currentPin),
      ),
    )
        .then((_) {
      Future.delayed(Duration(seconds: 5), () {
        _isPinScreenOpen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      // assign the key here
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      navigatorObservers: [routeObserver],
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<bool?>(
          future: futureBuilderData(),
          builder: (context, snapshot) {
            final isLoggedIn = snapshot.data ?? false;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // Error occurred while retrieving data, handle the error
                return Text('Error: ${snapshot.error}');
              } else if (isLoggedIn) {
                return EnterPINView(
                  calledValue: 1,
                  currentPIN: currentPin,
                );
              } else {
                return const SelectLanguageView(isFirstScreen: true);
              }
            } else {
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
  bool isLoggedIn = false;
  initPackageInfo();
  currentPin = await Preferences.getUserPreference(keyPIN) ?? '';
  token = await Preferences.getUserPreference(keyUserToken) ?? '';
  userName = await Preferences.getUserPreference(keyUserName) ?? '';
  regNo = await Preferences.getUserPreference(keyUserID) ?? '';
  phoneNo = await Preferences.getUserPreference(keyMobile) ?? '';
  isUserBiometricEnabled =
      await Preferences.getUserPreferenceBool(keyBiometricEnabled) ?? false;

  if (currentPin.isNotEmpty) {
    isLoggedIn = true;
    // APIHelper.instance.checkForTokenExpiry();
  }

  return isLoggedIn;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
