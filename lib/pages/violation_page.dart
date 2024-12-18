import 'dart:convert';

import '../layout/button_nav_bar.dart';
import '../layout/header.dart';
import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ViolationPage extends StatefulWidget {
  const ViolationPage({Key? key}) : super(key: key);

  @override
  _ViolationPageState createState() => _ViolationPageState();
}

Future fetchDataFromAPI(BuildContext context) async {
  List<dynamic> apiPelanggaran = [];
  dynamic pelanggaranFinal = {"pelanggaran": []};

  final username =
      Provider.of<UserProvider>(context, listen: false).userData!.username;

  await http
      .get(Uri.parse('https://presensi.smkn2kra.sch.id/api?username=$username'))
      .then((value) {
    dynamic apiResponse = json.decode(value.body.toString());
    List<dynamic> dataArray =
        apiResponse['pelanggaran']; // Mengambil data pelanggaran

    for (var row in dataArray) {
      apiPelanggaran.add({
        "pelanggaran": row["pelanggaran"], // Ambil data pelanggaran
        "keterangan": row["keterangan"], // Ambil data keterangan
        "poin": row["poin"], // Ambil data poin
        "tanggal": row["tanggal"], // Ambil data tanggal
      });
    }
    pelanggaranFinal['pelanggaran'] = apiPelanggaran;
  });

  return pelanggaranFinal;
}

class _ViolationPageState extends State<ViolationPage> {
  late Future<dynamic> pelanggaranData;
  int _currentIndex = 4;
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
    pelanggaranData = fetchDataFromAPI(
        context); // Call API untuk mendapatkan data pelanggaran
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
          const CustomHeader(), // Header

          // Card Pelanggaran
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.32), // Jarak header disesuaikan
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
                                  'Pelanggaran',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth *
                                        0.07, // Ukuran font disesuaikan
                                  ),
                                ),
                                SizedBox(
                                    height: screenHeight *
                                        0.05), // Jarak disesuaikan

                                // FutureBuilder untuk menampilkan data pelanggaran
                                FutureBuilder(
                                  future: pelanggaranData,
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
                                        snapshot.data['pelanggaran'] ?? [];
                                    if (data.isEmpty) {
                                      return Center(
                                        child: Text(
                                          'Belum ada pelanggaran',
                                          style: GoogleFonts.openSans(
                                              fontSize: screenWidth * 0.04,
                                              fontStyle: FontStyle.italic),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Tanggal, Pelanggaran, Poin Header
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: screenHeight * 0.02),
                                          child: Row(
                                            children: [
                                              _buildTableHeader('Tanggal'),
                                              _buildTableHeader('Pelanggaran'),
                                              _buildTableHeader('Poin'),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                            thickness: 1,
                                            color: Colors.black26),
                                        ...data.map<Widget>((item) {
                                          String tanggal = item['tanggal'] ??
                                              'Tanggal tidak tersedia';
                                          String pelanggaran =
                                              item['pelanggaran'] ??
                                                  'Pelanggaran tidak tersedia';
                                          String poin =
                                              item['poin']?.toString() ??
                                                  'Poin tidak tersedia';

                                          return Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        screenHeight * 0.02),
                                                child: Row(
                                                  children: [
                                                    _buildTableContent(
                                                        DateFormat(
                                                                'd MMMM yyyy')
                                                            .format(
                                                                DateTime.parse(
                                                                    tanggal))),
                                                    _buildTableContent(
                                                        pelanggaran),
                                                    _buildTableContent(poin),
                                                  ],
                                                ),
                                              ),
                                              // Divider for all except the last item
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

  // Helper function to build table headers
  Widget _buildTableHeader(String text) {
    return Expanded(
      flex: 2,
      child: Text(
        text,
        style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Helper function to build table content
  Widget _buildTableContent(String text) {
    return Expanded(
      flex: 2,
      child: Text(
        text,
        style: GoogleFonts.openSans(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }
}
