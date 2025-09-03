import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HabitController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> cadastrarHabitoTeste(BuildContext context, String nome,
      String lembrete, int cor, int progresso, String? userId) async {
    try {
      await FirebaseFirestore.instance.collection('habitos').add({
        'nome': nome,
        'lembrete': lembrete,
        'cor': cor,
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
    print(userId);
    if (userId == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('habitos')
        .where('usuarioID', isEqualTo: userId)
        .snapshots();
  }
}
