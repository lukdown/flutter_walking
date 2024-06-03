class UserListVo {
  int users_no;
  String users_id;
  String users_pw;
  String users_nickname;
  String users_saveName;
  int users_login_type;

  UserListVo({
    required this.users_no,
    required this.users_id,
    required this.users_pw,
    required this.users_nickname,
    required this.users_saveName,
    required this.users_login_type
  });

  //map--> personVo형식으로 변환
  factory UserListVo.fromJson(Map<String, dynamic> apiData) {//map을 00로 빼준다.
    print(apiData);
    return UserListVo(
      users_no: apiData['users_no'],
      users_id: apiData['users_id'],
      users_pw: apiData['users_pw'],
      users_nickname: apiData['users_nickname'],
      users_saveName: apiData['users_saveName'],
      users_login_type: apiData['users_login_type']
    );
  }

  //현재의 PersonVo를 Map형식으로 내보내줌
  Map<String, dynamic> toJson() {
    return {
      'users_no': users_no,
      'users_id': users_id,
      'users_pw': users_pw,
      'users_nickname': users_nickname,
      'users_saveName': users_saveName,
      'users_login_type': users_login_type
    };
  }
}