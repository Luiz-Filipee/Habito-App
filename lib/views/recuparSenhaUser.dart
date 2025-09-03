import 'package:flutter/material.dart';
import 'package:habitoapp/auth/authFirebase.dart';
import 'package:habitoapp/controllers/loginController.dart';
import 'package:habitoapp/views/autenticacaoUser.dart';
import 'package:habitoapp/widgets/custom_button.dart';
import 'package:habitoapp/widgets/custom_textfield.dart';

class RecuparSenhaUser extends StatefulWidget {
  @override
  _RecuperarSenhaUserState createState() => _RecuperarSenhaUserState();
}

class _RecuperarSenhaUserState extends State<RecuparSenhaUser>
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
              const SizedBox(height: 140),
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
                height: 450,
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
                      'Informe seu email de cadastro',
                      style: TextStyle(
                        fontSize: 20,
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
                    CustomButton(
                      text: 'Enviar Email',
                      backgroundColor: primaryColor,
                      textColor: Colors.white,
                      onPressed: () async {
                        await _controller.recuparSenha(
                            context, usuarioController.text);
                      },
                    ),
                    const SizedBox(height: 150),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AutenticacaoUser()),
                          );
                        },
                        child: Text(
                          'Voltar para login',
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
