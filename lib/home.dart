import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'JongHee/Login_Page.dart';
import 'EunBin/Gps_Map.dart';
import 'EunBin/Course_Gps_Map.dart';
import 'YounSoo/Course_List.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      routes: {
        '/login': (context) => Login_page(),
        '/course_list': (context) => Course_List(),
        "/course_gps_map": (context) => CourseGpsMap(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff068cd2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '걸음걸음',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50), // 텍스트와 버튼 사이의 간격
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularButton(
                  text: 'Login',
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
                SizedBox(width: 20), // 버튼 사이의 간격
                CircularButton(
                  text: 'Course List',
                  onPressed: () {
                    Navigator.pushNamed(context, '/course_list');
                  },
                ),
                SizedBox(width: 20), // 버튼 사이의 간격
                CircularButton(
                  text: 'GPS Map',
                  onPressed: () {
                    Navigator.pushNamed(context, '/course_gps_map');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CircularButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(24), // 버튼 크기 설정
      ),
      child: Text(text),
    );
  }

}
