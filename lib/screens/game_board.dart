import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../models/card_model.dart';
import '../utils/game_logic.dart';
import '../widgets/card_widget.dart';
import '../models/difficulty_model.dart';
import '../utils/preferences_service.dart';
import '../utils/audio_manager.dart';

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
  bool isGameOver = false; // Nueva bandera para bloquear el juego si pierdes
  
  Timer? _timer;
  int _secondsElapsed = 0;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _startNewGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsElapsed = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });

        // VERIFICACIÓN DE DERROTA POR TIEMPO
        if (_secondsElapsed >= widget.difficulty.timeLimitInSeconds) {
          _timer?.cancel();
          _showLoseDialog();
        }
      }
    });
  }

  void _startNewGame() {
    setState(() {
      cards = GameLogic.generateCards(widget.difficulty);
      flippedIndices = [];
      attempts = 0;
      isProcessing = false;
      isGameOver = false; // Reiniciamos estado
      _startTimer();
    });
  }

  void _onCardTap(int index) {
    // Si es Game Over, no dejar tocar nada
    if (isGameOver || isProcessing || cards[index].isFlipped || cards[index].isMatched) return;

    AudioManager.playFlip();

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
      AudioManager.playMatch();
      setState(() {
        cards[index1].isMatched = true;
        cards[index2].isMatched = true;
        flippedIndices.clear();
        isProcessing = false;
      });
      _checkWinCondition();
    } else {
      Timer(const Duration(milliseconds: 800), () {
        if (mounted && !isGameOver) { // Solo voltear si no ha terminado el juego
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
      
      // CAMBIO AQUÍ: Pasamos "widget.difficulty" para saber en qué cajita guardar
      await PreferencesService.saveScore(widget.difficulty, attempts);
      
      _confettiController.play();
      AudioManager.playWin();

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        _showWinDialog();
      }
    }
  }

  // --- DIALOGOS ---

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildCustomDialog(
        title: "¡Victoria!",
        color: widget.difficulty.colorDisplay,
        icon: Icons.emoji_events_rounded,
        bodyText: "Nivel ${widget.difficulty.name} completado.",
      ),
    );
  }

  void _showLoseDialog() {
    setState(() {
      isGameOver = true; // Bloquea el tablero
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildCustomDialog(
        title: "¡Tiempo Agotado!",
        color: Colors.grey,
        icon: Icons.timer_off_outlined,
        bodyText: "Se acabó el tiempo límite para ${widget.difficulty.name}.",
      ),
    );
  }

  // Unificamos el diseño del dialogo para ganar y perder
  Widget _buildCustomDialog({
    required String title,
    required Color color,
    required IconData icon,
    required String bodyText,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 80, color: color),
            const SizedBox(height: 15),
            Text(title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 10),
            Text(bodyText, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            // Estadísticas
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.touch_app, color: Colors.grey),
                      Text("$attempts", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const Text("Intentos", style: TextStyle(fontSize: 12))
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(Icons.timer, color: Colors.grey),
                      Text(_formatTime(_secondsElapsed), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const Text("Tiempo", style: TextStyle(fontSize: 12))
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text("Menú"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: color, foregroundColor: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      _startNewGame();
                    },
                    child: const Text("Repetir"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double availableHeight = size.height * 0.75;
    
    final int cols = widget.difficulty.cols;
    final int rows = widget.difficulty.rows;
    final double cardSize = availableHeight / rows;
    final double boardWidth = (cardSize * cols) + (cols * 10);

    return Scaffold(
      backgroundColor: widget.difficulty.colorDisplay.withOpacity(0.05),
      appBar: AppBar(
        backgroundColor: widget.difficulty.colorDisplay,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Intentos: $attempts', style: const TextStyle(fontSize: 16)),
            // NUEVO FORMATO: Transcurrido / Límite
            Row(
              children: [
                const Icon(Icons.av_timer, size: 20),
                const SizedBox(width: 5),
                Text(
                  "${_formatTime(_secondsElapsed)} / ${_formatTime(widget.difficulty.timeLimitInSeconds)}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startNewGame,
            tooltip: 'Reiniciar',
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: widget.difficulty.colorDisplay.withOpacity(0.1),
                child: Column(
                  children: [
                    Text(
                      widget.difficulty.name.toUpperCase(),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: widget.difficulty.colorDisplay,
                          letterSpacing: 1.5),
                    ),
                    Text(
                      widget.difficulty.description,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: boardWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cards.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          return CardWidget(
                            card: cards[index],
                            onTap: () => _onCardTap(index),
                            // NUEVO: Pasamos el color de la dificultad
                            backColor: widget.difficulty.colorDisplay,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}