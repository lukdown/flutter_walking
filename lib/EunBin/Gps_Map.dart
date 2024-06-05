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

  getGeoData() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('permissions are denied');
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      lat = position.latitude.toString();
      lng = position.longitude.toString();
    });
    _updateMarker();
  }

  @override
  void initState() {
    super.initState();
    getGeoData();
  }

  void _updateMarker() {
    setState(() {
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
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _updateMarker();
  }

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

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('걸음걸음'),
          backgroundColor: Colors.green[700],
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
                      'Timer: ${_formatTime(_seconds)}',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      child: const Text("타이머 시작"),
                      onPressed: _startTimer,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      child: const Text("타이머 정지"),
                      onPressed: _stopTimer,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      child: const Text("타이머 일시정지"),
                      onPressed: _pauseTimer,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      child: const Text("타이머 재개"),
                      onPressed: _resumeTimer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
