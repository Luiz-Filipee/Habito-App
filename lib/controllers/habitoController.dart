import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HabitController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> cadastrarHabitoTeste(
      BuildContext context,
      String nome,
      String lembrete,
      int cor,
      String frequencia,
      String categoria,
      int progresso,
      String? userId) async {
    try {
      await FirebaseFirestore.instance.collection('habitos').add({
        'nome': nome,
        'lembrete': lembrete,
        'cor': cor,
        'frequencia': frequencia,
        'categoria': categoria,
        'progresso': progresso,
        'usuarioID': userId,
      });
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
          SnackBar(
            content: Text('Você já completou o progresso para este período!'),
          ),
        );
        return;
      }

      await _firestore.collection('habitos').doc(habitoId).update({
        'progresso': progressoAtual + 1,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Progresso atualizado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar progresso: $e')),
      );
    }
  }
}
