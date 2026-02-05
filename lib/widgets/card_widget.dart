import 'dart:math'; 
import 'package:flutter/material.dart';
import '../models/card_model.dart';

class CardWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;
  final Color backColor; // NUEVO: Color dinámico

  const CardWidget({
    super.key, 
    required this.card, 
    required this.onTap,
    required this.backColor, // Requerido
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: (card.isFlipped || card.isMatched) ? pi : 0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutBack, 
        builder: (context, angle, child) {
          final bool isFront = angle >= (pi / 2);

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) 
              ..rotateY(angle),       
            child: isFront
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi), 
                    child: _buildFront(), 
                  )
                : _buildBack(), 
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    return Container(
      decoration: BoxDecoration(
        color: card.isMatched ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Usamos el mismo color del reverso para el borde frontal (queda muy elegante)
        border: Border.all(
          color: card.isMatched ? Colors.green : backColor, 
          width: card.isMatched ? 4 : 2
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
        ],
      ),
      child: Center(
        child: Icon(
          card.icon,
          size: 32,
          // El icono también combina con la dificultad
          color: card.isMatched ? Colors.green : backColor,
        ),
      ),
    );
  }

  // Diseño del reverso (AHORA USA EL COLOR DINÁMICO)
  Widget _buildBack() {
    return Container(
      decoration: BoxDecoration(
        color: backColor, // <--- Aquí usamos el color de la dificultad
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.question_mark, 
          color: Colors.white54,
          size: 32,
        ),
      ),
    );
  }
}