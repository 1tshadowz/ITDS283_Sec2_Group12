import 'package:flutter/material.dart';
import 'pages/login.dart'; 


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      home: const LoginPage(), // Updated class name
      debugShowCheckedModeBanner: false,
    );
  }
}
