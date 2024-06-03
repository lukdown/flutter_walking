import 'package:flutter/material.dart';
//import 'package:flutter_kakao_map/flutter_kakao_map.dart';


class Gps_Map extends StatelessWidget {
  const Gps_Map({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xff068cd2)),
        title: Text("오늘의 산책",
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Color(0xff068cd2),fontFamily: "런드리고딕OTF Regular"
          ),
        ),
      ),
      body: Container(
        child: Text("임시"),
      ),

    );
  }
}


