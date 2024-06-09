import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'RecordVo.dart';
import 'Record_Point_Vo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class GpsMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _GpsMap(),
    );
  }
}

class _GpsMap extends StatefulWidget {
  const _GpsMap({Key? key}) : super(key: key);

  @override
  _GpsMapState createState() => _GpsMapState();
}

class _GpsMapState extends State<_GpsMap> {
  final storage = const FlutterSecureStorage();

  late GoogleMapController mapController;
  late Timer _timer;

  final LatLng _center = const LatLng(0, 0);
  String? lat;
  String? lng;
  Set<Marker> _markers = {};
  Set<Marker> _startmarker = {};
  bool _isRunning = false;
  bool _isPaused = false;
  int _seconds = 0;
  double _totalDistance = 0.0;
  double _caloriesBurned = 0.0;
  double _weight = 70.0; // 기본 체중 70kg으로 설정
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  BitmapDescriptor? _startMarkerIcon;
  BitmapDescriptor? _movingMarkerIcon;
  bool _isStarted = false; // 시작 상태를 저장하는 변수를 추가합니다.
  late double _currentZoomLevel = 15.0; // 기본 확대/축소 레벨을 설정합니다.
  int users_no = 0;

  List<Record_Point_Vo> recordPointList = [];



  @override
  void initState() {
    super.initState();
    _loadMarkerIcons();
    getGeoData();
    getUsersNo(storage);
  }

