import 'package:flutter/material.dart';
import 'package:flutter_api_xampp/pages/daftar_mahasiswa.dart';
import 'pages/daftar_mahasiswa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DaftarMahasiswa(),
    );
  }
}
