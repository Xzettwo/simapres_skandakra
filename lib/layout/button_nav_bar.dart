import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavbar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Mengambil ukuran layar
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // Menentukan tinggi navbar, dengan batasan antara 0 dan 75
    double navbarHeight = (screenHeight * 0.1).clamp(0.0, 75.0); 

    // Daftar warna ikon berdasarkan index
    List<Color> iconColors = List.generate(5, (index) {
      return index == currentIndex ? const Color(0xFF4A55A2) : Colors.white; // Warna ikon berdasarkan index
    });

    // Daftar skala ukuran ikon berdasarkan index
    List<double> iconScales = List.generate(5, (index) {
      return index == currentIndex ? 1.5 : 1.0; // Ukuran ikon lebih besar saat dipilih
    });

    return SafeArea(
      top: false,
      bottom:true,
      child: CurvedNavigationBar(
        height: navbarHeight, // Menyesuaikan tinggi navbar dengan tinggi layar
        index: currentIndex,
        items: <Widget>[
          // Ikon Absen
          Transform.scale(
            scale: iconScales[0], // Mengubah ukuran ikon
            child: Image.asset(
              'assets/icons/absent.png',
              fit: BoxFit.contain,
              width: screenWidth * 0.07, // Ukuran ikon responsif
              height: screenWidth * 0.07, // Ukuran ikon responsif
              color: iconColors[0], // Warna berdasarkan index
            ),
          ),
          // Ikon Kalender
          Transform.scale(
            scale: iconScales[1], // Mengubah ukuran ikon
            child: Image.asset(
              'assets/icons/calender.png',
              fit: BoxFit.contain,
              width: screenWidth * 0.07, // Ukuran ikon responsif
              height: screenWidth * 0.07, // Ukuran ikon responsif
              color: iconColors[1], // Warna berdasarkan index
            ),
          ),
            Image.asset(
              'assets/images/smk2kra.png',
              width: screenWidth * 0.12, // Ukuran ikon responsif
              height: screenWidth * 0.12, // Ukuran ikon responsif
            ),
          // Ikon Prestation
          Transform.scale(
            scale: iconScales[3], // Mengubah ukuran ikon
            child: Image.asset(
              'assets/icons/prestation.png',
              fit: BoxFit.contain,
              width: screenWidth * 0.07, // Ukuran ikon responsif
              height: screenWidth * 0.07, // Ukuran ikon responsif
              color: iconColors[3], // Warna berdasarkan index
            ),
          ),
          // Ikon Danger
          Transform.scale(
            scale: iconScales[4], // Mengubah ukuran ikon
            child: Image.asset(
              'assets/icons/danger.png',
              fit: BoxFit.contain,
              width: screenWidth * 0.07, // Ukuran ikon responsif
              height: screenWidth * 0.07, // Ukuran ikon responsif
              color: iconColors[4], // Warna berdasarkan index
            ),
          ),
        ],
        onTap: onTap,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.transparent,
        color: const Color(0xFF4A55A2),
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
