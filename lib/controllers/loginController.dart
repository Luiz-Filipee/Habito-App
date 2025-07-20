import 'package:flutter/material.dart';
import 'package:habitoapp/auth/authFirebase.dart';

class LoginController {
  final AutenticacaoFirebase _auth;

  LoginController(this._auth);

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
      Navigator.pushReplacementNamed(context, "/listagem");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado)),
      );
    }
  }

  Future<void> registarUsuario(
      String username, String senha, BuildContext context) async {
    if (username.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    String resultado = await _auth.registerWithEmailPassword(username, senha);

    if (resultado.contains("Usuário registrado")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado)),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    String resultado = await _auth.signOut();

    if (resultado.contains("Usuário desconectado")) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado)),
      );
    }
  }

  Future<void> verificarUsuarioLogado(BuildContext context) async {
    bool isLoggedIn = await _auth.isUserLoggedIn();

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/listagem');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
