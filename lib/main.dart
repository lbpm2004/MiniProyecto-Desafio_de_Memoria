import 'package:flutter/material.dart';
import 'screens/home_screen.dart';


void main() {
  runApp(const MemoryGameApp());
}


class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({super.key});


    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Desafío de Memoria',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
