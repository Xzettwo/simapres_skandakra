import '../pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Pastikan mengimpor provider

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Stack(
          children: [
            // Background Container
            Positioned(
              top: -screenHeight * 0.12, // Sesuaikan proporsi atas
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.37, // Sesuaikan proporsi tinggi
                decoration: BoxDecoration(
                  color: const Color(0xFF4A55A2),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
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
            // Profile Image
            Positioned(
              top: screenHeight * 0.15, // Posisi vertikal (sesuaikan kebutuhan)
              width: screenWidth, // Lebar mengikuti layar
              child: Center(
                child: Container(
                  width: screenWidth * 0.3, // Lebar gambar
                  height: screenWidth * 0.3, // Tinggi gambar (proporsi bundar)
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF4A55A2), width: 5),
                    borderRadius:
                        BorderRadius.circular(100), // Membulatkan kontainer
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(100), // Membulatkan gambar
                    child: Image.asset(
                      'assets/images/siswa.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.06,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    userProvider.userData?.nama ?? 'Nama Tidak Ditemukan',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: (userProvider.userData?.nama.length ?? 0) > 25
                          ? MediaQuery.of(context).size.width * 0.04
                          : MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Text(
                    userProvider.userData?.username ?? 'Username Tidak Ada',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.normal,
                      color: const Color.fromARGB(255, 192, 192, 192),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
