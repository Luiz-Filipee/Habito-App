import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habitoapp/auth/authFirebase.dart';

class UsuarioController {
  final AutenticacaoFirebase _auth;
  final FirebaseAuth _authUser = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UsuarioController(this._auth);

  Future<void> fazerLogin(
      String username, String senha, BuildContext context) async {
    if (username.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos.')));
      return;
    }

    String resultado = await _auth.signInWithEmailPassword(username, senha);

    if (resultado.contains("Usuário autenticado")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seja Bem-vindo $username.')),
      );
      Navigator.pushReplacementNamed(context, "/lista-habitos");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado)),
      );
    }
  }

  Future<void> criarUsuarioSeNaoExistir(String userId, String email) async {
    final docRef = _firestore.collection('usuarios').doc(userId);

    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      await docRef.set({
        'xp': 0,
        'nivel': 1,
        'medalhas': ['novato'],
        'amigos': [],
        'pedidosAmizade': [],
        'email': email,
      });
    } else {
      return null;
    }
  }

  Future<User?> registarUsuario(
      String email, String senha, String nome, BuildContext context) async {
    try {
      UserCredential cred = await _authUser.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      if (cred.user != null) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(cred.user!.uid)
            .set({
          'xp': 0,
          'nivel': 1,
          'medalhas': ['novato'],
          'amigos': [],
          'pedidosAmizade': [],
          'email': email,
          'nome': nome,
        });

        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(cred.user!.uid)
            .update({
          'medalhas': FieldValue.arrayUnion(['novato']),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Parabéns! Você ganhou a medalha: Novato!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario cadastrado com sucesso!')),
      );
      Navigator.pushReplacementNamed(context, '/auth');
      return cred.user;
    } catch (e) {
      print("Erro ao registrar: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao cadastrar usuário")),
      );
      return null;
    }
  }

  Future<void> logout(BuildContext context) async {
    String resultado = await _auth.signOut();

    if (resultado.contains("Usuário desconectado")) {
      Navigator.pushReplacementNamed(context, '/auth');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado)),
      );
    }
  }

  Future<String?> getUserSession(BuildContext context) async {
    return _authUser.currentUser?.uid;
  }

  Future<Map<String, dynamic>?> getInfoUser(BuildContext context) async {
    String? idUser = await getUserSession(context);
    if (idUser == null) return null;

    final doc = await _firestore.collection('usuarios').doc(idUser).get();

    return doc.data();
  }

  Future<void> verificarUsuarioLogado(BuildContext context) async {
    bool isLoggedIn = await _auth.isUserLoggedIn();

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/listagem');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> alteraNome(BuildContext context, String novoNome) async {
    try {
      final uid = await this.getUserSession(context);
      if (uid == null) throw Exception("Usuário não logado");

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .update({'nome': novoNome});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nome alterado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao alterar nome: $e')),
      );
    }
  }

  Future<void> recuparSenha(BuildContext context, String email) async {
    String resultado = await _auth.sendPasswordResetEmail(email);
    if (resultado.contains("E-mail de redefinição enviado com sucesso")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email enviado para $email')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado)),
      );
    }
  }

  Stream<DocumentSnapshot> dadosGamificacaoUsuarioStream(String userId) {
    return FirebaseFirestore.instance
        .collection("usuarios")
        .doc(userId)
        .snapshots();
  }

  Future<void> compartilharProgresso(String mensagem) async {
    final currentUser = _authUser.currentUser;
    if (currentUser == null) return;

    final userDoc =
        await _firestore.collection('usuarios').doc(currentUser.uid).get();
    final amigos = List<String>.from(userDoc['amigos'] ?? []);

    for (var amigoId in amigos) {
      await _firestore
          .collection('usuarios')
          .doc(amigoId)
          .collection('progressoRecebido')
          .add({
        'de': currentUser.uid,
        'mensagem': mensagem,
        'data': FieldValue.serverTimestamp(),
      });
    }
  }
}
