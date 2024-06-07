class RecordVo {

  //필드
  int record_no;
  int record_point_no;
  double record_latitude;
  double record_longitude;
  String record_order;




  //생성자
  RecordVo({
    required this.record_no,
    required this.record_point_no,
    required this.record_latitude,
    required this.record_longitude,
    required this.record_order,
  });

  //map--> personVo형식으로 변환
  factory RecordVo.fromJson(Map<String, dynamic> apiData) {
    return RecordVo(
      record_no: apiData['record_no'],
      record_point_no: apiData['record_point_no'],
      record_latitude: apiData['record_latitude'],
      record_longitude: apiData['record_longitude'],
      record_order: apiData['record_order'],
    );
  }

  //현재의 PersonVo를 Map형식으로 내보내줌
  Map<String, dynamic> toJson() {
    return {
      'record_no': record_no,
      'record_point_no': record_point_no,
      'record_latitude': record_latitude,
      'record_longitude': record_longitude,
      'record_order': record_order,
    };
  }

  @override
  String toString() {
    return 'RecordVo{record_no: $record_no, record_point_no: $record_point_no, record_latitude: $record_latitude, record_longitude: $record_longitude, record_order: $record_order}';
  }
}
