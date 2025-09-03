import 'package:flutter/material.dart';

class CardHabito extends StatelessWidget {
  final String habitoId;
  final String nome;
  final int progresso;
  final String lembrete;
  final String frequencia;
  final String categoria;
  final Color color;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onIncrement;

  const CardHabito({
    super.key,
    required this.habitoId,
    required this.nome,
    required this.progresso,
    required this.lembrete,
    required this.frequencia,
    required this.categoria,
    required this.color,
    this.onTap,
    this.onLongPress,
    this.onIncrement,
  });

  IconData getCategoriaIcon(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'corrida':
        return Icons.directions_run;
      case 'leitura':
        return Icons.menu_book;
      case 'trabalho':
        return Icons.work;
      default:
        return Icons.category;
    }
  }

  int getDiasTotais(String frequencia) {
    switch (frequencia.toLowerCase()) {
      case 'diário':
        return 1;
      case 'semanal':
        return 7;
      case 'mensal':
        return 30;
      default:
        return 7;
    }
  }

  Color getProgressColor(double percent) {
    if (percent >= 0.7) return const Color(0xFF4CAF50); // Verde
    if (percent >= 0.4) return const Color(0xFFFFA726); // Laranja
    return const Color(0xFFFF6B6B); // Vermelho
  }

  @override
  Widget build(BuildContext context) {
    final int totalDias = getDiasTotais(frequencia);
    final double progressoFator = (progresso.clamp(0, totalDias)) / totalDias;
    final Color progressColor = getProgressColor(progressoFator);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 233, 233),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  getCategoriaIcon(categoria),
                  color: const Color(0xFFFF6B6B),
                  size: 26,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    nome,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFF6B6B),
                      letterSpacing: 1.1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: onIncrement,
                  icon: const Icon(Icons.check_circle_outline),
                  tooltip: 'Adicionar progresso',
                  iconSize: 30,
                  color: progressColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey.shade600, size: 18),
                const SizedBox(width: 6),
                Text(
                  lembrete,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(Icons.date_range, color: Colors.grey.shade600, size: 18),
                const SizedBox(width: 6),
                Text(
                  frequencia,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 30,
                color: color.withOpacity(0.15),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double larguraMaxima = constraints.maxWidth;
                    final double larguraProgresso =
                        larguraMaxima * progressoFator;

                    return Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: larguraProgresso,
                          decoration: BoxDecoration(
                            color: progressColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        Center(
                          child: Text(
                            '$progresso / $totalDias dia(s)',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
