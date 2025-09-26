import 'package:flutter/material.dart';
import 'package:habitoapp/auth/authFirebase.dart';
import 'package:habitoapp/controllers/habitoController.dart';
import 'package:habitoapp/controllers/usuarioController.dart';
import 'package:habitoapp/widgets/cardHabito.dart';

class ListaHabitos extends StatefulWidget {
  @override
  State<ListaHabitos> createState() => _ListaHabitosState();
}

class _ListaHabitosState extends State<ListaHabitos> {
  final HabitController _habitController = HabitController();
  final UsuarioController _usuarioController =
      UsuarioController(AutenticacaoFirebase());
  int _paginaAtual = 0;

  final Color activeColor = Color(0xFFFF6B6B);
  final Color inactiveColor = Colors.grey.shade400;
  final Color scaffoldBgColor = Color(0xFFFDF6F0);

  void _navegar(int index) {
    setState(() {
      _paginaAtual = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/lista-habitos');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/metas');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/config');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/amigos');
    } else if (index == 4) {
      _usuarioController.logout(context);
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
        title: Text(
          'Seus Hábitos',
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
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: _habitController.listarHabitosUsuario(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'Nenhum hábito encontrado.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    final habitos = snapshot.data!.docs;

                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: habitos.length,
                      itemBuilder: (context, index) {
                        final habito =
                            habitos[index].data() as Map<String, dynamic>;
                        final String habitoId = habitos[index].id;
                        final String nome = habito['nome'];
                        final int progresso = habito['progresso'];
                        final String lembrete = habito['lembrete'];
                        final String frequencia = habito['frequencia'];
                        final String categoria = habito['categoria'];
                        final int? corInt = habito['cor'];
                        final Color cor =
                            corInt != null ? Color(corInt) : activeColor;

                        return CardHabito(
                          habitoId: habitoId,
                          nome: nome,
                          color: cor,
                          frequencia: frequencia,
                          categoria: categoria,
                          progresso: progresso,
                          lembrete: lembrete,
                          onTap: () {
                            Navigator.pushNamed(context, '/cadastro-habito',
                                arguments: {
                                  'habitoId': habitoId,
                                  'nome': nome,
                                  'lembrete': lembrete,
                                  'frequencia': frequencia,
                                  'categoria': categoria,
                                  'cor': corInt ?? activeColor.value,
                                  'progress': progresso
                                });
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Excluir Hábito'),
                                content: Text(
                                    'Tem certeza que deseja excluir o hábito "$nome"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _habitController.deletarHabito(
                                          context, habitoId);
                                    },
                                    child: Text(
                                      'Excluir',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          onIncrement: () async {
                            await _habitController.incrementarProgresso(
                                context, habitoId);
                          },
                          onRemove: () async {
                            _confirmarRemoverHabito(context, habitoId);
                          },
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
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
                  Icons.check_circle,
                  size: 32,
                  color: _paginaAtual == 1 ? activeColor : inactiveColor,
                ),
                onPressed: () => _navegar(1),
                tooltip: 'Metas',
              ),
              IconButton(
                icon: Icon(
                  Icons.people_alt,
                  size: 32,
                  color: _paginaAtual == 3 ? activeColor : inactiveColor,
                ),
                onPressed: () => _navegar(3),
                tooltip: 'Amigos',
              ),
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
                  Icons.settings,
                  size: 32,
                  color: _paginaAtual == 2 ? activeColor : inactiveColor,
                ),
                onPressed: () => _navegar(2),
                tooltip: 'Configurações',
              ),
              IconButton(
                icon: Icon(
                  Icons.logout,
                  size: 32,
                  color: _paginaAtual == 4 ? activeColor : inactiveColor,
                ),
                onPressed: () => _usuarioController.logout(context),
                tooltip: 'Sair',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: activeColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add, size: 30),
        onPressed: () {
          Navigator.pushNamed(context, '/cadastro-habito');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _confirmarRemoverHabito(BuildContext context, String habitoId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Remover Hábito"),
        content: Text("Tem certeza que deseja remover este hábito?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          TextButton(
              onPressed: () {
                _habitController.deletarHabito(context, habitoId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Hábito removido com sucesso!")),
                );
              },
              child:
                  const Text("Remover", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
