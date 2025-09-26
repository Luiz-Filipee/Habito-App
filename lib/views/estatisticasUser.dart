import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EstatisticasUser extends StatefulWidget {
  const EstatisticasUser({super.key});

  @override
  State<EstatisticasUser> createState() => _EstatisticasUserState();
}

class _EstatisticasUserState extends State<EstatisticasUser> {
  final Color activeColor = const Color(0xFFFF6B6B);
  final Color maxColor = Color.fromARGB(255, 250, 232, 232);
  final Color backgroundColor = const Color(0xFFFDF6F0);

  int concluidos = 0;
  int pendentes = 0;
  List<Map<String, dynamic>> habitos = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('habitos')
          .where('usuarioID', isEqualTo: user.uid)
          .get();

      int feitos = 0;
      int naoFeitos = 0;
      List<Map<String, dynamic>> listaHabitos = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final String nome =
            (data['nome'] ?? data['titulo'] ?? 'Hábito').toString();
        final bool concluido = data['concluido'] == true;
        final String frequencia =
            (data['frequencia'] ?? 'diário').toString().toLowerCase();

        int valor = 1;
        if (frequencia.contains("semanal")) {
          valor = 7;
        } else if (frequencia.contains("mensal")) {
          valor = 30;
        }

        int progresso = (data['progresso'] ?? 0) as int;

        if (concluido) feitos++;
        if (!concluido) naoFeitos++;

        listaHabitos.add({
          "nome": nome,
          "concluido": concluido,
          "valor": valor,
          "progresso": progresso,
        });
      }

      setState(() {
        concluidos = feitos;
        pendentes = naoFeitos;
        habitos = listaHabitos;
        carregando = false;
      });
    } else {
      setState(() {
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = (concluidos + pendentes).toDouble();
    double porcentagem = total > 0 ? (concluidos / total * 100) : 0;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: activeColor,
        centerTitle: true,
        title: const Text(
          "Suas Estatísticas",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Progresso dos Hábitos",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: activeColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 250,
                          child: habitos.isEmpty
                              ? Center(
                                  child: Text(
                                    'Nenhum hábito para mostrar.',
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  ),
                                )
                              : BarChart(
                                  BarChartData(
                                    alignment: BarChartAlignment.spaceAround,
                                    maxY: habitos
                                            .map((h) => h['valor'] as int)
                                            .reduce((a, b) => a > b ? a : b)
                                            .toDouble() +
                                        1,
                                    barGroups:
                                        habitos.asMap().entries.map((entry) {
                                      final int index = entry.key;
                                      final habito = entry.value;
                                      final double valorMax =
                                          (habito['valor'] ?? 1).toDouble();
                                      final double progresso =
                                          ((habito['progresso'] ?? 0) as int)
                                              .toDouble();
                                      final bool concluido =
                                          habito['concluido'] == true;

                                      return BarChartGroupData(
                                        x: index,
                                        barRods: [
                                          BarChartRodData(
                                            toY: valorMax,
                                            width: 18,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            rodStackItems: [
                                              BarChartRodStackItem(
                                                  0, valorMax, maxColor),
                                              BarChartRodStackItem(
                                                  0,
                                                  progresso,
                                                  concluido
                                                      ? Colors.green
                                                      : activeColor),
                                            ],
                                          ),
                                        ],
                                        showingTooltipIndicators: [],
                                      );
                                    }).toList(),
                                    borderData: FlBorderData(show: false),
                                    gridData: FlGridData(show: false),
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            final int index = value.toInt();
                                            if (index < habitos.length) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  habitos[index]["nome"],
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              );
                                            }
                                            return const Text('');
                                          },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              value.toInt().toString(),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            );
                                          },
                                          reservedSize: 28,
                                        ),
                                      ),
                                      topTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      rightTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                    ),
                                    barTouchData: BarTouchData(enabled: false),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 255,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Taxa de Conclusão",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: activeColor,
                          ),
                        ),
                        const SizedBox(height: 23),
                        SizedBox(
                          height: 180,
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 35,
                              sections: [
                                PieChartSectionData(
                                  value: porcentagem,
                                  color: activeColor,
                                  title: "${porcentagem.toStringAsFixed(0)}%",
                                  radius: 60,
                                  titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: 100 - porcentagem,
                                  color: Colors.grey.shade300,
                                  title: "",
                                  radius: 60,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      "🎯 Você completou ${porcentagem.toStringAsFixed(0)}% dos seus hábitos!\n"
                      "Continue assim e desbloqueie mais medalhas.",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
