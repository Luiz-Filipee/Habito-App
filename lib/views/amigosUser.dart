import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:habitoapp/auth/authFirebase.dart';
import 'package:habitoapp/controllers/amigoController.dart';
import 'package:habitoapp/controllers/usuarioController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitoapp/views/progressoAmigos.dart';

class TelaAmigos extends StatefulWidget {
  const TelaAmigos({super.key});

  @override
  State<TelaAmigos> createState() => _TelaAmigosState();
}

class _TelaAmigosState extends State<TelaAmigos> {
  final AmigoController friendController = AmigoController();
  final UsuarioController usuarioController =
      UsuarioController(AutenticacaoFirebase());
  final Color activeColor = const Color(0xFFFF6B6B);
  final Color backgroundColor = const Color(0xFFFDF6F0);
  final Color inactiveColor = Colors.grey.shade400;
  int _paginaAtual = 3;

  void _navegar(int index) {
    setState(() {
      _paginaAtual = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/lista-habitos');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/metas');
        break;
      case 2:
        Navigator.pushNamed(context, '/config');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/amigos');
        break;
      case 4:
        usuarioController.logout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: activeColor,
        elevation: 4,
        centerTitle: true,
        title: const Text(
          'Amigos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: friendController.listarAmigos(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text("Nenhum amigo adicionado."));
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      final nome = doc['nome'];
                      final email = doc['email'];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: activeColor,
                            child:
                                const Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(email),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () {
                              _confirmarRemoverAmigo(context, doc.id, nome);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
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
                onPressed: () => usuarioController.logout(context),
                tooltip: 'Sair',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.person,
        backgroundColor: activeColor,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: Icon(Icons.person_add, color: Colors.white),
            backgroundColor: activeColor,
            label: 'Adicionar Amigo',
            onTap: () => mostrarDialogAdicionarAmigo(context),
          ),
          SpeedDialChild(
            child: Icon(Icons.mail, color: Colors.white),
            backgroundColor: activeColor,
            label: 'Ver Solicitações',
            onTap: () => mostrarPedidosRecebidos(context),
          ),
          SpeedDialChild(
            child: Icon(Icons.share, color: Colors.white),
            backgroundColor: activeColor,
            label: 'Compartilhar Progresso',
            onTap: () => _mostrarDialogCompartilharProgresso(context),
          ),
          SpeedDialChild(
            child: Icon(Icons.auto_graph_sharp, color: Colors.white),
            backgroundColor: activeColor,
            label: 'Ver Progresso Amigos',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TelaProgressoAmigos()),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void mostrarDialogAdicionarAmigo(BuildContext context) {
    String email = '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Adicionar Amigo"),
        content: TextField(
          decoration:
              const InputDecoration(hintText: "Digite o email do amigo"),
          onChanged: (value) => email = value,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          TextButton(
              onPressed: () {
                if (email.isNotEmpty) {
                  friendController.enviarPedidoAmizade(email);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Pedido enviado!")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Informe um email!")));
                }
              },
              child: const Text("Enviar")),
        ],
      ),
    );
  }

  void mostrarPedidosRecebidos(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pedidos Recebidos"),
        content: StreamBuilder<QuerySnapshot>(
          stream: friendController.listarPedidos(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text("Nenhum pedido recebido.");
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: snapshot.data!.docs.map((doc) {
                final nome = doc['nome'];
                return ListTile(
                  title: Text(nome),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () =>
                              friendController.aceitarAmizade(doc.id)),
                      IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () =>
                              friendController.recusarAmizade(doc.id)),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fechar")),
        ],
      ),
    );
  }

  void _confirmarRemoverAmigo(
      BuildContext context, String amigoId, String nome) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Remover Amigo"),
        content:
            Text("Tem certeza que deseja remover $nome da lista de amigos?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          TextButton(
              onPressed: () {
                friendController.removerAmigo(amigoId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("$nome foi removido da lista de amigos")),
                );
              },
              child:
                  const Text("Remover", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  void _mostrarDialogCompartilharProgresso(BuildContext context) {
    String mensagem = '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Compartilhar Progresso"),
        content: TextField(
          decoration: const InputDecoration(
              hintText: "Digite sua mensagem de progresso"),
          onChanged: (value) => mensagem = value,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          TextButton(
              onPressed: () async {
                if (mensagem.isNotEmpty) {
                  await usuarioController.compartilharProgresso(mensagem);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Progresso compartilhado!")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Digite uma mensagem!")));
                }
              },
              child: const Text("Compartilhar")),
        ],
      ),
    );
  }
}
