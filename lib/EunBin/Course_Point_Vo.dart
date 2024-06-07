class Course_Point_Vo {
  //필드
  int course_no;

  // 코스 위도 경도
  double course_latitude;
  double course_longitude;
  int course_order;
  String course_division;
  //생성자
  Course_Point_Vo({
    required this.course_no,
    required this.course_latitude,
    required this.course_longitude,
    required this.course_order,
    required this.course_division,
  });

  //map--> personVo형식으로 변환
  factory Course_Point_Vo.fromJson(Map<String, dynamic> apiData) {
    return Course_Point_Vo(
      course_no: apiData['course_no'],
      course_latitude: apiData['course_latitude'],
      course_longitude: apiData['course_longitude'],
      course_order: apiData['course_order'],
      course_division: apiData['course_division'],
    );
  }

  //현재의 PersonVo를 Map형식으로 내보내줌
  Map<String, dynamic> toJson() {
    return {
      'course_no': course_no,
      'course_latitude': course_latitude,
      'course_longitude': course_longitude,
      'course_order': course_order,
      'course_division': course_division,
    };
  }

  @override
  String toString() {
    return 'Course_Point_Vo{course_no: $course_no, course_latitude: $course_latitude, course_longitude: $course_longitude, course_order: $course_order, course_division: $course_division}';
  }
}
