import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_app/bindings/binding.dart';
import 'package:task_app/pages/home.dart';
import 'package:task_app/pages/login.dart';
import 'package:task_app/pages/register.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final GetStorage _getStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _getStorage.read("userId") != null ? HomePage() : LoginPage(),
      initialBinding: ControllerBinding(),
    );
    // if (_getStorage.read("userId") != null) {
    //   return GetMaterialApp(home: HomePage());
    // } else {
    //   return GetMaterialApp(home: LoginPage());
    // }
    // return GetMaterialApp(initialRoute: '/', routes: {
    //   '/': (context) => LoginPage(),
    //   'login': (context) => LoginPage(),
    //   'register': (context) => RegisterPage()
    // });
  }
}
