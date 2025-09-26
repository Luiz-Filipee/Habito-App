import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaProgressoAmigos extends StatefulWidget {
  const TelaProgressoAmigos({super.key});

  @override
  State<TelaProgressoAmigos> createState() => _TelaProgressoAmigosState();
}

class _TelaProgressoAmigosState extends State<TelaProgressoAmigos> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Color activeColor = const Color(0xFFFF6B6B);

  String? meuUid;

  @override
  void initState() {
    super.initState();
    meuUid = _auth.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    if (meuUid == null) {
      return const Center(child: Text("Usuário não logado."));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: activeColor,
        elevation: 4,
        centerTitle: true,
        title: const Text(
          'Progresso de Amigos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('usuarios')
            .doc(meuUid)
            .collection('progressoRecebido')
            .orderBy('data', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Nenhum progresso recebido."));
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: snapshot.data!.docs.map((doc) {
              final deUid = doc['de'] ?? '';
              final mensagem = doc['mensagem'] ?? '';
              final timestamp = doc['data'] as Timestamp?;
              final dataFormatada = timestamp != null
                  ? "${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year} ${timestamp.toDate().hour}:${timestamp.toDate().minute.toString().padLeft(2, '0')}"
                  : "";

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFF6B6B),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: FutureBuilder<DocumentSnapshot>(
                    future: _firestore.collection('usuarios').doc(deUid).get(),
                    builder: (context, snapshotNome) {
                      if (!snapshotNome.hasData)
                        return const Text("Carregando...");
                      final nome = snapshotNome.data!['nome'] ?? 'Amigo';
                      return Text(nome,
                          style: const TextStyle(fontWeight: FontWeight.bold));
                    },
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mensagem),
                      const SizedBox(height: 4),
                      Text(
                        dataFormatada,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Remover progresso"),
                          content: const Text(
                              "Deseja realmente remover este progresso?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Remover"),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await _firestore
                            .collection('usuarios')
                            .doc(meuUid)
                            .collection('progressoRecebido')
                            .doc(doc.id)
                            .delete();
                      }
                    },
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
