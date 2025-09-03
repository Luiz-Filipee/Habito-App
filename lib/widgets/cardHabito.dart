// habit_card.dart
import 'package:flutter/material.dart';

class CardHabito extends StatelessWidget {
  final String nome;
  final int progresso;
  final String lembrete;
  final Color color;

  const CardHabito({
    super.key,
    required this.nome,
    required this.progresso,
    required this.lembrete,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nome,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progresso / 7,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Text(
                    '$progresso/7',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
