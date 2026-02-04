import 'dart:async';
import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../utils/game_logic.dart';
import '../widgets/card_widget.dart';
import '../models/difficulty_model.dart';
import '../utils/preferences_service.dart'; 

class GameBoard extends StatefulWidget {
  final Difficulty difficulty;

  const GameBoard({super.key, required this.difficulty});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<CardModel> cards = [];
  List<int> flippedIndices = [];
  int attempts = 0;
  bool isProcessing = false;
  
  // Timer
  Timer? _timer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  @override
  void dispose() {
    _timer?.cancel(); 
    super.dispose();
  }

  // --- LÓGICA DE TIEMPO Y JUEGO ---

  void _startTimer() {
    _timer?.cancel();
    _secondsElapsed = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  void _startNewGame() {
    setState(() {
      cards = GameLogic.generateCards(widget.difficulty);
      flippedIndices = [];
      attempts = 0;
      isProcessing = false;
      _startTimer();
    });
  }

  void _onCardTap(int index) {
    if (isProcessing || cards[index].isFlipped || cards[index].isMatched) return;

    setState(() {
      cards[index].isFlipped = true;
      flippedIndices.add(index);
    });

    if (flippedIndices.length == 2) {
      isProcessing = true;
      attempts++;
      _checkForMatch();
    }
  }

  void _checkForMatch() {
    final int index1 = flippedIndices[0];
    final int index2 = flippedIndices[1];

    if (cards[index1].icon == cards[index2].icon) {
      setState(() {
        cards[index1].isMatched = true;
        cards[index2].isMatched = true;
        flippedIndices.clear();
        isProcessing = false;
      });
      _checkWinCondition();
    } else {
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

  void _checkWinCondition() async {
    if (cards.every((card) => card.isMatched)) {
      _timer?.cancel(); 
      await PreferencesService.saveScore(attempts);

      if (mounted) {
        _showWinDialog();
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("¡Felicidades!", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 60, color: Colors.amber),
            const SizedBox(height: 10),
            Text("Has completado el nivel ${_getCleanTitle()}."),
            const SizedBox(height: 10),
            Text("Intentos: $attempts", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Tiempo: ${_formatTime(_secondsElapsed)}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
              Navigator.pop(context); 
            },
            child: const Text("Menú"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewGame();
            },
            child: const Text("Jugar Otra vez"),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // --- UI Y DISEÑO ---

  Map<String, int> _getGridDimensions() {
    String name = widget.difficulty.name.toLowerCase();
    
    if (name.contains("experto")) {
      return {'col': 6, 'row': 6}; 
    } else if (name.contains("avanzado")) {
      return {'col': 5, 'row': 6}; 
    } else {
      return {'col': 4, 'row': 4}; 
    }
  }

  String _getCleanTitle() {
    String name = widget.difficulty.name.toUpperCase();
    if (name.contains("EXPERTO")) return "EXPERTO";
    if (name.contains("AVANZADO")) return "AVANZADO";
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = _getGridDimensions();
    final int cols = dimensions['col']!;
    final int rows = dimensions['row']!;

    const double cardAspectRatio = 0.8; 

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: widget.difficulty.colorDisplay,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Intentos: $attempts'),
            Text(_formatTime(_secondsElapsed)), 
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _startNewGame)
        ],
      ),
      body: Column(
        children: [
          // Título del nivel
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              _getCleanTitle(),
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: widget.difficulty.colorDisplay,
                letterSpacing: 1.2
              ),
            ),
          ),
          
          // ZONA DEL TABLERO
          Expanded(
            child: Padding(

              padding: const EdgeInsets.all(24.0),
              child: Center(

                child: LayoutBuilder(
                  builder: (context, constraints) {

                    double boardAspectRatio = cols / (rows / cardAspectRatio);

                    return AspectRatio(
                      aspectRatio: boardAspectRatio,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cards.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          childAspectRatio: cardAspectRatio,
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
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}