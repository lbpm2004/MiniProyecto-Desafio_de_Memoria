import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() async {
  // para que el guardado funcione al iniciar
  WidgetsFlutterBinding.ensureInitialized();
  
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
        // Usamos un color base más neutro
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
