import 'dart:convert';
import '../layout/button_nav_bar.dart';
import '../layout/header.dart';
import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AbsentPage extends StatefulWidget {
  const AbsentPage({Key? key}) : super(key: key);

  @override
  _AbsentPageState createState() => _AbsentPageState();
}

Future fetchDataFromAPI(BuildContext context) async {
  List<dynamic> apiIzin = [];
  dynamic izinFinal = {"izin": []};

  // Get the username from the provider
  final username =
      Provider.of<UserProvider>(context, listen: false).userData!.username;

  // Fetch data from API
  await http
      .get(Uri.parse('https://presensi.smkn2kra.sch.id/api?username=$username'))
      .then((value) {
    dynamic apiResponse = json.decode(value.body.toString());
    List<dynamic> dataArray = apiResponse['izin'];

    for (var row in dataArray) {
      apiIzin.add({
        "keterangan": row["keterangan"],
        "alasan": row["alasan"],
        "tanggal": row["tanggal"],
      });
    }
    izinFinal['izin'] = apiIzin;
  });

  return izinFinal;
}

class _AbsentPageState extends State<AbsentPage> {
  late Future<dynamic> izinData;
  int _currentIndex = 0;
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
    izinData =
        fetchDataFromAPI(context); // Call the API when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Header Section
          const CustomHeader(),

          // Card izin
          Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.32, // Jarak dari header disesuaikan
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                    EdgeInsets.all(screenWidth * 0.05), // Responsif padding
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
                                screenWidth * 0.04), // Responsif padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Izin Tidak Masuk',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth *
                                        0.07, // Responsif fontSize
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        screenHeight * 0.05), // Responsif space
                                FutureBuilder(
                                  future: izinData,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    final data = snapshot.data['izin'] ?? [];
                                    if (data.isEmpty) {
                                      return Center(
                                        child: Text(
                                          'Belum ada izin',
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
                                              vertical: screenHeight *
                                                  0.02), // Responsif
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Tanggal',
                                                  style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Status',
                                                  style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  'Alasan',
                                                  style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: screenHeight *
                                                        0.02), // Responsif padding
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        DateFormat('d MMM yyyy')
                                                            .format(DateTime
                                                                .parse(item[
                                                                    'tanggal'])),
                                                        style: GoogleFonts.openSans(
                                                            fontSize: screenWidth *
                                                                0.04), // Responsif font
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        item['keterangan'] ==
                                                                'I'
                                                            ? 'Izin'
                                                            : item['keterangan'] ==
                                                                    'S'
                                                                ? 'Sakit'
                                                                : 'Alpha',
                                                        style: GoogleFonts
                                                            .openSans(
                                                          fontSize: screenWidth *
                                                              0.04, // Responsif font
                                                          color: item['keterangan'] ==
                                                                  'I'
                                                              ? Colors.green
                                                              : item['keterangan'] ==
                                                                      'S'
                                                                  ? Colors.blue
                                                                  : Colors.red,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        item['alasan'],
                                                        style: GoogleFonts
                                                            .openSans(
                                                                fontSize:
                                                                    screenWidth *
                                                                        0.04, // Responsif font
                                                                color: Colors
                                                                    .black54),
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
  }
}
