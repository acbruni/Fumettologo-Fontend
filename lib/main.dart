import 'package:flutter/material.dart';
import 'UI/pages/home.dart';
import 'model/supports/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Il Fumettologo",
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}