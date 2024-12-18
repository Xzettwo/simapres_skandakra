import 'dart:convert';

import 'package:simapres_skandakra/layout/button_nav_bar.dart';
import 'package:simapres_skandakra/layout/header.dart';
import 'package:simapres_skandakra/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AchievementPage extends StatefulWidget {
  const AchievementPage({Key? key}) : super(key: key);

  @override
  _AchievementPageState createState() => _AchievementPageState();
}

Future fetchDataFromAPI(BuildContext context) async {
  List<dynamic> apiPrestasi = [];
  dynamic prestasiFinal = {"prestasi": []};

  final username =
      Provider.of<UserProvider>(context, listen: false).userData!.username;

  await http
      .get(Uri.parse('https://presensi.smkn2kra.sch.id/api?username=$username'))
      .then((value) {
    dynamic apiResponse = json.decode(value.body.toString());
    List<dynamic> dataArray = apiResponse['prestasi'];

    for (var row in dataArray) {
      apiPrestasi.add({
        "nama": row["nama"],
        "keterangan": row["keterangan"],
        "juara": row["juara"],
        "tanggal": row["tanggal"],
      });
    }
    prestasiFinal['prestasi'] = apiPrestasi;
  });

  return prestasiFinal;
}

class _AchievementPageState extends State<AchievementPage> {
  late Future<dynamic> prestasiData;
  int _currentIndex = 3;
  final List<String> _routes = [
    '/absentPage', // Index 0
    '/previewPage', // Index 1
    '/landingPage', // Index 2
    '/achivementPage', // Index 3
    '/violationPage', // Index 4
  ];

  @override
  void initState() {
    super.initState();
    prestasiData = fetchDataFromAPI(context);
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const CustomHeader(), // Custom header layout

          // Card Prestasi
          Padding(
            padding:
                EdgeInsets.only(top: screenHeight * 0.32), // Jarak dari header
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(screenWidth *
                    0.05), // Padding disesuaikan dengan lebar layar
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Stack(
                        children: [
                          // Background layer 1
                          Positioned(
                            top: -screenHeight * 0.1,
                            left: screenWidth * 0.7,
                            child: Transform.rotate(
                              angle: 15.78,
                              child: Container(
                                width: screenWidth * 0.45, // Responsif ukuran
                                height: screenHeight * 0.2, // Responsif ukuran
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7895CB),
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 15,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Background layer 2
                          Positioned(
                            top: -screenHeight * 0.15,
                            left: screenWidth * 0.75,
                            child: Transform.rotate(
                              angle: 24.81,
                              child: Container(
                                width: screenWidth * 0.45, // Responsif ukuran
                                height: screenHeight * 0.2, // Responsif ukuran
                                decoration: BoxDecoration(
                                  color: const Color(0xFFA0BFE0),
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 15,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Content inside Card
                          Padding(
                            padding: EdgeInsets.all(
                                screenWidth * 0.04), // Padding disesuaikan
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prestasi',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth *
                                        0.07, // Ukuran teks disesuaikan
                                  ),
                                ),
                                SizedBox(
                                    height: screenHeight *
                                        0.05), // Jarak antar elemen disesuaikan

                                // FutureBuilder to display fetched data
                                FutureBuilder(
                                  future: prestasiData,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    final data = snapshot.data['prestasi'];
                                    if (data == null || data.isEmpty) {
                                      return Center(
                                        child: Text(
                                          'Belum ada prestasi',
                                          style: GoogleFonts.openSans(
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // Header
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: screenWidth * 0.02),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                'Tanggal',
                                                style: GoogleFonts.openSans(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        screenWidth * 0.04),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                'Prestasi',
                                                style: GoogleFonts.openSans(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        screenWidth * 0.04),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                'Keterangan',
                                                style: GoogleFonts.openSans(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        screenWidth * 0.04),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                'Juara',
                                                style: GoogleFonts.openSans(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        screenWidth * 0.04),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                            thickness: 1,
                                            color: Colors
                                                .black26), // Divider after header

                                        // Data Rows
                                        ...data.map<Widget>((item) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: screenWidth * 0.02),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                // Kolom Tanggal
                                                Expanded(
                                                  child: Text(
                                                    DateFormat('d MMMM yyyy')
                                                        .format(DateTime.parse(
                                                            item['tanggal'])),
                                                    style: GoogleFonts.openSans(
                                                        fontSize:
                                                            screenWidth * 0.035),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                // Kolom Prestasi
                                                Expanded(
                                                  child: Text(
                                                    item['nama'],
                                                    style: GoogleFonts.openSans(
                                                        fontSize:
                                                            screenWidth * 0.035),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                // Kolom Keterangan
                                                Expanded(
                                                  child: Text(
                                                    item['keterangan'],
                                                    style: GoogleFonts.openSans(
                                                        fontSize:
                                                            screenWidth * 0.035),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                // Kolom Juara
                                                Expanded(
                                                  child: Text(
                                                    item['juara'],
                                                    style: GoogleFonts.openSans(
                                                        fontSize:
                                                            screenWidth * 0.035),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
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
  }
}
