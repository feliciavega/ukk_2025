import 'package:flutter/material.dart';
import 'package:kasir/registrasi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir/login.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://qickyiqdsmkdxoxkxjpk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFpY2t5aXFkc21rZHhveGt4anBrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3MTM5ODQsImV4cCI6MjA1NDI4OTk4NH0.qOqUVe8CeBY0PwPVI_MB-1QH2t3BHT7_rDKdLd6_nJw',
  );
  runApp(MyApp());
}

// Kelas utama aplikasi yang merupakan StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(), // Menggunakan font Poppins
        ),
        debugShowCheckedModeBanner: false, // Menghilangkan banner debug
        home:
            Login(), // Halaman pertama yang akan ditampilkan saat aplikasi dibuka

        routes: {
          '/registrasi': (context) => registrasi(),
        });
  }
}
