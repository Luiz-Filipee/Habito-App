import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitoapp/auth/authFirebase.dart';
import 'package:habitoapp/controllers/usuarioController.dart';

class GamificacaoUser extends StatefulWidget {
  const GamificacaoUser({super.key});

  @override
  State<GamificacaoUser> createState() => _GamificacaoUserState();
}

class _GamificacaoUserState extends State<GamificacaoUser> {
  final UsuarioController _usuarioController =
      UsuarioController(AutenticacaoFirebase());
  int _paginaAtual = 1;
  String? usuarioID;

  final Color activeColor = const Color(0xFFFF6B6B);
  final Color inactiveColor = Colors.grey.shade400;
  final Color scaffoldBgColor = const Color(0xFFFDF6F0);

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final id = await _usuarioController.getUserSession(context);
    if (id != null) {
      setState(() {
        usuarioID = id;
      });
    }
  }

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
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: activeColor,
        elevation: 4,
        centerTitle: true,
        title: const Text(
          'Gamificação',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SafeArea(
        child: usuarioID == null
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder<DocumentSnapshot>(
                stream: _usuarioController
                    .dadosGamificacaoUsuarioStream(usuarioID!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data =
                      snapshot.data!.data() as Map<String, dynamic>? ?? {};
                  final int xp = data['xp'] ?? 0;
                  final int nivel = data['nivel'] ?? 1;
                  final List conquistas = data['medalhas'] ?? [];

                  final int xpPorNivel = 100;
                  final int xpProximoNivel = nivel * xpPorNivel;
                  final int xpAtualNivel = (nivel - 1) * xpPorNivel;
                  final double progresso =
                      (xp - xpAtualNivel) / (xpProximoNivel - xpAtualNivel);

                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "XP",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "$xp",
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progresso,
                            minHeight: 40,
                            borderRadius: BorderRadius.circular(18),
                            backgroundColor: Colors.blue.shade100,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Nível $nivel",
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Conquistas",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          conquistas.isEmpty
                              ? Text(
                                  'Nenhuma conquista ainda.',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                  ),
                                )
                              : Wrap(
                                  spacing: 20,
                                  runSpacing: 16,
                                  children: conquistas.map((c) {
                                    IconData icone;
                                    String label;

                                    switch (c) {
                                      case "novato":
                                        icone = Icons.star;
                                        label = "Novato";
                                        break;
                                      case "comecando_com_o_pe_direito":
                                        icone = Icons.anchor;
                                        label = "É assim que se faz";
                                        break;
                                      case "primeiro_habito_concluido":
                                        icone = Icons.star;
                                        label = "Primeiro de muitos";
                                        break;
                                      case "10_onda":
                                        icone = Icons.local_fire_department;
                                        label = "10 Onda";
                                        break;
                                      case "30_dias":
                                        icone = Icons.wb_sunny;
                                        label = "30 Dias";
                                        break;
                                      default:
                                        icone = Icons.emoji_events;
                                        label = c.toString();
                                    }

                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor:
                                              Colors.amber.shade200,
                                          child: Icon(
                                            icone,
                                            size: 30,
                                            color: Colors.deepOrange,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          label,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    );
                                  }).toList(),
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: Container(
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
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
      ),
    );
  }
}
