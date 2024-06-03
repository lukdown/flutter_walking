class Course_list_Vo {
  //필드
  int course_no;
  int users_no;
  int course_favorites_no;
  int course_like_no;

  // 코스 리스트
  String course_name;
  String course_difficulty;
  int course_length;
  String course_time;
  int course_hit;
  String course_region;
  String course_date;
  bool course_open;
  String course_introduce;
  int like_count;

  int write_users_no;
  int login_users_no;

  // 리뷰리스트
  int review_no;
  String review_content;
  String review_date;

  // 유저 리스트
  String users_name;
  String users_id;
  String users_nickname;
  String users_hp;
  String users_residence;

  // 코스 위도 경도
  int course_point_no;
  double course_latitude;
  double course_longitude;
  int course_order;
  String course_division;

  int group_num;

  int facilities_no;
  int convenient_facilities_type_no;
  String facilities_name;
  double facilities_latitude;
  double facilities_longitude;
  String facilities_memo;

  //생성자
  Course_list_Vo({
      required this.course_no,
      required this.users_no,
      required this.course_favorites_no,
      required this.course_like_no,
      required this.course_name,
      required this.course_difficulty,
      required this.course_length,
      required this.course_time,
      required this.course_hit,
      required this.course_region,
      required this.course_date,
      required this.course_open,
      required this.course_introduce,
      required this.like_count,
      required this.write_users_no,
      required this.login_users_no,
      required this.review_no,
      required this.review_content,
      required this.review_date,
      required this.users_name,
      required this.users_id,
      required this.users_nickname,
      required this.users_hp,
      required this.users_residence,
      required this.course_point_no,
      required this.course_latitude,
      required this.course_longitude,
      required this.course_order,
      required this.course_division,
      required this.group_num,
      required this.facilities_no,
      required this.convenient_facilities_type_no,
      required this.facilities_name,
      required this.facilities_latitude,
      required this.facilities_longitude,
      required this.facilities_memo
  });

  //map--> personVo형식으로 변환
  factory Course_list_Vo.fromJson(Map<String, dynamic> apiData) {
    return Course_list_Vo(
      course_no: apiData['course_no'],
      users_no: apiData['users_no'],
      course_favorites_no: apiData['course_favorites_no'],
      course_like_no: apiData['course_like_no'],
      course_name: apiData['course_name'],
      course_difficulty: apiData['course_difficulty'],
      course_length: apiData['course_length'],
      course_time: apiData['course_time'],
      course_hit: apiData['course_hit'],
      course_region: apiData['course_region'],
      course_date: apiData['course_date'],
      course_open: apiData['course_open'],
      course_introduce: apiData['course_introduce'],
      like_count: apiData['like_count'],
      write_users_no: apiData['write_users_no'],
      login_users_no: apiData['login_users_no'],
      review_no: apiData['review_no'],
      review_content: apiData['review_content'],
      review_date: apiData['review_date'],
      users_name: apiData['users_name'],
      users_id: apiData['users_id'],
      users_nickname: apiData['users_nickname'],
      users_hp: apiData['users_hp'],
      users_residence: apiData['users_residence'],
      course_point_no: apiData['course_point_no'],
      course_latitude: apiData['course_latitude'],
      course_longitude: apiData['course_longitude'],
      course_order: apiData['course_order'],
      course_division: apiData['course_division'],
      group_num: apiData['group_num'],
      facilities_no: apiData['facilities_no'],
      convenient_facilities_type_no: apiData['convenient_facilities_type_no'],
      facilities_name: apiData['facilities_name'],
      facilities_latitude: apiData['facilities_latitude'],
      facilities_longitude: apiData['facilities_longitude'],
      facilities_memo: apiData['facilities_memo'],
    );
  }

  //현재의 PersonVo를 Map형식으로 내보내줌
  Map<String, dynamic> toJson() {
    return {
      'course_no': course_no,
      'users_no': users_no,
      'course_favorites_no': course_favorites_no,
      'course_like_no': course_like_no,
      'course_name': course_name,
      'course_difficulty': course_difficulty,
      'course_length': course_length,
      'course_time': course_time,
      'course_hit': course_hit,
      'course_region': course_region,
      'course_date': course_date,
      'course_open': course_open,
      'course_introduce': course_introduce,
      'like_count': like_count,
      'write_users_no': write_users_no,
      'login_users_no': login_users_no,
      'review_no': review_no,
      'review_content': review_content,
      'review_date': review_date,
      'users_name': users_name,
      'users_id': users_id,
      'users_nickname': users_nickname,
      'users_hp': users_hp,
      'users_residence': users_residence,
      'course_point_no': course_point_no,
      'course_latitude': course_latitude,
      'course_longitude': course_longitude,
      'course_order': course_order,
      'course_division': course_division,
      'group_num': group_num,
      'facilities_no': facilities_no,
      'convenient_facilities_type_no': convenient_facilities_type_no,
      'facilities_name': facilities_name,
      'facilities_latitude': facilities_latitude,
      'facilities_longitude': facilities_longitude,
      'facilities_memo': facilities_memo,
    };
  }

  @override
  String toString() {
    return 'Course_list_Vo{course_no: $course_no, users_no: $users_no, course_favorites_no: $course_favorites_no, course_like_no: $course_like_no, course_name: $course_name, course_difficulty: $course_difficulty, course_length: $course_length, course_time: $course_time, course_hit: $course_hit, course_region: $course_region, course_date: $course_date, course_open: $course_open, course_introduce: $course_introduce, like_count: $like_count, write_users_no: $write_users_no, login_users_no: $login_users_no, review_no: $review_no, review_content: $review_content, review_date: $review_date, users_name: $users_name, users_id: $users_id, users_nickname: $users_nickname, users_hp: $users_hp, users_residence: $users_residence, course_point_no: $course_point_no, course_latitude: $course_latitude, course_longitude: $course_longitude, course_order: $course_order, course_division: $course_division, group_num: $group_num, facilities_no: $facilities_no, convenient_facilities_type_no: $convenient_facilities_type_no, facilities_name: $facilities_name, facilities_latitude: $facilities_latitude, facilities_longitude: $facilities_longitude, facilities_memo: $facilities_memo}';
  }
}
