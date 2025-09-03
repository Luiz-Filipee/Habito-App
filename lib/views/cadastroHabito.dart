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
  String _categoria = 'Corrida';
  int _progresso = 0;

  bool _modoEdicao = false;
  String? _habitoId;
  String _tituloPagina = 'Novo Hábito';
  String _textoBotao = 'Criar Hábito';

  final Color primaryColor = Color(0xFFFF6B6B);
  final Color backgroundColor = Color(0xFFFDF6F0);
  final Color textColor = Color(0xFFFF6B6B);
  final categorias = ['Corrida', 'Leitura', 'Trabalho'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _modoEdicao = true;
      _habitoId = args['habitoId'];
      _nomeController.text = args['nome'] ?? '';
      _lembreteController.text = args['lembrete'] ?? '';
      _frequencia = args['frequencia'] ?? 'Diário';

      String cat = (args['categoria'] ?? 'Corrida').trim();
      if (categorias.any((c) => c.toLowerCase() == cat.toLowerCase())) {
        _categoria =
            categorias.firstWhere((c) => c.toLowerCase() == cat.toLowerCase());
      } else {
        _categoria = 'Corrida';
      }

      _progresso = args['progresso'] ?? 0;
      _tituloPagina = 'Editar Hábito';
      _textoBotao = 'Salvar Alterações';
    }
  }

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
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    _tituloPagina,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  if (!_modoEdicao) ...[
                    const SizedBox(width: 10),
                    Text(
                      '+',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 18,
                      offset: Offset(0, -6),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        'Nome',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _nomeController,
                        hintText: 'Ex: Ler 5 livros',
                        icon: Icons.title,
                        obscureText: false,
                      ),
                      const SizedBox(height: 25),
                      Text(
                        'Categoria',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: primaryColor, width: 1.8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _categoria,
                            isExpanded: true,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                            items: ['Corrida', 'Leitura', 'Trabalho']
                                .map((cat) => DropdownMenuItem(
                                      value: cat,
                                      child: Text(cat),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _categoria = value!;
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            iconEnabledColor: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        'Frequência',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: primaryColor, width: 1.8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _frequencia,
                            isExpanded: true,
                            style: TextStyle(fontSize: 18, color: Colors.black),
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
                            iconEnabledColor: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        'Lembrete',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                        text: _textoBotao,
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                        onPressed: () async {
                          String? userId =
                              await _controllerUser.getUserSession(context);

                          if (_modoEdicao && _habitoId != null) {
                            await _controller.editarHabito(
                              context,
                              _habitoId!,
                              _nomeController.text,
                              _lembreteController.text,
                              _frequencia,
                              _categoria,
                              0x7DD1EF,
                              _progresso,
                            );
                          } else {
                            await _controller.cadastrarHabitoTeste(
                              context,
                              _nomeController.text,
                              _lembreteController.text,
                              0x7DD1EF,
                              _frequencia,
                              _categoria,
                              0,
                              userId,
                            );
                          }
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
