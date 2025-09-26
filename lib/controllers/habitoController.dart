import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habitoapp/services/notificacao_service.dart';

class HabitController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final notificaoService = NotificacaoService();

  Future<void> cadastrarHabitoTeste(
      BuildContext context,
      String nome,
      String lembrete,
      int cor,
      String frequencia,
      String categoria,
      int progresso,
      String? userId) async {
    final habitos = await FirebaseFirestore.instance
        .collection('habitos')
        .where('usuarioId', isEqualTo: userId)
        .get();
    try {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('habitos').add({
        'nome': nome,
        'lembrete': lembrete,
        'cor': cor,
        'frequencia': frequencia,
        'categoria': categoria,
        'progresso': progresso,
        'usuarioID': userId,
      });
      await NotificacaoService.agendarNotificacaoHabito(
          id: docRef.hashCode, nomeHabito: nome, lembrete: lembrete);
      if (habitos.docs.isEmpty) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userId)
            .update({
          'medalhas': FieldValue.arrayUnion(['comecando_com_o_pe_direito'])
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                '🎉 Parabéns! Você ganhou a medalha: Crie seu primeiro hábito!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hábito cadastrado com sucesso.')),
      );
      Navigator.pushReplacementNamed(context, '/lista-habitos');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar hábito. $e')),
      );
    }
  }

  Stream<QuerySnapshot> listarHabitosUsuario() {
    final String? userId = _auth.currentUser?.uid;

    if (userId == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('habitos')
        .where('usuarioID', isEqualTo: userId)
        .snapshots();
  }

  Future<void> editarHabito(
      BuildContext context,
      String habitoId,
      String nome,
      String lembrete,
      String frequencia,
      String categoria,
      int cor,
      int progresso) async {
    try {
      await _firestore.collection('habitos').doc(habitoId).update({
        'nome': nome,
        'lembrete': lembrete,
        'categoria': categoria,
        'frequencia': frequencia,
        'cor': cor,
        'progresso': progresso
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hábito atualizado com sucesso.')),
      );

      Navigator.pushReplacementNamed(context, '/lista-habitos');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar hábito: $e')),
      );
    }
  }

  Future<void> deletarHabito(BuildContext context, String habitoId) async {
    try {
      await _firestore.collection('habitos').doc(habitoId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hábito deletado com sucesso.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar hábito: $e')),
      );
    }
  }

  Future<void> incrementarProgresso(
      BuildContext context, String habitoId) async {
    try {
      var habitoDoc =
          await _firestore.collection('habitos').doc(habitoId).get();

      if (!habitoDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hábito não encontrado.')),
        );
        return;
      }

      final data = habitoDoc.data()!;
      final int progressoAtual = data['progresso'] ?? 0;
      final String frequencia = data['frequencia']?.toLowerCase() ?? 'semanal';
      final String usuarioID = data['usuarioID'];

      int maximoProgresso;
      switch (frequencia) {
        case 'diário':
          maximoProgresso = 1;
          break;
        case 'semanal':
          maximoProgresso = 7;
          break;
        case 'mensal':
          maximoProgresso = 30;
          break;
        default:
          maximoProgresso = 7;
      }

      if (progressoAtual >= maximoProgresso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você já completou o progresso para este período!'),
          ),
        );
        return;
      }

      final int novoProgresso = progressoAtual + 1;
      await _firestore.collection('habitos').doc(habitoId).update({
        'progresso': novoProgresso,
      });

      await _firestore.collection('usuarios').doc(usuarioID).update({
        'xp': FieldValue.increment(20),
      });

      if (novoProgresso >= maximoProgresso) {
        await _firestore.collection('habitos').doc(habitoId).update({
          'concluido': true,
        });

        await _firestore.collection('usuarios').doc(usuarioID).update({
          'xp': FieldValue.increment(40),
        });

        final habitosConcluidos = await _firestore
            .collection('habitos')
            .where('usuarioID', isEqualTo: usuarioID)
            .where('concluido', isEqualTo: true)
            .get();

        if (habitosConcluidos.docs.length == 1) {
          await _firestore.collection('usuarios').doc(usuarioID).update({
            'medalhas': FieldValue.arrayUnion(['primeiro_habito_concluido'])
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  '🎉 Parabéns! Você ganhou a medalha: Primeiro Hábito Concluído!'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }

      final usuarioDoc =
          await _firestore.collection('usuarios').doc(usuarioID).get();
      final int xpAtual = usuarioDoc['xp'] ?? 0;
      final int nivelAtual = usuarioDoc['nivel'] ?? 1;

      final int novoNivel = (xpAtual ~/ 100) + 1;

      if (novoNivel > nivelAtual) {
        await _firestore.collection('usuarios').doc(usuarioID).update({
          'nivel': novoNivel,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Parabéns! Você subiu para o nível $novoNivel!')),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progresso atualizado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar progresso: $e')),
      );
    }
  }
}
