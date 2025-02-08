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
  bool isPasswordVisible = false;
  String? usernameError;
  String? passwordError;

  Future<void> login(BuildContext context) async {
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();

    // Set error jika kosong
    setState(() {
      usernameError = username.isEmpty ? 'Username tidak boleh kosong' : null;
      passwordError = password.isEmpty ? 'Password tidak boleh kosong' : null;
    });

    if (username.isEmpty || password.isEmpty) {
      return; // Stop jika ada field yang kosong
    }

    try {
      final response = await Supabase.instance.client
          .from('user')
          .select()
          .eq('username', username)
          .maybeSingle();

      bool isUsernameValid = response != null;
      bool isPasswordValid =
          isUsernameValid && response['password'] == password;

      setState(() {
        usernameError = isUsernameValid ? null : 'Username tidak ditemukan';
        passwordError = isPasswordValid ? null : 'Password salah';
      });

      if (!isUsernameValid || !isPasswordValid) {
        return; // Stop jika ada kesalahan
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login berhasil!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f3), // Background abu-abu muda
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle_rounded,
                    size: 90, color: Color.fromARGB(255, 47, 108, 133)),
                SizedBox(height: 8),
                Text(
                  "AYO LOGIN",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Color.fromARGB(255, 34, 124, 167),
                  ),
                ),
                SizedBox(height: 30),

                // Container untuk form login
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna latar belakang form
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: "Username",
                          filled: true,
                          fillColor: Color(0xfff2f2f3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.person_2_rounded,
                              color: Color.fromARGB(255, 47, 108, 133)),
                          errorText: usernameError,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Password",
                          filled: true,
                          fillColor: Color(0xfff2f2f3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.lock,
                              color: Color.fromARGB(255, 47, 108, 133)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color.fromARGB(255, 47, 108, 133),
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                          errorText: passwordError,
                        ),
                      ),
                      SizedBox(height: 24),
                      MaterialButton(
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
                        height: 45,
                        minWidth: MediaQuery.of(context).size.width,
                      ),
                    ],
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
