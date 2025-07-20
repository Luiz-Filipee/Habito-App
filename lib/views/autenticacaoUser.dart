import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habitoapp/auth/authFirebase.dart';
import 'package:habitoapp/controllers/loginController.dart';
import 'package:habitoapp/widgets/custom_button.dart';
import 'package:habitoapp/widgets/custom_textfield.dart';

class AutenticacaoUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var usuarioController = TextEditingController();
    var senhaController = TextEditingController();
    final LoginController _controller = LoginController(AutenticacaoFirebase());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1ED),
      body: Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
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
                          'Login',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
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
                      CustomTextField(
                          controller: senhaController,
                          hintText: 'Password',
                          icon: Icons.lock_outline,
                          obscureText: false),
                      const SizedBox(
                        height: 20,
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: null,
                            child: const Text(
                              'Esqueceu sua senha?',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomButton(
                        text: 'Login',
                        onPressed: () async {
                          print('Usuário: $usuarioController.text');
                          print('Senha: $senhaController.text');

                          await _controller.fazerLogin(usuarioController.text,
                              senhaController.text, context);
                        },
                      ),
                      const SizedBox(height: 40),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Não tenho uma conta?",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Criar Conta',
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
