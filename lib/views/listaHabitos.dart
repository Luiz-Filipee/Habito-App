import 'package:flutter/material.dart';
import 'package:habitoapp/controllers/habitoController.dart';
import 'package:habitoapp/widgets/cardHabito.dart';
import 'package:habitoapp/widgets/headerHabito.dart';

class ListaHabitos extends StatefulWidget {
  @override
  State<ListaHabitos> createState() => _ListaHabitosState();
}

class _ListaHabitosState extends State<ListaHabitos> {
  final HabitController _habitController = HabitController();
  int _paginaAtual = 0;

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
      backgroundColor: const Color(0XFFF5F1ED),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              const HeaderHabitos(),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder(
                  stream: _habitController.listarHabitosUsuario(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text('Nenhum hábito encontrado.'));
                    }

                    final habitos = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: habitos.length,
                      itemBuilder: (context, index) {
                        final habito =
                            habitos[index].data() as Map<String, dynamic>;
                        final String nome = habito['nome'];
                        final int progresso = habito['progresso'];
                        final String lembrete = habito['lembrete'];
                        final int? corInt = habito['cor'];
                        final Color cor =
                            corInt != null ? Color(corInt) : Colors.blueAccent;

                        return CardHabito(
                            nome: nome,
                            color: cor,
                            progresso: progresso,
                            lembrete: lembrete);
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
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), // canto superior esquerdo arredondado
            topRight: Radius.circular(24), // canto superior direito arredondado
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 16, bottom: 12), // espaço vertical
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home_outlined,
                  size: 30,
                  color: _paginaAtual == 0 ? Colors.blueAccent : Colors.grey,
                ),
                onPressed: () => _navegar(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.check_circle_outline,
                  size: 30,
                  color: _paginaAtual == 1 ? Colors.blueAccent : Colors.grey,
                ),
                onPressed: () => _navegar(1),
              ),
              IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  size: 30,
                  color: _paginaAtual == 2 ? Colors.blueAccent : Colors.grey,
                ),
                onPressed: () => _navegar(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
