class Record_Point_Vo {

  //필드
  double record_latitude;
  double record_longitude;




  //생성자
  Record_Point_Vo({
    required this.record_latitude,
    required this.record_longitude,

  });

  //map--> personVo형식으로 변환
  factory Record_Point_Vo.fromJson(Map<String, dynamic> apiData) {
    return Record_Point_Vo(
      record_latitude: apiData['record_latitude'],
      record_longitude: apiData['record_longitude'],
    );
  }

  //현재의 PersonVo를 Map형식으로 내보내줌
  Map<String, dynamic> toJson() {
    return {
      'record_latitude': record_latitude,
      'record_longitude': record_longitude,
    };
  }

  @override
  String toString() {
    return 'Record_Point_Vo{record_latitude: $record_latitude, record_longitude: $record_longitude}';
  }
}
