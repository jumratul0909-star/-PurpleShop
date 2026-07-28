import 'package:flutter/material.dart';

// Import dengan format package yang konsisten
import 'package:purpleshop/pages/home/home_page.dart';
import 'package:purpleshop/login_page.dart';
import 'package:purpleshop/pages/notification/notification_page.dart';
import 'package:purpleshop/screens/alamat_pengiriman_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Purple Shop',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xffF7F7F7),
      ),
      // Halaman awal saat aplikasi pertama kali dijalankan
      home: const LoginPage(),

      // Daftar rute untuk berpindah ke halaman lain
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/notification': (context) => const NotificationPage(),
        '/alamat': (context) => const AlamatPengirimanScreen(),
      },
    );
  }
}