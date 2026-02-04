import 'dart:math'; 
import 'package:flutter/material.dart';
import '../models/card_model.dart';

class CardWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;

  const CardWidget({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        // Si la carta está volteada o encontrada, giramos 180 grados (pi), si no, 0.
        tween: Tween(begin: 0, end: (card.isFlipped || card.isMatched) ? pi : 0),
        duration: const Duration(milliseconds: 400), // Duración del giro
        curve: Curves.easeInOutBack, 
        builder: (context, angle, child) {
          // Detectamos si el giro ha pasado la mitad (90 grados) para cambiar el contenido
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

  // Diseño de la cara frontal (con el icono)
  Widget _buildFront() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
        ],
      ),
      child: Center(
        child: Icon(
          card.icon,
          size: 32,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  // Diseño del reverso (color morado)
  Widget _buildBack() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple,
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