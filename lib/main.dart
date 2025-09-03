import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habitoapp/firebase_options.dart';
import 'package:habitoapp/utils/firebase_config.dart';
import 'package:habitoapp/views/autenticacaoUser.dart';
import 'package:habitoapp/views/cadastroHabito.dart';
import 'package:habitoapp/views/cadastroUser.dart';
import 'package:habitoapp/views/listaHabitos.dart';
import 'package:habitoapp/views/recuparSenhaUser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => AutenticacaoUser(),
        '/cadastro-user': (context) => CadastroUser(),
        '/recuper-senha-user': (context) => RecuparSenhaUser(),
        '/lista-habitos': (context) => ListaHabitos(),
        '/cadastro-habito': (context) => NovoHabitoPage()
      },
    );
  }
}
