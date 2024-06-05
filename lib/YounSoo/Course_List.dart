import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'course_list_Vo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Course_List extends StatelessWidget {
  const Course_List({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff068cd2),
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xff243c84)),
          title: Text(
            "코스북",
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xff243c84)),
          ),
        ),
        body: _Course_List(),
        bottomNavigationBar: BottomNavigationBar(
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
                Navigator.popUntil(context, (route) => route.isFirst);
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
                label: '코스 그리기'),
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
  late final args = ModalRoute.of(context)!.settings.arguments as Map;

  // 공통 변수
  //var login_users_no2 = 0;
  bool isFavorite = false;
  bool isLike = false;
  late Future<List<Course_list_Vo>> courseListFuture;

  // 초기화할때
  @override
  void initState() {
    super.initState();
    courseListFuture = getCourseList(0);
    //print(courseListFuture);
  }

  // 화면그리기
  @override
  Widget build(BuildContext context) {

    // ModalRoute를 통해 현재 페이지에 전달된 arguments를 가져옵니다.
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    // 'personId' 키를 사용하여 값을 추출합니다.
    final login_users_no = args['login_users_no'];
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
              TabBar(
                indicatorColor: Color(0xff243c84),
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 11),
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
                      courseListFuture = getCourseList(login_users_no);
                      print("test1");
                    });
                  } else if (index == 2) {
                    setState(() {
                      courseListFuture = getCoursefList();
                      print("test2");
                    });
                  } else if (index == 0) {
                    setState(() {
                      courseListFuture = getCourseList(0);
                      print("test0");
                    });
                  }
                },
              ),
              Expanded(
                  child: TabBarView(children: [
                ListView.builder(
                    key: PageStorageKey("LIST_VIEW1"),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Center(
                            child: Container(
                          width: 400,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Color(0xff000000)),
                          ),
                          child: Row(
                            children: [

                              Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width: 350,
                                        child: IconButton(

                                          icon: Image.asset(
                                            width: 25,
                                              'assets/images/right-arrow_3031716.png'),
                                          onPressed: () {
                                            print("page이동");

                                            Navigator.pushNamed(
                                              context,
                                              "/subin",
                                              arguments: {
                                                "course_no": 31,
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width: 300,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 240,

                                              child: Text(
                                                "${snapshot.data![index].course_region}",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 40,
                                              child: IconButton(
                                                  onPressed: (){
                                                    //print(Text("즐겨찾기 버튼 클릭"));
                                                    //setState(() {
                                                      //isFavorite = !isFavorite;
                                                    //});
                                                  },
                                                  icon: Icon(
                                                    size: 25,
                                                    Icons.star,
                                                    //color: (isFavorite=true) ? Color(0xffff00ff) : Color(0xffd6d6d6),
                                                    color: _favorite(isFavorite, snapshot.data![index].course_favorites_no),
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        alignment: Alignment.centerRight,
                                        width: 300,
                                        child: Row(
                                          children: [
                                            Container(
                                              child: IconButton(
                                                  onPressed: (){
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
                                                    color: _like(isLike, snapshot.data![index].course_like_no),
                                                  )
                                              ),
                                            ),
                                            Container(
                                              width: 25,
                                              child: Text(
                                                  "${snapshot.data![index].like_count}",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                              ),
                                            ),
                                            Container(
                                              child: Image.asset(

                                                'assets/images/view_709612.png',
                                                width: 25,
                                              ),
                                            ),
                                            Container(
                                              width: 25,
                                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              child: Text(
                                                  "${snapshot.data![index].course_hit}",
                                                  style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width: 300,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 70,
                                              child: Text(
                                                "코스이름 : ",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 100,
                                              child: Text(
                                                "${snapshot.data![index].course_name}",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 55,
                                              child: Text(
                                                  "난이도 : ",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 70,
                                              child: Text(
                                                  "${snapshot.data![index].course_difficulty}",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width: 300,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 70,
                                              child: Text(
                                                  "소요시간 : ",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 100,
                                              child: Text(
                                                  "${snapshot.data![index].course_time}",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 55,
                                              child: Text(
                                                  "길이 : ",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 70,
                                              child: Text(
                                                  "${snapshot.data![index].course_length} m",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width: 300,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 55,
                                              child: Text(
                                                "설명 : ",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),),
                                            ),
                                            Container(
                                              width: 245,
                                              child: Text(
                                                  "${snapshot.data![index].course_introduce}",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),

                            ],
                          ),
                        )),
                      );
                    }),
                    ListView.builder(
                        key: PageStorageKey("LIST_VIEW2"),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Center(
                                child: Container(
                                  width: 400,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Color(0xff000000)),
                                  ),
                                  child: Row(
                                    children: [

                                      Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.centerRight,
                                                width: 350,
                                                child: IconButton(

                                                  icon: Image.asset(
                                                      width: 25,
                                                      'assets/images/right-arrow_3031716.png'),
                                                  onPressed: () {
                                                    print("page이동");

                                                    Navigator.pushNamed(
                                                      context,
                                                      "/subin",
                                                      arguments: {
                                                        "course_no": 31,
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                width: 300,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                      child: Text("${snapshot.data![index].course_region}"),
                                                    ),
                                                    Container(
                                                      width: 40,
                                                      child: IconButton(
                                                          onPressed: (){
                                                            //print(Text("즐겨찾기 버튼 클릭"));
                                                            //setState(() {
                                                            //isFavorite = !isFavorite;
                                                            //});
                                                          },
                                                          icon: Icon(
                                                            size: 25,
                                                            Icons.star,
                                                            //color: (isFavorite=true) ? Color(0xffff00ff) : Color(0xffd6d6d6),
                                                            color: _favorite(isFavorite, snapshot.data![index].course_favorites_no),
                                                          )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerRight,
                                                width: 300,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: IconButton(
                                                          onPressed: (){
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
                                                            color: _like(isLike, snapshot.data![index].course_like_no),
                                                          )
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 25,
                                                      child: Text("${snapshot.data![index].like_count}"),
                                                    ),
                                                    Container(
                                                      child: Image.asset(

                                                        'assets/images/view_709612.png',
                                                        width: 25,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 25,
                                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                      child: Text("${snapshot.data![index].course_hit}"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerRight,
                                                width: 300,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 70,
                                                      child: Text("코스 이름 : "),
                                                    ),
                                                    Container(
                                                      width: 105,
                                                      child: Text("${snapshot.data![index].course_name}"),
                                                    ),
                                                    Container(
                                                      width: 55,
                                                      child: Text("난이도 : "),
                                                    ),
                                                    Container(
                                                      width: 70,
                                                      child: Text("${snapshot.data![index].course_difficulty}"),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerRight,
                                                width: 300,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: Text("소요시간 : "),
                                                    ),
                                                    Container(
                                                      child: Text("${snapshot.data![index].course_time}"),
                                                    ),
                                                    Container(
                                                      child: Text("길이 : "),
                                                    ),
                                                    Container(
                                                      child: Text("${snapshot.data![index].course_length} m"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerRight,
                                                width: 300,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: Text("설명 : "),
                                                    ),
                                                    Container(
                                                      child: Text("${snapshot.data![index].course_introduce}"),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                      ),

                                    ],
                                  ),
                                )),
                          );
                        }),
                    ListView.builder(
                        key: PageStorageKey("LIST_VIEW3"),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Center(
                                child: Container(
                                  width: 400,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Color(0xff000000)),
                                  ),
                                  child: Row(
                                    children: [

                                      Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.centerRight,
                                                width: 350,
                                                child: IconButton(

                                                  icon: Image.asset(
                                                      width: 25,
                                                      'assets/images/right-arrow_3031716.png'),
                                                  onPressed: () {
                                                    print("page이동");

                                                    Navigator.pushNamed(
                                                      context,
                                                      "/subin",
                                                      arguments: {
                                                        "course_no": 31,
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                width: 300,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                      child: Text("${snapshot.data![index].course_region}"),
                                                    ),
                                                    Container(
                                                      width: 40,
                                                      child: IconButton(
                                                          onPressed: (){
                                                            //print(Text("즐겨찾기 버튼 클릭"));
                                                            //setState(() {
                                                            //isFavorite = !isFavorite;
                                                            //});
                                                          },
                                                          icon: Icon(
                                                            size: 25,
                                                            Icons.star,
                                                            //color: (isFavorite=true) ? Color(0xffff00ff) : Color(0xffd6d6d6),
                                                            color: _favorite(isFavorite, snapshot.data![index].course_favorites_no),
                                                          )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerRight,
                                                width: 300,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: IconButton(
                                                          onPressed: (){
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
                                                            color: _like(isLike, snapshot.data![index].course_like_no),
                                                          )
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 25,
                                                      child: Text("${snapshot.data![index].like_count}"),
                                                    ),
                                                    Container(
                                                      child: Image.asset(

                                                        'assets/images/view_709612.png',
                                                        width: 25,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 25,
                                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                      child: Text("${snapshot.data![index].course_hit}"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerRight,
                                                width: 300,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 70,
                                                      child: Text("코스 이름 : "),
                                                    ),
                                                    Container(
                                                      width: 105,
                                                      child: Text("${snapshot.data![index].course_name}"),
                                                    ),
                                                    Container(
                                                      width: 55,
                                                      child: Text("난이도 : "),
                                                    ),
                                                    Container(
                                                      width: 70,
                                                      child: Text("${snapshot.data![index].course_difficulty}"),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerRight,
                                                width: 300,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: Text("소요시간 : "),
                                                    ),
                                                    Container(
                                                      child: Text("${snapshot.data![index].course_time}"),
                                                    ),
                                                    Container(
                                                      child: Text("길이 : "),
                                                    ),
                                                    Container(
                                                      child: Text("${snapshot.data![index].course_length} m"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerRight,
                                                width: 300,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: Text("설명 : "),
                                                    ),
                                                    Container(
                                                      child: Text("${snapshot.data![index].course_introduce}"),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                      ),

                                    ],
                                  ),
                                )),
                          );
                        }),
              ]))
            ],
          );
        } // 데이터가있으면
      },
    );
  }

  //리스트가져오기 dio통신
  Future<List<Course_list_Vo>> getCourseList(write_users_no) async {
    var login_users_no = await storage.read(key: 'UserNo');
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
        'http://localhost:9020/api/walking/coursebooklist',
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
        'http://localhost:9020/api/walking/coursebookflist',
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
        'http://localhost:9020/api/walking/likeupdatedelete',
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
        'http://localhost:9020/api/walking/likeupdatedelete',
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

Color _favorite(isFavorite, course_favorites_no){
  if(course_favorites_no != 0){
    // 코드
    return Color(0xffffff00);
  }else{
    // 코드
    return Color(0xffd6d6d6);
  }
}

Color _like(isLike, course_like_no){
  //print(course_like_no);
  if(course_like_no != 0){

    // 코드
    return Color(0xffff0000);
  }else{
    // 코드
    return Color(0xffd6d6d6);
  }
}

