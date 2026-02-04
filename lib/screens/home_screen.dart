import 'package:flutter/material.dart';
import 'game_board.dart';
import '../models/difficulty_model.dart';
import '../utils/preferences_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    _loadScore();
  }

  // Cargar el récord cada vez que entramos a esta pantalla
  Future<void> _loadScore() async {
    final score = await PreferencesService.getBestScore();
    setState(() {
      highScore = score;
    });
  }

  // Refrescar récord al volver del juego
  void _startGame(Difficulty difficulty) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameBoard(difficulty: difficulty),
      ),
    );
    _loadScore(); // Recargar al volver
  }

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
            const Icon(Icons.psychology, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text(
              'Desafío de Memoria',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Muestra el Récord Guardado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.deepPurple.shade200)
              ),
              child: Text(
                highScore == 0 
                  ? 'Sin Récord aún' 
                  : 'Mejor Récord: $highScore intentos',
                style: const TextStyle(fontSize: 18, color: Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 40),
            const Text("Selecciona Dificultad:", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            
            // Generamos botones dinámicamente
            ...Difficulty.values.map((difficulty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton.icon(
                    onPressed: () => _startGame(difficulty),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: difficulty.colorDisplay,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(
                      difficulty.name.replaceAll('(PDF)', '').trim(), 
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}