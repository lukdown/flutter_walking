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
        "/gps_map": (context) => GpsMap(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '걸음걸음',
              style: TextStyle(
                color: Color(0xFF068cd2),
                fontSize: 60,
                fontWeight: FontWeight.bold,
                fontFamily: "Cafe24Ssurround-Regular",
              ),
            ),
            SizedBox(height: 20), // 텍스트와 버튼 사이의 간격
            AnimatedImage(), // AnimatedImage 위젯 추가
            SizedBox(height: 50), // 애니메이션 위젯과 버튼 사이의 간격 조정
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularButton(
                  text: '코스북',
                  icon: Icons.list,
                  onPressed: () {
                    Navigator.pushNamed(context, '/course_list');
                  },
                ),
                SizedBox(width: 20), // 버튼 사이의 간격
                CircularButton(
                  text: '산책하기',
                  icon: Icons.map,
                  onPressed: () {
                    Navigator.pushNamed(context, '/gps_map');
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


class AnimatedImage extends StatefulWidget {
  @override
  _AnimatedImageState createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage> {
  double _left = 0;
  double _top = 0;

  @override
  void initState() {
    super.initState();
    // 초기 위치 설정
    _startAnimation();
  }

  void _startAnimation() {
    // 애니메이션 시작
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _left = 0; // 원하는 위치로 이동
        _top = 10;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(left: _left, top: _top),
      child: Image.asset(
    'assets/images/Human_walk_cycle.gif',
    width: 300, // 원하는 너비로 설정
    height: 300, // 원하는 높이로 설정
    ));
  }
}



class CircularButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  CircularButton({required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF068cd2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // 버튼의 둥근 모서리 설정
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16), // 버튼 내부 여백 설정
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // 최소한의 너비를 가지도록 설정
        children: [
          Icon(icon, color: Colors.white), // 아이콘 색을 하얀색으로 설정
          SizedBox(width: 8), // 아이콘과 텍스트 사이 간격 설정
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Cafe24Ssurround-Regular",
              color: Colors.white
            ),
          ), // 텍스트 설정
        ],
      ),
    );
  }
}

