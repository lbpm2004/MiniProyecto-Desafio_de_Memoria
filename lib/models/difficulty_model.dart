import 'package:flutter/material.dart';

enum Difficulty {
  // Principiante: 4x4 = 16 cartas (8 parejas)
  easy(rows: 4, cols: 4, name: "Principiante", colorDisplay: Colors.teal),
  
  // Avanzado: 6x5 = 30 cartas (15 parejas) -> CORREGIDO A 5 COLUMNAS
  medium(rows: 6, cols: 5, name: "Avanzado", colorDisplay: Colors.orange), 
  
  // Experto: 6x6 = 36 cartas (18 parejas) -> "PDF" ELIMINADO
  hard(rows: 6, cols: 6, name: "Experto", colorDisplay: Colors.redAccent); 

  final int rows;
  final int cols;
  final String name;
  final Color colorDisplay;

  const Difficulty({
    required this.rows,
    required this.cols,
    required this.name,
    required this.colorDisplay,
  });

  int get totalCards => rows * cols;
}