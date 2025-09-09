import 'package:flutter/material.dart';
import 'package:habitoapp/controllers/habitoController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MetasUserHabitos extends StatefulWidget {
  const MetasUserHabitos({super.key});

  @override
  State<MetasUserHabitos> createState() => _MetasUserHabitosState();
}

class _MetasUserHabitosState extends State<MetasUserHabitos> {
  final HabitController _habitController = HabitController();
  int _paginaAtual = 1;

  final Color activeColor = const Color(0xFFFF6B6B);
  final Color inactiveColor = Colors.grey.shade400;

  void _navegar(int index) {
    setState(() {
      _paginaAtual = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/lista-habitos');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/metas');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/config');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      appBar: AppBar(
        backgroundColor: activeColor,
        elevation: 4,
        centerTitle: true,
        title: const Text(
          'Suas Metas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: StreamBuilder<QuerySnapshot>(
            stream: _habitController.listarHabitosUsuario(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhuma meta encontrada.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              final habitos = snapshot.data!.docs;
              Map<String, List<Map<String, dynamic>>> habitosPorCategoria = {};

              for (var doc in habitos) {
                final data = doc.data() as Map<String, dynamic>;
                final categoria = data['categoria'] ?? 'Outros';

                if (!habitosPorCategoria.containsKey(categoria)) {
                  habitosPorCategoria[categoria] = [];
                }
                habitosPorCategoria[categoria]!.add(data);
              }

              return ListView(
                physics: const BouncingScrollPhysics(),
                children: habitosPorCategoria.entries.map((entry) {
                  final categoria = entry.key;
                  final listaHabitos = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          categoria,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: activeColor,
                          ),
                        ),
                      ),
                      ...listaHabitos.map((habito) {
                        final String nome = habito['nome'] ?? '';
                        final int progresso = habito['progresso'] ?? 0;
                        final String frequencia =
                            habito['frequencia'] ?? 'diário';
                        final int? corInt = habito['cor'];
                        final Color cor =
                            corInt != null ? Color(corInt) : activeColor;

                        int dias = 1;
                        switch (frequencia.toLowerCase()) {
                          case 'diário':
                            dias = 1;
                            break;
                          case 'semanal':
                            dias = 7;
                            break;
                          case 'mensal':
                            dias = 30;
                            break;
                          default:
                            dias = 1;
                        }
                        final bool concluido = progresso >= dias;
                        int diasEmAberto = dias - progresso;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: concluido
                                    ? Colors.green.shade100
                                    : cor.withOpacity(0.6),
                                child: Icon(
                                  concluido
                                      ? Icons.check
                                      : Icons.radio_button_unchecked,
                                  color: concluido ? Colors.green : cor,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nome,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      concluido ? "Concluído" : "Em andamento",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: concluido
                                            ? Colors.green
                                            : Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Dias à concluir: $diasEmAberto",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: concluido
                                            ? Colors.green
                                            : activeColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: _bottomBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: activeColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.auto_graph_sharp, size: 30),
        onPressed: () {
          Navigator.pushNamed(context, '/gamificacao');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _bottomBar() {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, -3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home_filled,
                size: 32,
                color: _paginaAtual == 0 ? activeColor : inactiveColor,
              ),
              onPressed: () => _navegar(0),
              tooltip: 'Início',
            ),
            IconButton(
              icon: Icon(
                Icons.check_circle,
                size: 32,
                color: _paginaAtual == 1 ? activeColor : inactiveColor,
              ),
              onPressed: () => _navegar(1),
              tooltip: 'Metas',
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                size: 32,
                color: _paginaAtual == 2 ? activeColor : inactiveColor,
              ),
              onPressed: () => _navegar(2),
              tooltip: 'Configurações',
            ),
          ],
        ),
      ),
    );
  }
}
