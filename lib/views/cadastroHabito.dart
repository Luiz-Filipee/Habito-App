import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:habitoapp/auth/authFirebase.dart';
import 'package:habitoapp/controllers/habitoController.dart';
import 'package:habitoapp/controllers/loginController.dart';
import 'package:habitoapp/widgets/custom_button.dart';
import 'package:habitoapp/widgets/custom_textfield.dart';

class NovoHabitoPage extends StatefulWidget {
  const NovoHabitoPage({super.key});

  @override
  State<NovoHabitoPage> createState() => _NovoHabitoPageState();
}

class _NovoHabitoPageState extends State<NovoHabitoPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _lembreteController = TextEditingController();
  final _controller = HabitController();
  final _controllerUser = LoginController(AutenticacaoFirebase());
  String _frequencia = 'Diário';

  Future<void> _selecionarHorario() async {
    TimeOfDay? horaSelecionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );
    if (horaSelecionada != null) {
      setState(() {
        _lembreteController.text = horaSelecionada.format(context);
      });
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _lembreteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1ED),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 90,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Novo Hábito',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Nome',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      CustomTextField(
                        controller: _nomeController,
                        hintText: 'Ex: Ler 5 livros',
                        icon: Icons.title,
                        obscureText: false,
                      ),
                      const SizedBox(height: 25),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Frequência',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xF2EDE8E0),
                                blurRadius: 0,
                                offset: Offset(0, 2)),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _frequencia,
                            isExpanded: true,
                            items: ['Diário', 'Semanal', 'Mensal']
                                .map((freq) => DropdownMenuItem(
                                      value: freq,
                                      child: Text(freq),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _frequencia = value!;
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Lembrete',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _selecionarHorario,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _lembreteController,
                            hintText: 'Ex: 9:00 AM',
                            icon: Icons.access_time,
                            obscureText: false,
                          ),
                        ),
                      ),
                      const SizedBox(height: 45),
                      CustomButton(
                        text: 'Criar Hábito',
                        onPressed: () async {
                          String? userId =
                              await _controllerUser.getUserSession(context);
                          await _controller.cadastrarHabitoTeste(
                            context,
                            _nomeController.text,
                            _lembreteController.text,
                            0x7DD1EF,
                            2,
                            userId,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
