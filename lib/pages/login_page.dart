import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class UserData {
  final String username;
  final String nama;
  final String kelas;
  final String email;
  final String role;

  UserData({
    required this.username,
    required this.nama,
    required this.kelas,
    required this.email,
    required this.role,
  });
}

class UserProvider extends ChangeNotifier {
  UserData? _userData;

  UserData? get userData => _userData;

  void setUserData({
    required String username,
    required String nama,
    required String kelas,
    required String email,
    required String role,
  }) {
    _userData = UserData(
        username: username, nama: nama, kelas: kelas, email: email, role: role);
    notifyListeners();
  }

  UserData? getUser() {
    return _userData;
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final response = await http.post(
      Uri.parse('https://presensi.smkn2kra.sch.id/api/login'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Provider.of<UserProvider>(context, listen: false).setUserData(
        username: data['user']['username'],
        nama: data['user']['nama'],
        kelas: data['user']['kelas'],
        email: data['user']['email'],
        role: data['user']['level'],
      );
      print(json.decode(response.body));
      Navigator.pushReplacementNamed(context, '/landingPage');
    } else {
      print(json.decode(response.body));
      final pesan = json.decode(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Peringatan'),
            content: Text(pesan['message']),
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
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;

        return Scaffold(
          backgroundColor: const Color(0xFF4A55A2),
          body: Stack(
            children: [
              // Background Container putih
              Positioned(
                right: -screenWidth * 0.001,
                bottom: -screenHeight * 0.4,
                child: Transform.rotate(
                  angle: 0.36,
                  child: Container(
                    width: screenWidth * 1.2,
                    height: screenHeight * 0.8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                ),
              ),
              // Layer tambahan Container 7895CB
              Positioned(
                right: screenWidth * -0.66,
                bottom: screenHeight * 0.4,
                child: Transform.rotate(
                  angle: 0.36,
                  child: Container(
                    width: screenWidth * 1.2,
                    height: screenHeight * 0.8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7895CB),
                      borderRadius: const BorderRadius.all(Radius.circular(90)),
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

               // Container 7895CB #2
              Positioned(
                right: screenWidth * 1,
                bottom: screenHeight * 0.1,
                child: Transform.rotate(
                  angle: 0.36,
                  child: Container(
                    width: screenWidth * 1.2,
                    height: screenHeight * 0.8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7895CB),
                      borderRadius: const BorderRadius.all(Radius.circular(90)),
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

              // Layer tambahan Container A0BFE0
              Positioned(
                right: screenWidth * -0.85,
                bottom: screenHeight * 0.43,
                child: Transform.rotate(
                  angle: 0.36,
                  child: Container(
                    width: screenWidth * 1.2,
                    height: screenHeight * 0.8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA0BFE0),
                      borderRadius: const BorderRadius.all(Radius.circular(90)),
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
              // Inputan untuk NIS dan Password
              Positioned(
                left: 0.1 * screenWidth,
                right: 0.1 * screenWidth,
                bottom: 0.2 * screenHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _usernameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'NIS',
                        hintStyle: GoogleFonts.openSans(color: Colors.black),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                      style: GoogleFonts.openSans(color: Colors.black),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: GoogleFonts.openSans(color: Colors.black),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                      style: GoogleFonts.openSans(color: Colors.black),
                    ),
                  ],
                ),
              ),
              // Tombol Login
              Positioned(
                bottom: 0.05 * screenHeight,
                left: 0.2 * screenWidth,
                right: 0.2 * screenWidth,
                child: SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.06,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A55A2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.nunito(
                        fontSize: screenHeight * 0.024,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              // Logo & Title
              Positioned(
                bottom: screenHeight * 0.6,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      'PRESENSI SKANDAKRA',
                      style: GoogleFonts.montserrat(
                        fontSize: screenWidth * 0.050,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/images/smk2kra.png',
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
