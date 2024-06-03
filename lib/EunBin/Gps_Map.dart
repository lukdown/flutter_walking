import 'package:flutter/material.dart';

class Gps_Map extends StatelessWidget {
  const Gps_Map({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xff068cd2)),
        title: Text("결제하기",
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Color(0xff068cd2),
          ),
        ),
      ),
      body: Container(
        child: Text("임시"),
      ),

    );
  }
}
