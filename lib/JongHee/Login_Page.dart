import 'package:flutter/material.dart';

class Login_page extends StatelessWidget {
  const Login_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text("걸음걸음",style: TextStyle(fontSize: 20, color: Color(0xFF068cd2)),),
      ),
    );
  }
}

class _Login_Page extends StatefulWidget {
  const _Login_Page({super.key});

  @override
  State<_Login_Page> createState() => _LoginPageState();
}

class _LoginPageState extends State<_Login_Page> {



  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
