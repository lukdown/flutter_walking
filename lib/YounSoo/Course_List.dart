import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../EunBin/Gps_Map.dart';
import 'course_list_Vo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../EunBin/Course_Gps_Map.dart';

class Course_List extends StatelessWidget {
  const Course_List({super.key});

  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff068cd2),
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xff243c84)),
          automaticallyImplyLeading: false,
          title: Text(
            "코스북",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xffffffff),
                fontSize: 30,
                fontFamily: "Cafe24Ssurround-Bold"),
          ),
        ),
        body: _Course_List(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xffffffff),
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: 12.0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Color(0xff243c84),
          unselectedItemColor: Color(0xff9e9e9e),
          onTap: (int index) {
            switch (index) {
              case 0:
                Navigator.popUntil(context, (route) => route.isFirst);
                break;
              case 1:
                Navigator.pushNamed(context, '/course_list');
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GpsMap(),
                  ),
                );
                break;
              case 3:
                Navigator.popUntil(context, (route) => route.isFirst);
                break;
              case 4:
                Navigator.popUntil(context, (route) => route.isFirst);
                break;
              default:
            }
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Color(0xff16517b),
                ),
                label: '홈'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.format_list_bulleted,
                  color: Color(0xff16517b),
                ),
                label: '코스북'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.brush,
                  color: Color(0xff16517b),
                ),
                label: '산책하기'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.playlist_add_check_circle,
                  color: Color(0xff16517b),
                ),
                label: '나의 산책'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Color(0xff16517b),
                ),
                label: '마이페이지'),
          ],

          //selectedItemColor: Color.fromARGB(255, 197, 142, 233),
          //unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}

// 등록
class _Course_List extends StatefulWidget {
  const _Course_List({super.key});

  @override
  State<_Course_List> createState() => _Course_ListState();
}

// 할일
class _Course_ListState extends State<_Course_List> {
  final storage = const FlutterSecureStorage();

  // 라우터
  /*late final args = ModalRoute.of(context)!.settings.arguments as Map;*/

  // 공통 변수
  //var login_users_no2 = 0;
  bool isFavorite = false;
  bool isLike = false;
  late Future<List<Course_list_Vo>> courseListFuture;

  // 초기화할때
  @override
  void initState() {
    super.initState();
    courseListFuture = getCourseList();
    //print(courseListFuture);
  }

