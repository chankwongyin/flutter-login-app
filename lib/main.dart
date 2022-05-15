import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loginapp/others/contants.dart';

import 'package:loginapp/ui/pages/homePage.dart';
import 'package:loginapp/ui/pages/loginPage.dart';
import 'package:loginapp/ui/pages/navigationPage.dart';
import 'package:loginapp/ui/pages/resetPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive local storage initialization
  await Hive.initFlutter();
  var box = await Hive.openBox(AppConstants.HIVE_BOX_NAME_CONFIGS);
  final isSavedPassword = box.get(AppConstants.HIVE_CONFIG_IS_SAVED_PASSWORD);
  if (isSavedPassword == null) {
    box.put(AppConstants.HIVE_CONFIG_IS_SAVED_PASSWORD, false);
  }

  // Secure storage initialization
  final storage = new FlutterSecureStorage();
  String? username =
      await storage.read(key: AppConstants.SECURE_STORAGE_KEY_USERNAME);
  String? password =
      await storage.read(key: AppConstants.SECURE_STORAGE_KEY_PASSWORD);
  if (username == null) {
    await storage.write(
        key: AppConstants.SECURE_STORAGE_KEY_USERNAME, value: "testuser");
  }
  if (password == null)
    // Hardcode password
    await storage.write(
        key: AppConstants.SECURE_STORAGE_KEY_PASSWORD, value: "123456");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/navigate': (context) => NavigationPage(),
        '/reset': (context) => ResetPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