  //맵 불러오기
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.getZoomLevel().then((zoomLevel) {
      setState(() {
        _currentZoomLevel = zoomLevel; // 현재 확대/축소 레벨을 저장합니다.
      });
    });
    _updateMarker();
  }

  // Load custom marker icons
  void _loadMarkerIcons() async {
    _startMarkerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(10, 10)),
      'assets/images/redping.png',
    );
    _movingMarkerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/images/blueman.png',
    );
  }

  //위치 데이터 가져오기
  getGeoData() async {
    //동의여부
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('permissions are denied');
      }
    }
    //위치정보수집에 동의하면 현재 위치를 불러옴
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      lat = position.latitude.toString();
      lng = position.longitude.toString();
    });
    _updateMarker(); // 그 위치에 마커가 찍힌다
  }

  //users_no 가져오기
  getUsersNo(FlutterSecureStorage storage) async{
    print(await storage.read(key: 'UserNo'));
    users_no = int.tryParse(await storage.read(key: 'UserNo') ?? '') ?? 0;
  }

  void getPointList() {

    for (int i = 0; i < polylineCoordinates.length; i++) {
      // 각 좌표의 위도와 경도를 Record_Point_Vo로 변환하여 recordPointList 추가
      Record_Point_Vo pointVo = Record_Point_Vo(
        record_latitude: polylineCoordinates[i].latitude,
        record_longitude: polylineCoordinates[i].longitude,
      );
      recordPointList.add(pointVo);
    }

    // recordPointList 사용 가능
  }


  //마커 출발점에서 찍기
  void _startMarker(){
    setState(() {
      // 기존 마커들을 모두 지우고 새로운 마커 추가
      _startmarker.clear();
      BitmapDescriptor markerIcon = _startMarkerIcon!;
      if (_isRunning) {
        markerIcon = _movingMarkerIcon!;
      }
      _startmarker.add(
        Marker(
          markerId: const MarkerId('startLocation'),
          position: LatLng(double.parse(lat!), double.parse(lng!)),
          icon: markerIcon,
          infoWindow: const InfoWindow(
            title: 'Start Location',
          ),
        ),
      );
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(double.parse(lat!), double.parse(lng!)),
            zoom: 15.0,
          ),
        ),
      );
    });
  }

  //마커 업데이트
  void _updateMarker() {
    setState(() {
      // 기존 마커들을 모두 지우고 새로운 마커 추가
      _markers.clear();
      BitmapDescriptor markerIcon = _isRunning ? _movingMarkerIcon! : _startMarkerIcon!;
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(double.parse(lat!), double.parse(lng!)),
          icon: markerIcon,
          infoWindow: const InfoWindow(
            title: 'Current Location',
          ),
        ),
      );

      // startMarker가 있다면 추가
      if (_startmarker.isNotEmpty) {
        _markers.addAll(_startmarker);
      }

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(double.parse(lat!), double.parse(lng!)),
            zoom: _currentZoomLevel, // 현재 확대/축소 레벨을 적용합니다.
          ),
        ),
      );

      // 폴리라인 업데이트
      _updatePolyline();
    });
  }




  //폴리라인
  void _updatePolyline() {
    setState(() {
      // 새로운 폴리라인 추가
      _polylines.add(
        Polyline(
          polylineId: PolylineId('polyline'),
          color: Colors.blue,
          points: polylineCoordinates,
          width: 5,
        ),
      );
    });
  }



  //타이머 시작 --------------------------------------------------------------------------//
  // 타이머 시작
  void _startTimer() {
    // 타이머 시작 전 초기 위치 데이터 가져오기
    getGeoData();

    if (!_isRunning) {
      _isRunning = true;
      _seconds = 0;
      _totalDistance = 0.0;
      _caloriesBurned = 0.0;
      int locationUpdateCounter = 0;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (!_isPaused) {
          setState(() {
            _seconds++;
            _markers.clear();
            _isStarted = true; // 시작 후에는 true로 설정
          });

          locationUpdateCounter++;
          if (locationUpdateCounter >= 3) {
            locationUpdateCounter = 0;
            getGeoData(); // 위치 업데이트
            polylineCoordinates.add(LatLng(double.parse(lat!), double.parse(lng!)));
            _updatePolyline(); // 폴리라인 업데이트 추가
            _updateMarker(); // 마커 업데이트

            // 거리 및 칼로리 계산
            _totalDistance = _calculatePolylineLength(polylineCoordinates);
            _caloriesBurned = _calculateCalories(_totalDistance, _weight);
          }
        }
      });

      // 운동 시작 시 출발 지점 마커 설정
      _startMarker();
    }
  }





  void _stopTimer() {
    if (_isRunning) {
      _timer.cancel();
      _isRunning = false;
      _showSummaryDialog();
    }
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = true;
    });
  }

  void _resumeTimer() {
    setState(() {
      _isPaused = false;
    });
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  // 사용자의 현재 위치로 카메라를 이동하는 함수
  void _moveToCurrentLocation() async {
    // 사용자의 현재 위치를 얻어옵니다.
    Position position = await Geolocator.getCurrentPosition();
    // 현재 위치로 카메라를 이동합니다.
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        15.0,
      ),
    );
  }



  // 시간 계산
  String _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }


  //---------------------------------------------------------------------------//

  // 직선 거리 계산

  // 거리 계산 함수
  double _calculatePolylineLength(List<LatLng> points) {
    double totalDistance = 0.0;
    if (points.length > 1) {
      for (int i = 0; i < points.length - 1; i++) {
        totalDistance += _coordinateDistance(
          points[i].latitude,
          points[i].longitude,
          points[i + 1].latitude,
          points[i + 1].longitude,
        );
      }
    }
    return totalDistance;
  }

  double _coordinateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double p = 0.017453292519943295; // π / 180
    final double a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  // 칼로리 계산 함수
  double _calculateCalories(double distance, double weight) {
    // 단위 시간당 소모 칼로리 계산 예제
    // 일반적인 공식을 사용했습니다. 실제 운동 소모 칼로리는 운동 강도에 따라 다를 수 있습니다.
    double met = 8.0; // MET 값 (운동 강도) 예시
    double hours = _seconds / 3600; // 시간 변환
    return met * weight * hours;
  }


  void _showSummaryDialog() {
    // 선택된 라디오 버튼과 메모를 저장하는 변수
    String? selectedValue; // 라디오 버튼 값 저장 변수
    String? memo = ''; // 메모 저장 변수

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '오늘의 운동',
            style: TextStyle(
              fontFamily: "Cafe24Ssurround-Bold",
              fontSize: 20,
              color: Color(0xff16517b),
            ),
          ),
          content: SingleChildScrollView(
            physics: ClampingScrollPhysics(), // 스크롤 동작 설정
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min, // 최소한의 세로 공간 사용
                  crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                  children: [
                    Text(
                      '시간: ${_formatTime(_seconds)}',
                      style: TextStyle(fontFamily: "Cafe24Ssurround-Regular", fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '거리: ${_totalDistance} m',
                      style: TextStyle(fontFamily: "Cafe24Ssurround-Regular", fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '칼로리: ${_caloriesBurned.toStringAsFixed(2)} kcal',
                      style: TextStyle(fontFamily: "Cafe24Ssurround-Regular", fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: RadioListTile<String>(
                            title: Text('😊', style: TextStyle(fontSize: 25)),
                            value: '좋음',
                            groupValue: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                          ),
                        ),
                        Flexible(
                          child: RadioListTile<String>(
                            title: Text('🙂', style: TextStyle(fontSize: 25)),
                            value: '보통',
                            groupValue: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                          ),
                        ),
                        Flexible(
                          child: RadioListTile<String>(
                            title: Text('☹️', style: TextStyle(fontSize: 25)),
                            value: '나쁨',
                            groupValue: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        hintText: '메모',
                        hintStyle: TextStyle(fontFamily: "Cafe24Ssurround-Regular"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: Color(0xFFF2F2F2),
                      ),
                      onChanged: (value) {
                        // 입력된 텍스트를 memo 변수에 저장
                        memo = value;
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF068CD2)), // 배경색
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // 버튼의 둥근 모서리 설정
                  ),
                ),
              ),
              child: Text(
                '저장',
                style: TextStyle(
                  fontFamily: "Cafe24Ssurround-Regular",
                  fontSize: 18,
                  color: Colors.white, // 글자색을 흰색으로 설정
                ),
              ),
              onPressed: () {
                // 선택된 값과 메모를 recordVo에 저장
                RecordVo recordVo = RecordVo(
                  users_no: users_no,
                  course_no: 1,
                  record_time: _formatTime(_seconds),
                  record_length: double.parse(_totalDistance.toStringAsFixed(2)),
                  record_kcal: _caloriesBurned.floor(),
                  record_vibe: selectedValue ?? '',
                  record_memo: memo ?? '',
                );
                getPointList();
                recordDraw(recordVo, recordPointList);
                Navigator.pushNamed(context, "/");
              },
            ),
          ],
          elevation: 10.0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
        );
      },
    );

  }




  //////////////////////////////////////빌드빌드빌드빌드/////////////////////////////////////////
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('걸음걸음', style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xffffffff), fontFamily: "Cafe24Ssurround-Bold")),
          ),
          backgroundColor: Color(0xff068cd2),
        ),
        body: Column(
          children: [
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 15.0,
                ),
                markers: _markers,
                polylines: _polylines,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              color: Color(0xFFffffff),
              child: Column(
                children: [
                  Center(
                    child: Text("Lat: $lat, Lng: $lng"),
                  ),
                  Center(
                    child: Text(
                      '${_formatTime(_seconds)}',
                      style: TextStyle(fontSize: 24, fontFamily: "Cafe24Ssurround-Bold"),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${_totalDistance.toStringAsFixed(2)}m',
                      style: TextStyle(fontSize: 18, fontFamily:
                      "Cafe24Ssurround-Regular"),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${_caloriesBurned.toStringAsFixed(2)} kcal',
                      style: TextStyle(fontSize: 18, fontFamily:
                      "Cafe24Ssurround-Regular"),
                    ),
                  ),
                  Row(
                    children: [
                      if (!_isRunning) Expanded( // 시작 전에만 보이는 버튼
                        child: TextButton(
                            child: Icon(Icons.play_arrow, color: Colors.red),
                            onPressed: (){
                              _startTimer();
                              // 기존 폴리라인 삭제
                              _polylines.clear();
                            }
                        ),
                      ),
                      if (_isRunning) Expanded( // 시작 후에만 보이는 버튼
                        child: TextButton(
                          child: Icon(Icons.stop),
                          onPressed: _stopTimer,
                        ),
                      ),
                      if (_isRunning && !_isPaused) Expanded( // 시작 후에 일시정지하지 않은 경우만 보이는 버튼
                        child: TextButton(
                          child: Icon(Icons.pause, color: Colors.red),
                          onPressed: _pauseTimer,
                        ),
                      ),
                      if (_isRunning && _isPaused) Expanded( // 일시정지된 경우 보이는 버튼
                        child: TextButton(
                          child: Icon(Icons.play_arrow, color: Colors.red),
                          onPressed: _resumeTimer,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Future<void> recordDraw(RecordVo recordVo, recordPointList) async {

  print(recordPointList);
  print(recordVo);

  try {
    /*----요청처리-------------------*/
    //Dio 객체 생성 및 설정
    var dio = Dio();

    // 헤더설정:json으로 전송
    dio.options.headers['Content-Type'] = 'application/json';

    Map<String, dynamic> data = {
      'recordPointList': recordPointList,
      'recordVo': recordVo
    };

    // 서버 요청
    final response = await dio.post(
      'http://localhost:9020/api/walking/recorddraw',

      data: data,

    );

    /*----응답처리-------------------*/
    if (response.statusCode == 200) {
      //접속성공 200 이면
      print(response.data); // json->map 자동변경
    } else {
      //접속실패 404, 502등등 api서버 문제
      throw Exception('api 서버 문제');
    }
  } catch (e) {
    //예외 발생
    throw Exception('Failed to load person: $e');
  }
}
