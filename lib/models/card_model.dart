import 'package:flutter/material.dart';

class CardModel {
  final int index;        // Para identificar la posición única de la carta
  final IconData icon;    // El dibujo de la carta
  bool isFlipped;         // ¿Está volteada boca arriba?
  bool isMatched;         // ¿Ya fue encontrada su pareja?

  CardModel({
    required this.index,
    required this.icon,
    this.isFlipped = false,
    this.isMatched = false,
  });
}