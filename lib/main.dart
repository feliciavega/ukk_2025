import 'package:flutter/material.dart';
import 'package:kasir/dashboard.dart';
import 'package:kasir/detail_penjualan_page.dart';
import 'package:kasir/pelanggan_page.dart';
import 'package:kasir/penjualan_page.dart';
import 'package:kasir/produk_page.dart';
import 'package:kasir/profile_page.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: Login(),
      routes: {
        '/pelanggan': (context) => PelangganPage(),
        '/produk': (context) => ProdukPage(),
        '/penjualan': (context) => PenjualanPage(),
        '/profil': (context) => ProfilePage(),
        '/dashboard': (context) => Dashboard(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail-penjualan') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => DetailPenjualanPage(idPenjualan: args['idPenjualan']),
          );
        }
        return null;
      },
    );
  }
}