  // 화면그리기
  @override
  Widget build(BuildContext context) {
    // ModalRoute를 통해 현재 페이지에 전달된 arguments를 가져옵니다.

    // 'personId' 키를 사용하여 값을 추출합니다.
    //final login_users_no = args['login_users_no'];
    // 추가코드   // 데이터 불러괴 메소드 호출
    //print("initState(): 데이터 가져오기 전");
    //courseListFuture = getCourseList(login_users_no, 0);
    //print("initState(): 데이터 가져오기 후");

    print("================================");
    //print(login_users_no);
    print("================================");

    print("Build(): 그리기 작업");

    return FutureBuilder(
      future: courseListFuture, //Future<> 함수명, 으로 받은 데이타
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('데이터를 불러오는 데 실패했습니다.'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('데이터가 없습니다.'));
        } else {
          //데이터가 있으면

          return Column(
            children: [
              Container(
                color: Color(0xffffffff),
                child: TabBar(
                  indicatorColor: Color(0xff243c84),
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Cafe24Ssurround-Bold",
                      fontSize: 20),
                  indicatorWeight: 5,
                  tabs: [
                    Tab(
                      text: "전체",
                      height: 50,
                    ),
                    Tab(
                      text: "내 코스",
                      height: 50,
                    ),
                    Tab(
                      text: "즐겨찾기",
                      height: 50,
                    ),
                  ],
                  onTap: (index) {
                    if (index == 1) {
                      setState(() {
                        courseListFuture = getMyCourseList();
                        print("test1");
                      });
                    } else if (index == 2) {
                      setState(() {
                        courseListFuture = getCoursefList();
                        print("test2");
                      });
                    } else if (index == 0) {
                      setState(() {
                        courseListFuture = getCourseList();
                        print("test0");
                      });
                    }
                  },
                ),
              ),
              Expanded(
                  child: Container(
                width: 360,
                color: Color(0xffD6D6D6),
                child: TabBarView(children: [
                  ListView.builder(
                      key: PageStorageKey("LIST_VIEW1"),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        var courseNono = snapshot.data![index].course_no.toString();
                        return Container(
                          child: Container(
                              child: Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            width: 320,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                Container(
                                    child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      width: 320,
                                      padding: EdgeInsets.only(left: 15),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${snapshot.data![index].course_name}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                            fontFamily: "Cafe24Ssurround-Bold"),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      alignment: Alignment.centerLeft,
                                      width: 320,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: IconButton(
                                                onPressed: () {
                                                  // print(Text("좋아요 버튼 클릭"));
                                                  // if(snapshot.data![index].course_like_no == 0) {
                                                  //   getLikeInsert(login_users_no, snapshot.data![index].course_no);
                                                  //
                                                  // }else {
                                                  //   getLikeDelete(login_users_no, snapshot.data![index].course_no);
                                                  //
                                                  // }
                                                  // setState(() {
                                                  //   isLike = !isLike;
                                                  //
                                                  //
                                                  //
                                                  // });
                                                },
                                                icon: Icon(
                                                  size: 25,
                                                  Icons.favorite,
                                                  //color: (isFavorite=true) ? Color(0xffff00ff) : Color(0xffd6d6d6),
                                                  color: _like(
                                                      isLike,
                                                      snapshot.data![index]
                                                          .course_like_no),
                                                )),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 5),
                                            child: Text(
                                              "${snapshot.data![index].like_count}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Image.asset(
                                              'assets/images/view_709612.png',
                                              width: 25,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 0, 5, 0),
                                            child: Text(
                                              "${snapshot.data![index].course_hit}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                          Container(
                                            child: IconButton(
                                                onPressed: () {
                                                  //print(Text("즐겨찾기 버튼 클릭"));
                                                  //setState(() {
                                                  //isFavorite = !isFavorite;
                                                  //});
                                                },
                                                icon: Icon(
                                                  size: 25,
                                                  Icons.star,
                                                  //color: (isFavorite=true) ? Color(0xffff00ff) : Color(0xffd6d6d6),
                                                  color: _favorite(
                                                      isFavorite,
                                                      snapshot.data![index]
                                                          .course_favorites_no),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      padding: EdgeInsets.only(left: 15),
                                      alignment: Alignment.centerLeft,
                                      width: 320,
                                      child: Text(
                                        "장소 : ${snapshot.data![index].course_region}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily:
                                                "Cafe24Ssurround-Regular"),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      padding: EdgeInsets.only(left: 15),
                                      alignment: Alignment.centerLeft,
                                      width: 320,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 150,
                                            child: Text(
                                              "난이도: ${snapshot.data![index].course_difficulty}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            child: Text(
                                              "소요시간: ${snapshot.data![index].course_time}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      padding: EdgeInsets.only(left: 15),
                                      width: 320,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "길이: ${snapshot.data![index].course_length} m",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily:
                                                "Cafe24Ssurround-Regular"),
                                      ),
                                    ),
                                    Container(
                                      width: 320,
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "설명: ${snapshot.data![index].course_introduce}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily:
                                                "Cafe24Ssurround-Regular"),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      margin:
                                          EdgeInsets.fromLTRB(10, 20, 0, 10),
                                      width: 200,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF068cd2),
                                        ),
                                        onPressed: () {

                                          print("--------------------------------");
                                          print("--------------------------------");
                                          print("${snapshot.data![index].course_no}");
                                          print("--------------------------------");
                                          storage.write(key: "courseNo", value: courseNono);
                                          Navigator.pushNamed(
                                            context,
                                            "/course_gps_map",
                                            arguments: {
                                              "course_no": "${snapshot.data![index].course_no}"
                                            },
                                          );
                                          /*
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CourseGpsMap(),
                                              settings: RouteSettings(
                                                arguments: {
                                                  "course_no": "${snapshot.data![index].course_no}"
                                                },
                                              ),
                                            ),
                                          );

                                           */
                                          //getUserData(storage,_idController.text, _pwController.text, context);
                                        },
                                        child: Text(
                                          "따라가기",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xffffffff),
                                              fontFamily:
                                                  "Cafe24Ssurround-Regular"),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          )),
                        );
                      }),
                  ListView.builder(
                      key: PageStorageKey("LIST_VIEW2"),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        var courseNono = snapshot.data![index].course_no.toString();
                        return Container(
                          child: Center(
                              child: Container(
                            width: 360,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Color(0xff000000)),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                Container(
                                    child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                      width: 330,
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(15, 0, 0, 0),
                                        width: 260,
                                        child: Text(
                                          "${snapshot.data![index].course_name}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily:
                                                  "Cafe24Ssurround-Bold"),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: 330,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: IconButton(
                                                onPressed: () {
                                                  // print(Text("좋아요 버튼 클릭"));
                                                  // if(snapshot.data![index].course_like_no == 0) {
                                                  //   getLikeInsert(login_users_no, snapshot.data![index].course_no);
                                                  //
                                                  // }else {
                                                  //   getLikeDelete(login_users_no, snapshot.data![index].course_no);
                                                  //
                                                  // }
                                                  // setState(() {
                                                  //   isLike = !isLike;
                                                  //
                                                  //
                                                  //
                                                  // });
                                                },
                                                icon: Icon(
                                                  size: 25,
                                                  Icons.favorite,
                                                  //color: (isFavorite=true) ? Color(0xffff00ff) : Color(0xffd6d6d6),
                                                  color: _like(
                                                      isLike,
                                                      snapshot.data![index]
                                                          .course_like_no),
                                                )),
                                          ),
                                          Container(
                                            width: 25,
                                            child: Text(
                                                "${snapshot.data![index].like_count}"),
                                          ),
                                          Container(
                                            child: Image.asset(
                                              'assets/images/view_709612.png',
                                              width: 25,
                                            ),
                                          ),
                                          Container(
                                            width: 25,
                                            margin: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                                "${snapshot.data![index].course_hit}"),
                                          ),
                                          Container(
                                            width: 40,
                                            child: IconButton(
                                                onPressed: () {
                                                  //print(Text("즐겨찾기 버튼 클릭"));
                                                  //setState(() {
                                                  //isFavorite = !isFavorite;
                                                  //});
                                                },
                                                icon: Icon(
                                                  size: 25,
                                                  Icons.star,
                                                  //color: (isFavorite=true) ? Color(0xffff00ff) : Color(0xffd6d6d6),
                                                  color: _favorite(
                                                      isFavorite,
                                                      snapshot.data![index]
                                                          .course_favorites_no),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: 330,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            margin: EdgeInsets.only(left: 15),
                                            child: Text(
                                              "장소 : ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                          Container(
                                            width: 270,
                                            child: Text(
                                              "${snapshot.data![index].course_region}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: 330,
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            margin: EdgeInsets.fromLTRB(
                                                15, 0, 0, 0),
                                            child: Text(
                                              "난이도 : ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                          Container(
                                            width: 90,
                                            child: Text(
                                              "${snapshot.data![index].course_difficulty}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                          Container(
                                            width: 70,
                                            child: Text(
                                              "소요시간 : ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                          Container(
                                            width: 90,
                                            child: Text(
                                              "${snapshot.data![index].course_time}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 330,
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            margin: EdgeInsets.only(left: 15),
                                            child: Text(
                                              "길이 : ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                          Container(
                                            width: 270,
                                            child: Text(
                                              "${snapshot.data![index].course_length} m",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: 330,
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            margin: EdgeInsets.only(left: 15),
                                            child: Text(
                                              "설명 : ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                          Container(
                                            width: 270,
                                            child: Text(
                                              "${snapshot.data![index].course_introduce}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      margin:
                                          EdgeInsets.fromLTRB(10, 10, 0, 10),
                                      width: 200,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF068cd2),
                                        ),
                                        onPressed: () {
                                          storage.write(key: "courseNo", value: courseNono);
                                          Navigator.pushNamed(
                                            context,
                                            '/course_gps_map'
                                          );
                                          //getUserData(storage,_idController.text, _pwController.text, context);
                                        },
                                        child: Text(
                                          "따라가기",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xffffffff),
                                              fontFamily:
                                                  "Cafe24Ssurround-Regular"),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          )),
                        );
                      }),
                  ListView.builder(
                      key: PageStorageKey("LIST_VIEW3"),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        var courseNono = snapshot.data![index].course_no.toString();
                        return Container(
                          child: Center(
                              child: Container(
                            width: 360,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Color(0xff000000)),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                Container(
                                    child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                      width: 330,
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(15, 0, 0, 0),
                                        width: 260,
                                        child: Text(
                                          "${snapshot.data![index].course_name}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily:
                                                  "Cafe24Ssurround-Bold"),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: 330,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: IconButton(
                                                onPressed: () {
                                                  // print(Text("좋아요 버튼 클릭"));
                                                  // if(snapshot.data![index].course_like_no == 0) {
                                                  //   getLikeInsert(login_users_no, snapshot.data![index].course_no);
                                                  //
                                                  // }else {
                                                  //   getLikeDelete(login_users_no, snapshot.data![index].course_no);
                                                  //
                                                  // }
                                                  // setState(() {
                                                  //   isLike = !isLike;
                                                  //
                                                  //
                                                  //
                                                  // });
                                                },
                                                icon: Icon(
                                                  size: 25,
                                                  Icons.favorite,
                                                  //color: (isFavorite=true) ? Color(0xffff00ff) : Color(0xffd6d6d6),
                                                  color: _like(
                                                      isLike,
                                                      snapshot.data![index]
                                                          .course_like_no),
                                                )),
                                          ),
                                          Container(
                                            width: 25,
                                            child: Text(
                                                "${snapshot.data![index].like_count}"),
                                          ),
                                          Container(
                                            child: Image.asset(
                                              'assets/images/view_709612.png',
                                              width: 25,
                                            ),
                                          ),
                                          Container(
                                            width: 25,
                                            margin: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                                "${snapshot.data![index].course_hit}"),
                                          ),
                                          Container(
                                            width: 40,
                                            child: IconButton(
                                                onPressed: () {
                                                  //print(Text("즐겨찾기 버튼 클릭"));
                                                  //setState(() {
                                                  //isFavorite = !isFavorite;
                                                  //});
                                                },
                                                icon: Icon(
                                                  size: 25,
                                                  Icons.star,
                                                  //color: (isFavorite=true) ? Color(0xffff00ff) : Color(0xffd6d6d6),
                                                  color: _favorite(
                                                      isFavorite,
                                                      snapshot.data![index]
                                                          .course_favorites_no),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: 330,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            margin: EdgeInsets.only(left: 15),
                                            child: Text(
                                              "장소 : ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                          Container(
                                            width: 270,
                                            child: Text(
                                              "${snapshot.data![index].course_region}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: 330,
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            margin: EdgeInsets.fromLTRB(
                                                15, 0, 0, 0),
                                            child: Text(
                                              "난이도 : ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                          Container(
                                            width: 90,
                                            child: Text(
                                              "${snapshot.data![index].course_difficulty}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                          Container(
                                            width: 70,
                                            child: Text(
                                              "소요시간 : ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                          Container(
                                            width: 90,
                                            child: Text(
                                              "${snapshot.data![index].course_time}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 330,
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            margin: EdgeInsets.only(left: 15),
                                            child: Text(
                                              "길이 : ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                          Container(
                                            width: 270,
                                            child: Text(
                                              "${snapshot.data![index].course_length} m",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: 330,
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            margin: EdgeInsets.only(left: 15),
                                            child: Text(
                                              "설명 : ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                          Container(
                                            width: 270,
                                            child: Text(
                                              "${snapshot.data![index].course_introduce}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      "Cafe24Ssurround-Regular"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      margin:
                                      EdgeInsets.fromLTRB(10, 10, 0, 10),
                                      width: 200,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF068cd2),
                                        ),
                                        onPressed: () {
                                          print("-----------------------------------------");
                                          print("${snapshot.data![index].course_no}");
                                          storage.write(key: "courseNo", value: courseNono);
                                          Navigator.pushNamed(
                                            context,
                                            '/course_gps_map'
                                          );
                                          //getUserData(storage,_idController.text, _pwController.text, context);
                                        },
                                        child: Text(
                                          "따라가기",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xffffffff),
                                              fontFamily:
                                              "Cafe24Ssurround-Regular"),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          )),
                        );
                      }),
                ]),
              ))
            ],
          );
        } // 데이터가있으면
      },
    );
  }

  //리스트
  Future<List<Course_list_Vo>> getCourseList() async {
    var login_users_no = await storage.read(key: 'UserNo');

    print("=====421412============");
    print(login_users_no);

    print("=====421412============");

    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();

      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';

      // 서버 요청
      final response = await dio.post(
        'http://43.201.96.200:9020/api/walking/coursebooklist',
        data: {
          // 예시 data  map->json자동변경
          //'login_users_no': login_users_no,
          'login_users_no': login_users_no,

        },
      );

      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
        //접속성공 200 이면
        //print(response.data); // json->map 자동변경
        //print(response.data.length); // json->map 자동변경
        //print(response.data[0]); // json->map 자동변경
        //print(response.data[0]); // json->map 자동변경
        //return PersonVo.fromJson(response.data["apiData"]);
        //print(response.data[0].productname);

        List<Course_list_Vo> courseList = [];
        //print(Course_list_Vo.fromJson(response.data));
        for (int i = 0; i < response.data.length; i++) {
          Course_list_Vo course_list_Vo =
              Course_list_Vo.fromJson(response.data[i]);
          courseList.add(course_list_Vo);
          //print(courseList[i].write_users_no);
        }
        print(courseList);

        return courseList;
      } else {
        //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  }

  //나의 코스리스트가져오기 dio통신
  Future<List<Course_list_Vo>> getMyCourseList() async {
    var login_users_no = await storage.read(key: 'UserNo');
    var write_users_no = login_users_no;
    print("=====421412============");
    print(login_users_no);
    print(write_users_no);
    print("=====421412============");

    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();

      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';

      // 서버 요청
      final response = await dio.post(
        'http://43.201.96.200:9020/api/walking/coursebooklist',
        data: {
          // 예시 data  map->json자동변경
          //'login_users_no': login_users_no,
          'login_users_no': login_users_no,
          'write_users_no': write_users_no,
        },
      );

      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
        //접속성공 200 이면
        //print(response.data); // json->map 자동변경
        //print(response.data.length); // json->map 자동변경
        //print(response.data[0]); // json->map 자동변경
        //print(response.data[0]); // json->map 자동변경
        //return PersonVo.fromJson(response.data["apiData"]);
        //print(response.data[0].productname);

        List<Course_list_Vo> courseList = [];
        //print(Course_list_Vo.fromJson(response.data));
        for (int i = 0; i < response.data.length; i++) {
          Course_list_Vo course_list_Vo =
              Course_list_Vo.fromJson(response.data[i]);
          courseList.add(course_list_Vo);
          //print(courseList[i].write_users_no);
        }
        //print(courseList);
        return courseList;
      } else {
        //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  } //getCourseList()

  // 즐겨찾기 리스트가져오기 dio통신
  Future<List<Course_list_Vo>> getCoursefList() async {
    String? login_users_no = await storage.read(key: 'UserNo');
    print("=====421412============");
    print(login_users_no);
    //print(write_users_no);
    print("=====421412============");

    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();

      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';

      // 서버 요청
      final response = await dio.post(
        'http://43.201.96.200:9020/api/walking/coursebookflist',
        data: login_users_no,
      );

      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
        //접속성공 200 이면
        //print(response.data); // json->map 자동변경
        //print(response.data.length); // json->map 자동변경
        //print(response.data[0]); // json->map 자동변경
        //print(response.data[0]); // json->map 자동변경
        //return PersonVo.fromJson(response.data["apiData"]);
        //print(response.data[0].productname);

        List<Course_list_Vo> courseList = [];
        //print(Course_list_Vo.fromJson(response.data));
        for (int i = 0; i < response.data.length; i++) {
          Course_list_Vo course_list_Vo =
              Course_list_Vo.fromJson(response.data[i]);
          courseList.add(course_list_Vo);
          //print(courseList[i].write_users_no);
        }
        //print(courseList);
        return courseList;
      } else {
        //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  } //getCourseList()

// 좋아요 등록 dio통신
  Future<void> getLikeInsert(login_users_no, course_no) async {
    //print(login_users_no);
    //print(course_no);
    print("===================erwr=====");
    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();

      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';

      // 서버 요청
      final response = await dio.post(
        'http://43.201.96.200:9020/api/walking/likeupdatedelete',
        data: {
          // 예시 data  map->json자동변경
          'users_no': login_users_no,
          'course_no': course_no,
        },
      );

      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
        //접속성공 200 이면
        //print(response.data); // json->map 자동변경
        //print(response.data.length); // json->map 자동변경
        //print(response.data[0]); // json->map 자동변경
        //print(response.data[0]); // json->map 자동변경
        //return PersonVo.fromJson(response.data["apiData"]);
        //print(response.data[0].productname);
        //print(response.data["apiData"]); // json->map 자동변경
        isLike = !isLike;
      } else {
        //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  } //getLikeInsert()

// 좋아요 삭제 dio통신
  Future<void> getLikeDelete(login_users_no, course_no) async {
    //print(login_users_no);
    //print(course_no);
    print("===================erwr=====");
    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();

      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';

      // 서버 요청
      final response = await dio.delete(
        'http://43.201.96.200:9020/api/walking/likeupdatedelete',
        data: {
          // 예시 data  map->json자동변경
          'users_no': login_users_no,
          'course_no': course_no,
        },
      );

      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
        //접속성공 200 이면
        //print(response.data); // json->map 자동변경
        //print(response.data.length); // json->map 자동변경
        //print(response.data[0]); // json->map 자동변경
        //print(response.data[0]); // json->map 자동변경
        //return PersonVo.fromJson(response.data["apiData"]);
        //print(response.data[0].productname);
        print(response.data["apiData"]); // json->map 자동변경
        isLike = !isLike;
      } else {
        //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  } //getLikeInsert()
}

Color _favorite(isFavorite, course_favorites_no) {
  if (course_favorites_no != 0) {
    // 코드
    return Color(0xffFFC932);
  } else {
    // 코드
    return Color(0xffd6d6d6);
  }
}

Color _like(isLike, course_like_no) {
  //print(course_like_no);
  if (course_like_no != 0) {
    // 코드
    return Color(0xffff0000);
  } else {
    // 코드
    return Color(0xffd6d6d6);
  }
}
