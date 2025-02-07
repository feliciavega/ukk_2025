import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir/dashboard.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username dan password tidak boleh kosong')),
      );
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('user')
          .select()
          .eq('username', username)
          .eq('password', password);

      if (response.isEmpty) {
        // Tidak ada data, login gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username atau password salah')),
        );
      } else {
        // Login berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.account_circle_rounded,
                        size: 90,
                        color: Color.fromARGB(255, 47, 108, 133),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 30),
                        child: Text(
                          "AYO LOGIN",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Color.fromARGB(255, 34, 124, 167),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 16),
                  child: TextField(
                    controller: usernameController,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      hintText: "Username",
                      filled: true,
                      fillColor: Color(0xfff2f2f3),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.person_2_rounded,
                        color: Color.fromARGB(255, 47, 108, 133),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Color(0xfff2f2f3),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color.fromARGB(255, 47, 108, 133),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 16),
                  child: MaterialButton(
                    onPressed: () => login(context),
                    color: Color.fromARGB(255, 47, 108, 133),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    textColor: Color(0xffffffff),
                    height: 40,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
