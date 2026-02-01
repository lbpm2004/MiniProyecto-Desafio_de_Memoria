// Archivo: lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'game_board.dart'; // Importamos la pantalla del juego

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int highScore = 0; // Aquí guardaremos el récord más adelante

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Memoria'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.gamepad, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text(
              '¡Juego de Memoria!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Mejor Puntuación: $highScore intentos',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 50),
            
            // Botón para ir al juego
            ElevatedButton.icon(
              onPressed: () {
                // Navegación hacia el Tablero
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GameBoard()),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text(
                'Jugar Ahora',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}