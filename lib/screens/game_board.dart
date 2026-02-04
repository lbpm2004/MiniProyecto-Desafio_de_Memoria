// Archivo: lib/screens/game_board.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../utils/game_logic.dart';
import '../widgets/card_widget.dart';

class GameBoard extends StatefulWidget {
  final Difficulty difficulty; //Trayendo la difficultad
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // Variables de estado
  List<CardModel> cards = [];          // Las cartas del tablero
  List<int> flippedIndices = [];       // Índices de las cartas volteadas temporalmente
  int attempts = 0;                    // Contador de intentos
  bool isProcessing = false;           // Bloqueo para evitar clics rápidos

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      //Tomando en cuenta la dificultad para generar las cartas
      cards = GameLogic.generateCards(widget.difficulty);
      flippedIndices = [];
      attempts = 0;
      isProcessing = false;
    });
  }

  void _onCardTap(int index) {
    // 1. Validaciones básicas: Si ya hay 2 volteadas, si ya está resuelta o si es la misma carta
    if (isProcessing || cards[index].isFlipped || cards[index].isMatched) return;

    setState(() {
      cards[index].isFlipped = true;
      flippedIndices.add(index);
    });

    // 2. Si hay 2 cartas volteadas, verificamos
    if (flippedIndices.length == 2) {
      isProcessing = true; // Bloqueamos interacción
      attempts++;
      _checkForMatch();
    }
  }

  void _checkForMatch() {
    final int index1 = flippedIndices[0];
    final int index2 = flippedIndices[1];

    if (cards[index1].icon == cards[index2].icon) {
      // CASO: ACIERTO
      setState(() {
        cards[index1].isMatched = true;
        cards[index2].isMatched = true;
        flippedIndices.clear();
        isProcessing = false;
      });
      _checkWinCondition();
    } else {
      // CASO: FALLO (Esperamos 1 segundo y las volteamos de nuevo)
      Timer(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            cards[index1].isFlipped = false;
            cards[index2].isFlipped = false;
            flippedIndices.clear();
            isProcessing = false;
          });
        }
      });
    }
  }

  void _checkWinCondition() {
    // Si todas las cartas están emparejadas
    if (cards.every((card) => card.isMatched)) {
      // Aquí mostraremos el diálogo de victoria más adelante
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Juego Terminado! Felicidades!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    final double boardWidth = screenHeight * 0.70; 

    return Scaffold(
      appBar: AppBar(
        title: Text('Intentos: $attempts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startNewGame,
          )
        ],
      ),
      body: Center(
        child: SizedBox(
          width: boardWidth, 
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.difficulty.cols, //Con la cantidad de columnas correspondiente 
                childAspectRatio: 0.9, 
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return CardWidget(
                  card: cards[index],
                  onTap: () => _onCardTap(index),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}