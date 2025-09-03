import 'package:flutter/material.dart';
import 'package:habitoapp/auth/authFirebase.dart';
import 'package:habitoapp/controllers/loginController.dart';
import 'package:habitoapp/views/cadastroUser.dart';
import 'package:habitoapp/views/recuparSenhaUser.dart';
import 'package:habitoapp/widgets/custom_button.dart';
import 'package:habitoapp/widgets/custom_textfield.dart';

class AutenticacaoUser extends StatefulWidget {
  @override
  _AutenticacaoUserState createState() => _AutenticacaoUserState();
}

class _AutenticacaoUserState extends State<AutenticacaoUser>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation =
        Tween<double>(begin: 0.9, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var usuarioController = TextEditingController();
    var senhaController = TextEditingController();
    final LoginController _controller = LoginController(AutenticacaoFirebase());

    final Color primaryColor = Color(0xFFFF6B6B);
    final Color backgroundColor = Color(0xFFFDF6F0);
    final Color textColor = Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(
                  Icons.favorite,
                  color: primaryColor,
                  size: 80,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hábito',
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '+',
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      letterSpacing: 1.1,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Container(
                width: 380,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 26),
                    CustomTextField(
                      controller: usuarioController,
                      hintText: 'Email',
                      icon: Icons.email_outlined,
                      obscureText: false,
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: senhaController,
                      hintText: 'Senha',
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecuparSenhaUser()),
                          );
                        },
                        child: Text(
                          'Esqueceu sua senha?',
                          style: TextStyle(
                            fontSize: 15,
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Login',
                      backgroundColor: primaryColor,
                      textColor: Colors.white,
                      onPressed: () async {
                        await _controller.fazerLogin(usuarioController.text,
                            senhaController.text, context);
                      },
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: Text(
                        "Não tenho uma conta?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: textColor,
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CadastroUser()),
                          );
                        },
                        child: Text(
                          'Criar Conta',
                          style: TextStyle(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
