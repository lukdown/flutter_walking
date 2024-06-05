import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GpsMap());
}

class GpsMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _GpsMap(),
    );
  }
}

class _GpsMap extends StatefulWidget {
  const _GpsMap({Key? key}) : super(key: key);

  @override
  _GpsMapState createState() => _GpsMapState();
}

class _GpsMapState extends State<_GpsMap> {
  late GoogleMapController mapController;
  late Timer _timer;

  final LatLng _center = const LatLng(0, 0);
  String? lat;
  String? lng;
  Set<Marker> _markers = {};
  bool _isRunning = false;
  bool _isPaused = false;
  int _seconds = 0;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};

  //저장 전
  String? timeElapsed;
  String? distanceTraveled;
  String? calorieBurned;

  @override
  void initState() {
    super.initState();
    getGeoData();
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

  //마커 찍기
  void _updateMarker() {
    setState(() {
      // 좌표 추가


      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(double.parse(lat!), double.parse(lng!)),
          infoWindow: const InfoWindow(
            title: 'Current Location',
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

      // 폴리라인 업데이트
      _updatePolyline();
    });
  }

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


  //맵 불러오기
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _updateMarker();
  }


  //타이머 시작 --------------------------------------------------------------------------//
  void _startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _seconds = 0;
      int locationUpdateCounter = 0;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (!_isPaused) {
          setState(() {
            _seconds++;
          });

          locationUpdateCounter++;
          if (locationUpdateCounter >= 3) {
            locationUpdateCounter = 0;
            getGeoData(); // 위치 업데이트
            polylineCoordinates.add(LatLng(double.parse(lat!), double.parse(lng!)));
            _updatePolyline(); // 폴리라인 업데이트 추가
          }
        }
      });
    }
  }



  void _stopTimer() {
    if (_isRunning) {
      _timer.cancel();
      _isRunning = false;
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

  //시간 계산
  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  //---------------------------------------------------------------------------//


  // 직선 거리 계산
  double _calculatePolylineLength(List<LatLng> points) {
    double totalDistance = 0.0;

    for (int i = 0; i < points.length - 1; i++) {
      double startLatitude = points[i].latitude;
      double startLongitude = points[i].longitude;
      double endLatitude = points[i + 1].latitude;
      double endLongitude = points[i + 1].longitude;

      double distance = _coordinateDistance(
          startLatitude, startLongitude, endLatitude, endLongitude);

      totalDistance += distance;
    }

    return totalDistance;
  }

// 두 지점 간의 직선 거리 계산
  double _coordinateDistance(double startLat, double startLng, double endLat, double endLng) {
    const double radius = 6371000; // 지구 반지름 (미터)

    double lat1 = startLat * pi / 180.0;
    double lon1 = startLng * pi / 180.0;
    double lat2 = endLat * pi / 180.0;
    double lon2 = endLng * pi / 180.0;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radius * c; // 직선 거리 반환
  }







  //////////////////////////////////////빌드빌드빌드빌드/////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('걸음걸음', style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xffffffff))),
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
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child: Text("Lat: $lat, Lng: $lng"),
                  ),
                  Center(
                    child: Text(
                      '${_calculatePolylineLength(polylineCoordinates).toStringAsFixed(2)}m',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${_formatTime(_seconds)}',
                      style: TextStyle(fontSize: 24),
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
                          onPressed: (){
                            _pauseTimer();
                          }
                        ),
                      ),
                      if (_isPaused && _isRunning) Expanded( // 일시정지 후에만 보이는 버튼
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
