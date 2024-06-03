import 'package:flutter/material.dart';
import 'UserListVo.dart';
import 'package:dio/dio.dart';

class Login_page extends StatelessWidget {
  const Login_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: _Login_Page(),
      )
    );
  }
}

class _Login_Page extends StatefulWidget {
  const _Login_Page({super.key});

  @override
  State<_Login_Page> createState() => _LoginPageState();
}

class _LoginPageState extends State<_Login_Page> {

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 90),
              child: Text("걸음걸음",
                style: TextStyle(
                  fontSize: 80,
                  color: Color(0xFF068cd2),
                ),
              ),
            ),
            Container(
              child: Text("Step Step",
                style: TextStyle(
                  fontSize: 50,
                  color: Color(0xFF068cd2),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:50),
              child: Text("ID",
                style: TextStyle(
                  fontSize: 40,
                  color: Color(0xFF068cd2)
                )
              ),
            ),
            Container(
              width: 300,
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  color: Color(0xFF068cd2),
                  borderRadius:BorderRadius.circular(20)
              ),
              child: TextFormField(
                style: TextStyle(fontSize: 15,color: Color(0xFFffffff),),
                controller: _idController,
                decoration: InputDecoration(
                  border:InputBorder.none
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:10),
              child: Text("PW",
                  style: TextStyle(
                      fontSize: 40,
                      color: Color(0xFF068cd2)
                  )
              ),
            ),
            Container(
              width: 300,
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  color: Color(0xFF068cd2),
                  borderRadius:BorderRadius.circular(20)
              ),
              child: TextFormField(
                style: TextStyle(fontSize: 15,color: Color(0xFFffffff),),
                controller: _pwController,
                decoration: InputDecoration(
                    border:InputBorder.none
                ),
              ),
            ),
            Container(
              width: 150,
              height: 50,
              margin: EdgeInsets.only(top: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF068cd2),
                  padding: EdgeInsets.only(bottom: 15)
                ),
                onPressed: (){
                  getUserData(_idController.text, _pwController.text);
                },
                child: Text("Login",
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xFFffffff)
                  ),
                ),
              ),
            )
          ],

        ),
      ),
    );
  }
}


Future<void> getUserData(String id, String password) async {
  print("getPersonByNo(): 데이터 가져오기 중");
  print(id);
  print(password);
  //코드 작성
  try {
    /*----요청처리-------------------*/
    //Dio 객체 생성 및 설정
    var dio = Dio();

    // 헤더설정:json으로 전송
    dio.options.headers['Content-Type'] = 'application/json';

    // 서버 요청
    final response = await dio.post(
      'http://localhost:9020/api/walking/loginpage',
      /*
        queryParameters: {
          // 예시 파라미터
          'page': 1,
          'keyword': '홍길동',
        },
       */
        data: {
          // 예시 data  map->json자동변경
          'users_id': id,
          'users_pw': password,
        },

    );

    /*----응답처리-------------------*/
    if (response.statusCode == 200) {
      //접속성공 200 이면
      print(response.headers['authorization']);
      /*
      String authorizationHeader = response.headers['authorization'] as String;
      List<String> headerParts = authorizationHeader.split(" ");
      String? token = headerParts.length > 1 ? headerParts[1] : null;

      print('토큰값:$token');
      */
      print(response.data); // json->map 자동변경



      //return UserListVo.fromJson(response.data);
    } else {
      //접속실패 404, 502등등 api서버 문제
      throw Exception('api 서버 문제');
    }
  } catch (e) {
    //예외 발생
    throw Exception('Failed to load person: $e');
  }
}