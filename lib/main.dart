import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const VeterinariaApp());
}

class VeterinariaApp extends StatelessWidget {
  const VeterinariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clínica Veterinaria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
