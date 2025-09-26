import 'package:flutter/material.dart';
import 'package:habitoapp/auth/authFirebase.dart';
import 'package:habitoapp/controllers/usuarioController.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => ConfigScreenState();
}

class ConfigScreenState extends State<ConfigScreen> {
  int _paginaAtual = 2;
  final UsuarioController _usuarioController =
      UsuarioController(AutenticacaoFirebase());

  void _navegar(int index) {
    setState(() {
      _paginaAtual = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/lista-habitos');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/metas');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/config');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/amigos');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFFF6B6B);
    final UsuarioController _usuarioController =
        UsuarioController(AutenticacaoFirebase());
    final Color activeColor = const Color(0xFFFF6B6B);
    final Color inactiveColor = Colors.grey.shade400;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      appBar: AppBar(
        backgroundColor: activeColor,
        elevation: 4,
        centerTitle: true,
        title: const Text(
          'Configurações',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _usuarioController.getInfoUser(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Erro ao carregar usuário"));
          }

          final userData = snapshot.data!;
          final userName = userData['nome'] ?? 'Usuário';
          final userEmail = userData['email'] ?? 'email@dominio.com';

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: primaryColor.withOpacity(0.3),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFFFF6B6B),
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userEmail,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: () {
                          mostrarDialogAlterarNome(context);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Preferências',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 10),
                _buildNotificacaoOption(context),
                _buildConfigOption(
                  icon: Icons.palette,
                  text: 'Tema do App',
                  onTap: () {
                    _selecionarTema(context);
                  },
                ),
                _buildConfigOption(
                  icon: Icons.lock,
                  text: 'Alterar senha',
                  onTap: () {
                    mostrarDialogRecuperarSenha(context);
                  },
                ),
                _buildConfigOption(
                  icon: Icons.language,
                  text: 'Idioma',
                  onTap: () {
                    _selecionarIdioma(context);
                  },
                ),
                const SizedBox(height: 30),
                const Text(
                  'Informações',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 10),
                _buildConfigOption(
                  icon: Icons.description,
                  text: 'Termos de Uso',
                  onTap: () {
                    _mostrarDialogo(
                      context,
                      'Termos de Uso',
                      '''Bem-vindo ao HabitoApp!

Ao utilizar este aplicativo, você concorda com os seguintes termos:

1. O aplicativo tem como objetivo auxiliar no acompanhamento de hábitos e metas pessoais.
2. O usuário é responsável pelas informações inseridas na plataforma.
3. É proibido o uso do aplicativo para fins ilegais ou que violem direitos de terceiros.
4. O HabitoApp pode passar por atualizações, ajustes ou interrupções temporárias sem aviso prévio.
5. Reservamo-nos o direito de suspender ou encerrar contas que descumprirem estes termos.

Ao continuar utilizando o HabitoApp, você declara estar de acordo com estas condições.''',
                    );
                  },
                ),
                _buildConfigOption(
                  icon: Icons.privacy_tip,
                  text: 'Política de Privacidade',
                  onTap: () {
                    _mostrarDialogo(
                      context,
                      'Política de Privacidade',
                      '''O HabitoApp valoriza a sua privacidade. 

- Coletamos apenas informações essenciais, como nome, e-mail e dados de hábitos cadastrados.
- Seus dados são armazenados em servidores seguros e não serão compartilhados com terceiros sem sua permissão.
- Você pode solicitar a exclusão da sua conta e de todos os seus dados a qualquer momento.
- Utilizamos as informações apenas para fornecer a melhor experiência no uso do aplicativo.
- O HabitoApp não compartilha informações pessoais para fins de marketing sem o seu consentimento.

Ao utilizar o HabitoApp, você concorda com esta política de privacidade.''',
                    );
                  },
                ),
                _buildConfigOption(
                  icon: Icons.info_outline,
                  text: 'Sobre o App',
                  onTap: () {
                    _mostrarDialogo(
                      context,
                      'Sobre o App',
                      '''O HabitoApp foi desenvolvido para ajudar você a criar, organizar e manter seus hábitos de forma prática e motivadora.

Com ele, você pode:
- Registrar e acompanhar hábitos diários, semanais ou mensais;
- Estabelecer metas personalizadas;
- Visualizar seu progresso em tempo real;
- Compartilhar conquistas com amigos.

Nosso objetivo é tornar a criação de hábitos mais simples e prazerosa, apoiando sua evolução pessoal e bem-estar.

Versão: 1.0.0''',
                    );
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () {
                    _usuarioController.logout(context);
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Sair',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _buildConfigOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFFFF6B6B)),
        title: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }

  void _mostrarDialogo(BuildContext context, String titulo, String conteudo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(
            conteudo,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  void _selecionarIdioma(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Selecione o idioma"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Português"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Idioma alterado para Português")),
                );
              },
            ),
            ListTile(
              title: const Text("Inglês"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Idioma alterado para Inglês")),
                );
              },
            ),
            ListTile(
              title: const Text("Espanhol"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Idioma alterado para Espanhol")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _selecionarTema(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Selecione o tema"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text("Claro"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tema alterado para Claro")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text("Escuro"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tema alterado para Escuro")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: const Text("Automático (Sistema)"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tema seguindo o sistema")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    final Color activeColor = const Color(0xFFFF6B6B);
    final Color inactiveColor = Colors.grey.shade400;

    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, -3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.check_circle,
                size: 32,
                color: _paginaAtual == 1 ? activeColor : inactiveColor,
              ),
              onPressed: () => _navegar(1),
              tooltip: 'Metas',
            ),
            IconButton(
              icon: Icon(
                Icons.people_alt,
                size: 32,
                color: _paginaAtual == 3 ? activeColor : inactiveColor,
              ),
              onPressed: () => _navegar(3),
              tooltip: 'Amigos',
            ),
            IconButton(
              icon: Icon(
                Icons.home_filled,
                size: 32,
                color: _paginaAtual == 0 ? activeColor : inactiveColor,
              ),
              onPressed: () => _navegar(0),
              tooltip: 'Início',
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                size: 32,
                color: _paginaAtual == 2 ? activeColor : inactiveColor,
              ),
              onPressed: () => _navegar(2),
              tooltip: 'Configurações',
            ),
          ],
        ),
      ),
    );
  }

  bool notificacoesAtivas = true;

  Widget _buildNotificacaoOption(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        activeColor: const Color(0xFFFF6B6B),
        title: const Text(
          "Notificações",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        value: notificacoesAtivas,
        onChanged: (value) {
          notificacoesAtivas = value;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  value ? "Notificações ativadas" : "Notificações desativadas"),
            ),
          );
        },
      ),
    );
  }

  void mostrarDialogRecuperarSenha(BuildContext context) {
    String email = '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Recuperar Senha"),
        content: TextField(
          decoration:
              const InputDecoration(hintText: "Digite o email de cadastro"),
          onChanged: (value) => email = value,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          TextButton(
              onPressed: () {
                if (email.isNotEmpty) {
                  _usuarioController.recuparSenha(context, email);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Email de recuperação de senha enviado!")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Informe um email!")));
                }
              },
              child: const Text("Enviar")),
        ],
      ),
    );
  }

  void mostrarDialogAlterarNome(BuildContext context) {
    String nome = '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Alterar Nome"),
        content: TextField(
          decoration: const InputDecoration(hintText: "Digite o novo nome"),
          onChanged: (value) => nome = value,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          TextButton(
              onPressed: () {
                if (nome.isNotEmpty) {
                  _usuarioController.alteraNome(context, nome);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Nome alterado com sucesso!")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Informe um nome!")));
                }
              },
              child: const Text("Alterar")),
        ],
      ),
    );
  }
}
