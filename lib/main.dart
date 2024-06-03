import 'package:flutter/material.dart';

import 'home.dart';
import 'JongHee/Login_Page.dart';
import 'EunBin/Gps_Map.dart';
import 'YounSoo/Course_List.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        "/Gps_Map": (context) => Gps_Map(),
      }
    );
  }
}

