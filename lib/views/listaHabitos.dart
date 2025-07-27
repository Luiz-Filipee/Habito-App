import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habitoapp/controllers/habitoController.dart';
import 'package:habitoapp/widgets/cardHabito.dart';
import 'package:habitoapp/widgets/headerHabito.dart';

class ListaHabitos extends StatelessWidget {
  final HabitController _habitController = HabitController();

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
                        final String? corHex = habito['cor'];
                        final Color cor = corHex != null
                            ? Color(int.parse('FF${corHex.replaceAll('#', '')}',
                                radix: 16))
                            : Colors.blueAccent;

                        return CardHabito(
                          nome: nome,
                          progresso: progresso,
                          color: cor,
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
    );
  }
}
