import 'package:simapres_skandakra/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../layout/button_nav_bar.dart';
import '../layout/header.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key}) : super(key: key);

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

Future fetchDataFromAPI(BuildContext context, String selectedMonth) async {
  List<dynamic> apiPresensi = [];
  dynamic presensiFinal = {"presensi": []};

  final username =
      Provider.of<UserProvider>(context, listen: false).userData?.username;

  if (username == null) {
    return {"presensi": []}; // Return empty data if username is null
  }

  // Mengambil data dari API dengan parameter bulan yang dipilih
  await http
      .get(Uri.parse(
          'https://presensi.smkn2kra.sch.id/api/report?username=$username&month=$selectedMonth'))
      .then((value) {
    dynamic apiResponse = json.decode(value.body.toString());
    List<dynamic> dataArray = apiResponse['data'] ?? [];

    for (var row in dataArray) {
      // Menyimpan data tanggal, masuk, dan pulang
      apiPresensi.add({
        "tanggal": row["tanggal"] ?? 'Tanggal tidak tersedia',
        "masuk": row["masuk"] ?? 'Masuk tidak tersedia',
        "pulang": row["pulang"] ?? 'Pulang tidak tersedia',
      });
    }
    presensiFinal['presensi'] = apiPresensi;
  });

  return presensiFinal;
}

class _PreviewPageState extends State<PreviewPage> {
  late Future<dynamic> presensiData;
  int _currentIndex = 1;
  final List<String> _routes = [
    '/absentPage', // Index 0
    '/previewPage', // Index 1
    '/landingPage', // Index 2
    '/achivementPage', // Index 3
    '/violationPage', // Index 4
  ];

  String selectedMonth = DateFormat('yyyy-MM').format(DateTime.now());
  String displayMonth = DateFormat('MMMM yyyy', 'id_ID').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    presensiData = fetchDataFromAPI(context, selectedMonth);
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
          // Header Section
          const CustomHeader(),

          // Scrollable Content (Card)
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.32), // Memberikan jarak dari header
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                    EdgeInsets.all(screenWidth * 0.05), // Padding disesuaikan
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
                                  'Presensi bulan \n$displayMonth',
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
                                  future: presensiData,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    final data =
                                        snapshot.data['presensi'] ?? [];
                                    if (data.isEmpty) {
                                      return Center(
                                        child: Text(
                                          'Belum ada presensi',
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
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: screenHeight * 0.02),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Tanggal',
                                                  style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          screenWidth * 0.045),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Masuk',
                                                  style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          screenWidth * 0.045),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Pulang',
                                                  style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          screenWidth * 0.045),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                            thickness: 1,
                                            color: Colors.black26),
                                        ...data.map<Widget>((item) {
                                          String tanggal = item['tanggal'] ??
                                              'Tanggal tidak tersedia';
                                          String masuk = item['masuk'] ??
                                              'Masuk tidak tersedia';
                                          String pulang = item['pulang'] ??
                                              'Pulang tidak tersedia';

                                          return Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        screenHeight * 0.02),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        tanggal,
                                                        style: GoogleFonts
                                                            .openSans(
                                                                fontSize:
                                                                    screenWidth *
                                                                        0.04),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        masuk,
                                                        style: GoogleFonts
                                                            .openSans(
                                                                fontSize:
                                                                    screenWidth *
                                                                        0.04),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        pulang,
                                                        style: GoogleFonts
                                                            .openSans(
                                                                fontSize:
                                                                    screenWidth *
                                                                        0.04),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (data.indexOf(item) !=
                                                  data.length - 1)
                                                const Divider(
                                                    thickness: 1,
                                                    color: Colors.black26),
                                            ],
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
          )
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
  }
}
