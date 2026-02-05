import 'package:flutter/material.dart';

enum Difficulty {
  // 1. Principiante: 5 minutos (300 segundos)
  easy(rows: 4, cols: 4, name: "Principiante", colorDisplay: Colors.teal, timeLimitInSeconds: 300),
  
  // 2. Avanzado: 3 minutos (180 segundos)
  medium(rows: 6, cols: 5, name: "Avanzado", colorDisplay: Colors.orange, timeLimitInSeconds: 180),
  
  // 3. Experto: 2 minutos (120 segundos)
  hard(rows: 6, cols: 6, name: "Experto", colorDisplay: Colors.redAccent, timeLimitInSeconds: 120);

  final int rows;
  final int cols;
  final String name;
  final Color colorDisplay;
  final int timeLimitInSeconds; 

  const Difficulty({
    required this.rows,
    required this.cols,
    required this.name,
    required this.colorDisplay,
    required this.timeLimitInSeconds,
  });

  int get totalCards => rows * cols;
  int get pairs => totalCards ~/ 2;
  String get description => "${cols}x$rows Cartas • $pairs Parejas";
}