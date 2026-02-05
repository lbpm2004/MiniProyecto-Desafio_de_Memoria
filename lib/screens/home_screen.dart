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
  Map<Difficulty, int> highScores = {};

  @override
  void initState() {
    super.initState();
    _loadAllScores();
  }

  Future<void> _loadAllScores() async {
    Map<Difficulty, int> tempScores = {};
    for (var difficulty in Difficulty.values) {
      int score = await PreferencesService.getBestScore(difficulty);
      tempScores[difficulty] = score;
    }
    setState(() {
      highScores = tempScores;
    });
  }

  void _startGame(Difficulty difficulty) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameBoard(difficulty: difficulty),
      ),
    );
    // Recargar récords al volver
    _loadAllScores();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ancho de la pantalla para ajustar los botones si es necesario
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Flutter Memoria'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo y Título
              const Icon(Icons.psychology, size: 100, color: Colors.deepPurple),
              const SizedBox(height: 20),
              const Text(
                'Desafío de Memoria',
                style: TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black87
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Selecciona tu nivel para empezar",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 60),
          
              // --- ZONA DE BOTONES HORIZONTAL ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centrados horizontalmente
                  crossAxisAlignment: CrossAxisAlignment.end,  // Alineados abajo
                  children: Difficulty.values.map((difficulty) {
                    
                    final int score = highScores[difficulty] ?? 0;
                    
                    // Usamos Flexible para que se repartan el ancho equitativamente
                    return Flexible(
                      fit: FlexFit.tight, 
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            // 1. EL RÉCORD (Arriba del botón)
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "RÉCORD",
                                    style: TextStyle(
                                      fontSize: 10, 
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    score == 0 ? "--" : "$score",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: difficulty.colorDisplay,
                                    ),
                                  ),
                                ],
                              ),
                            ),
          
                            // 2. EL BOTÓN (Abajo)
                            SizedBox(
                              width: double.infinity, // Que llene su espacio asignado
                              height: 120, // Altura fija para que se vean cuadrados/grandes
                              child: ElevatedButton(
                                onPressed: () => _startGame(difficulty),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: difficulty.colorDisplay,
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _getIconForDifficulty(difficulty), 
                                      size: 30
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      difficulty.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 14 : 18, 
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función auxiliar para darle iconos distintos a los botones
  IconData _getIconForDifficulty(Difficulty d) {
    switch (d) {
      case Difficulty.easy: return Icons.sentiment_satisfied_alt;
      case Difficulty.medium: return Icons.speed;
      case Difficulty.hard: return Icons.local_fire_department;
    }
  }
}