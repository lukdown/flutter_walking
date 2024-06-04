import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home.dart';
import 'JongHee/Login_Page.dart';
import 'EunBin/Gps_Map.dart';
import 'YounSoo/Course_List.dart';


void main() {
  // FlutterSecureStorage 객체 생성
  final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

  // 애플리케이션 시작
  runApp(MyApp(storage: storage));
}

class MyApp extends StatelessWidget {
  final FlutterSecureStorage storage;

  const MyApp({Key? key, required this.storage}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => Home(),
        "/login": (context) => Login_page(),
        "/course_list": (context) => Course_List(),
        "/gps_map": (context) => Gps_Map(),
      }
    );
  }
}
AndroidOptions _getAndroidOptions() => const AndroidOptions(
  encryptedSharedPreferences: true,
);
