import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../models/difficulty_model.dart';

class GameLogic {
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
    Icons.flight,
    Icons.home,
    Icons.work,
  ];

  // Función para generar y mezclar las cartas
  static List<CardModel> generateCards(Difficulty difficulty) {
    int pairsNeeded;
    String nivelNombre = difficulty.name.toLowerCase();

    // 0. DETERMINAR PARES SEGÚN EL NIVEL (Override manual para asegurar consistencia)
    if (nivelNombre.contains("experto")) {
      pairsNeeded = 18; // 36 cartas (6x6)
    } else if (nivelNombre.contains("avanzado")) {
      pairsNeeded = 15; // 30 cartas (5x6)
    } else {
      // Para principieante, usamo 8 pares (4x4)
      pairsNeeded = 8; 
    }

    // Validación de seguridad: No pedir más iconos de los que tenemos
    if (pairsNeeded > cardIcons.length) {
      pairsNeeded = cardIcons.length;
    }

    // 1. Obtenemos los iconos necesarios de la lista maestra
    List<IconData> neededIcons = cardIcons.sublist(0, pairsNeeded);

    // 2. Duplicamos la lista para tener parejas (A y A, B y B...)
    List<IconData> allIcons = [...neededIcons, ...neededIcons];
    
    // 3. Mezclamos los iconos aleatoriamente
    allIcons.shuffle();

    // 4. Convertimos los iconos en objetos CardModel
    return List.generate(allIcons.length, (index) {
      return CardModel(
        index: index,
        icon: allIcons[index],
      );
    });
  }
}