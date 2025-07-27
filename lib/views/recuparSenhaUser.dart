import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habitoapp/auth/authFirebase.dart';
import 'package:habitoapp/controllers/loginController.dart';
import 'package:habitoapp/views/autenticacaoUser.dart';
import 'package:habitoapp/views/cadastroUser.dart';
import 'package:habitoapp/widgets/custom_button.dart';
import 'package:habitoapp/widgets/custom_textfield.dart';

class RecuparSenhaUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var usuarioController = TextEditingController();
    final LoginController _controller = LoginController(AutenticacaoFirebase());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1ED),
      body: Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Hábito',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    const Text(
                      '+',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    )
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ]),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Informe seu email de cadastro',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: usuarioController,
                        hintText: 'Email',
                        icon: Icons.email_outlined,
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                        text: 'Enviar Email',
                        onPressed: () async {
                          await _controller.recuparSenha(
                              context, usuarioController.text);
                        },
                      ),
                      const SizedBox(height: 40),
                      TextButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AutenticacaoUser()),
                          );
                        },
                        child: const Text(
                          'Voltar pra login',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF3A5BFF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
