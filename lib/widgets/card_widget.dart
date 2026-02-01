// Archivo: lib/widgets/card_widget.dart
import 'package:flutter/material.dart';
import '../models/card_model.dart';

class CardWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;

  const CardWidget({
    super.key, 
    required this.card, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // Usamos AnimatedContainer para suavizar el cambio de tamaño o color
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: card.isFlipped || card.isMatched 
              ? Colors.white 
              : Theme.of(context).primaryColor, // Color cuando está oculta
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: card.isFlipped || card.isMatched
              ? Icon(
                  card.icon,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                )
              : const SizedBox(), // No muestra nada si está oculta
        ),
      ),
    );
  }
}