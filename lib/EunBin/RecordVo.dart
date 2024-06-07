import 'Record_Point_Vo.dart';
class RecordVo {

  //필드
  int? users_no;
  int course_no;
  String record_time;
  double record_length;
  int record_kcal;
  String record_vibe;
  String record_memo;

  //생성자
  RecordVo({
    required this.users_no,
    required this.course_no,
    required this.record_time,
    required this.record_length,
    required this.record_kcal,
    required this.record_vibe,
    required this.record_memo,
  });

  //map--> personVo형식으로 변환
  factory RecordVo.fromJson(Map<String, dynamic> apiData) {
    return RecordVo(
      users_no: apiData['users_no'],
      course_no: apiData['course_no'],
      record_time: apiData['record_time'],
      record_length: apiData['record_length'],
      record_kcal: apiData['record_kcal'],
      record_vibe: apiData['record_vibe'],
      record_memo: apiData['record_memo'],
    );
  }

  //현재의 PersonVo를 Map형식으로 내보내줌
  Map<String, dynamic> toJson() {
    return {
      'users_no': users_no,
      'course_no': course_no,
      'record_time': record_time,
      'record_length': record_length,
      'record_kcal': record_kcal,
      'record_vibe': record_vibe,
      'record_memo': record_memo,
    };
  }

  @override
  String toString() {
    return 'RecordVo{users_no: $users_no, course_no: $course_no, record_time: $record_time, record_length: $record_length, record_kcal: $record_kcal, record_vibe: $record_vibe, record_memo: $record_memo}';
  }
}
