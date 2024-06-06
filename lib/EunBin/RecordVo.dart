class RecordVo {

  //필드
  int? users_no;

  int record_no;
  int course_no;
  String record_date;
  String record_time;
  double record_length;
  int record_kcal;
  String record_vibe;
  String record_memo;


  int record_point_no;
  double record_latitude;
  double record_longitude;
  String record_division;
  String record_order;




  //생성자
  RecordVo({
    required this.users_no,
    required this.record_no,
    required this.course_no,
    required this.record_date,
    required this.record_time,
    required this.record_length,
    required this.record_kcal,
    required this.record_vibe,
    required this.record_memo,
    required this.record_point_no,
    required this.record_latitude,
    required this.record_longitude,
    required this.record_division,
    required this.record_order,
  });

  //map--> personVo형식으로 변환
  factory RecordVo.fromJson(Map<String, dynamic> apiData) {
    return RecordVo(
      users_no: apiData['users_no'],
      record_no: apiData['record_no'],
      course_no: apiData['course_no'],
      record_date: apiData['record_date'],
      record_time: apiData['record_time'],
      record_length: apiData['record_length'],
      record_kcal: apiData['record_kcal'],
      record_vibe: apiData['record_vibe'],
      record_memo: apiData['record_memo'],
      record_point_no: apiData['record_point_no'],
      record_latitude: apiData['record_latitude'],
      record_longitude: apiData['record_longitude'],
      record_division: apiData['record_division'],
      record_order: apiData['record_order'],
    );
  }

  //현재의 PersonVo를 Map형식으로 내보내줌
  Map<String, dynamic> toJson() {
    return {
      'users_no': users_no,
      'record_no': record_no,
      'course_no': course_no,
      'record_date': record_date,
      'record_time': record_time,
      'record_length': record_length,
      'record_kcal': record_kcal,
      'record_vibe': record_vibe,
      'record_memo': record_memo,
      'record_point_no': record_point_no,
      'record_latitude': record_latitude,
      'record_longitude': record_longitude,
      'record_division': record_division,
      'record_order': record_order,
    };
  }

  @override
  String toString() {
    return 'RecordVo{users_no: $users_no, record_no: $record_no, course_no: $course_no, record_date: $record_date, record_time: $record_time, record_length: $record_length, record_kcal: $record_kcal, record_vibe: $record_vibe, record_memo: $record_memo, record_point_no: $record_point_no, record_latitude: $record_latitude, record_longitude: $record_longitude, record_division: $record_division, record_order: $record_order}';
  }
}
