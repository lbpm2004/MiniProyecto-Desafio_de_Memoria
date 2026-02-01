// Archivo: lib/utils/game_logic.dart
import 'package:flutter/material.dart';
import '../models/card_model.dart';

class GameLogic {
  // Lista de 18 iconos para formar los pares (36 cartas en total)
  static final List<IconData> cardIcons = [
    Icons.star,
    Icons.favorite,
    Icons.lightbulb,
    Icons.face,
    Icons.cake,
    Icons.pets,
    Icons.ac_unit,
    Icons.access_alarm,
    Icons.beach_access,
    Icons.bug_report,
    Icons.camera_alt,
    Icons.directions_bike,
    Icons.directions_boat,
    Icons.directions_car,
    Icons.directions_railway,
    Icons.local_pizza,
    Icons.local_florist,
    Icons.music_note,
  ];

  // Función para generar y mezclar las cartas
  static List<CardModel> generateCards() {
    // 1. Duplicamos la lista para tener parejas
    List<IconData> allIcons = [...cardIcons, ...cardIcons];
    
    // 2. Mezclamos los iconos aleatoriamente
    allIcons.shuffle();

    // 3. Convertimos los iconos en objetos CardModel
    return List.generate(allIcons.length, (index) {
      return CardModel(
        index: index,
        icon: allIcons[index],
      );
    });
  }
}