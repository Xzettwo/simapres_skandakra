import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:simapres_skandakra/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../layout/button_nav_bar.dart';
import '../layout/header.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  double targetLatitude = 0;
  double targetLongitude = 0;
  double targetDistance = 0;

  bool isWithinRange = false;
  bool isAbsent = false;
  bool hasPulang = false;
  bool isLoading = true;

  String statusMessage = 'Memeriksa lokasi...';
  String additionalMessage = '';

  final int morningStart = 10;
  final int afternoonStart = 12;
  final int eveningEnd = 20;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _fetchLocationData();
    _checkLocation();
    _updateMessage();
  }

  Future<void> _fetchLocationData() async {
    try {
      final response = await http
          .get(Uri.parse('https://presensi.smkn2kra.sch.id/api/lokasi'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          targetLatitude = double.parse(data['latitude'].toString());
          targetLongitude = double.parse(data['longtitude'].toString());
          targetDistance = double.parse(data['jangkauan'].toString());
          isLoading = false;
        });
      } else {
        setState(() {
          statusMessage = 'Gagal memuat lokasi. Server error.';
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = 'Error mengambil data lokasi: $e';
      });
    }
  }

  Future<void> _checkLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          statusMessage =
              'Layanan lokasi tidak aktif. \nAktifkan GPS dan coba lagi.';
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            statusMessage =
                'Izin lokasi ditolak. \nBerikan izin untuk melanjutkan.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          statusMessage =
              'Izin lokasi ditolak secara permanen. \nPerbarui izin di pengaturan.';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double distanceInMeters = Geolocator.distanceBetween(
        targetLatitude,
        targetLongitude,
        position.latitude,
        position.longitude,
      );

      setState(() {
        isWithinRange = distanceInMeters <= targetDistance;
        statusMessage = isWithinRange
            ? 'Kamu sudah berada dalam \njangkauan! Presensi sekarang :D'
            : 'Kamu tidak berada dalam \njangkauan sekolah ;(';
      });
    } catch (e) {
      setState(() {
        statusMessage = 'Gagal mendapatkan lokasi. Error: $e';
      });
    }
  }

  void _updateMessage() {
    final now = DateTime.now();

    if (isAbsent) {
      additionalMessage =
          'Semangat belajar dan jangan lupa \nabsen pulang nanti :D';
    } else if (now.hour < morningStart) {
      additionalMessage =
          'Duhhh kamu belum presensii..\nBuruan masuk!! Nanti telat!';
    } else if (now.hour >= afternoonStart && now.hour < eveningEnd) {
      additionalMessage = 'Yuuk waktunya pulang!';
    } else {
      additionalMessage = 'Waktunya di luar jam sekolah.';
    }
  }

  Future<void> _doAbsen2() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await _doAbsen();
    }
  }

  Future<void> _doAbsen() async {
    final String username =
        Provider.of<UserProvider>(context, listen: false).getUser()!.username;
    final response = await http.post(
      Uri.parse('https://presensi.smkn2kra.sch.id/api'),
      body: {'username': username},
    );
    final pesan = json.decode(response.body);

    setState(() {
      isAbsent = true;
      additionalMessage =
          'Semangat belajar dan jangan lupa \nabsen pulang nanti :D';
    });
    _showDialog(pesan['message']);
  }

  Future<void> _doPulang() async {
    final String username =
        Provider.of<UserProvider>(context, listen: false).getUser()!.username;
    final response = await http.put(
      Uri.parse('https://presensi.smkn2kra.sch.id/api'),
      body: {'username': username},
    );
    final pesan = json.decode(response.body);
    setState(() {
      hasPulang = true;
    });
    _showDialog(pesan['message']);
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informasi'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  int _currentIndex = 2;
  final List<String> _routes = [
    '/absentPage',
    '/previewPage',
    '/landingPage',
    '/achivementPage',
    '/violationPage',
  ];
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            clipBehavior: Clip.none, // Pastikan konten tidak terpotong
            children: [
              const CustomHeader(),

              // Status GPS dengan gambar dan teks
              // GPS Icon
              Positioned(
                top: screenHeight * 0.31,
                left: screenWidth * 0.09,
                child: Image.asset(
                  isWithinRange
                      ? 'assets/images/gps-on.png'
                      : 'assets/images/gps-off.png',
                  width: screenWidth * 0.21,
                  height: screenWidth * 0.21,
                  color: const Color(0xFF4A55A2),
                ),
              ),
              // handphone gps
              Positioned(
                top: screenHeight * 0.36,
                left: screenWidth * 0.31,
                child: Image.asset(
                  'assets/images/phone-gps.png',
                  width: screenWidth * 0.08,
                  height: screenWidth * 0.08,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              // Teks GPS
              Positioned(
                top: screenHeight * 0.32, // Sesuaikan posisi teks GPS
                left: screenHeight * 0.15, // Sesuaikan posisi teks GPS
                child: Text(
                  'GPS',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.05,
                    color: const Color(0xFF4A55A2),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              // Status GPS
              Positioned(
                top: screenHeight * 0.36,
                left: screenHeight * 0.19,
                child: Text(
                  statusMessage,
                  style: GoogleFonts.openSans(
                    fontSize: screenWidth * 0.03,
                    color: Colors.black54,
                  ),
                ),
              ),

              // Keterangan presensi
              Positioned(
                top: screenHeight * 0.47,
                left: screenWidth * 0,
                right: screenWidth * 0,
                child: Text(
                  isAbsent
                      ? (hasPulang ? 'SUDAH PRESENSI PULANG' : 'SUDAH PRESENSI')
                      : 'BELUM PRESENSI',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.07,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Ikon status
              Positioned(
                top: screenHeight * 0.53,
                left: screenWidth * 0,
                right: screenWidth * 0,
                child: Image.asset(
                  isAbsent
                      ? 'assets/images/happy.png'
                      : 'assets/images/sad.png',
                  width: screenWidth * 0.25,
                  height: screenWidth * 0.25,
                  color: const Color(0xFF4A55A2),
                ),
              ),

              // additional Message
              Positioned(
                top: screenHeight * 0.67,
                left: screenWidth * 0,
                right: screenWidth * 0,
                child: Text(
                  additionalMessage,
                  style: GoogleFonts.openSans(
                    fontSize: screenWidth * 0.03,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Tombol Presensi
              if (isWithinRange &&
                  !isAbsent &&
                  DateTime.now().hour < morningStart)
                Positioned(
                  bottom: screenHeight * 0.1,
                  left: screenWidth * 0.25,
                  right: screenWidth * 0.25,
                  child: SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.05,
                    child: ElevatedButton(
                      onPressed: _doAbsen2,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A55A2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        'Masuk',
                        style: GoogleFonts.nunito(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

              if (isWithinRange &&
                  // isAbsent &&
                  !hasPulang &&
                  DateTime.now().hour >= afternoonStart &&
                  DateTime.now().hour < eveningEnd)
                Positioned(
                  bottom: 80,
                  left: 50,
                  right: 50,
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        _doPulang();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A55A2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        'Pulang',
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // bottom nav
          bottomNavigationBar: CustomNavbar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index; // Update index
              });

              // Delay navigasi untuk memastikan UI selesai merender
              Future.delayed(const Duration(milliseconds: 300), () {
                Navigator.pushNamed(context, _routes[index]);
              });
            },
          ),
        );
      },
    );
  }
}