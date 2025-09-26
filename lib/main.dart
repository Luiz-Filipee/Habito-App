import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habitoapp/firebase_options.dart';
import 'package:habitoapp/services/notificacao_service.dart';
import 'package:habitoapp/views/amigosUser.dart';
import 'package:habitoapp/views/autenticacaoUser.dart';
import 'package:habitoapp/views/cadastroHabito.dart';
import 'package:habitoapp/views/cadastroUser.dart';
import 'package:habitoapp/views/configUser.dart';
import 'package:habitoapp/views/estatisticasUser.dart';
import 'package:habitoapp/views/gamificacaoUser.dart';
import 'package:habitoapp/views/listaHabitos.dart';
import 'package:habitoapp/views/metasUserHabito.dart';
import 'package:habitoapp/views/progressoAmigos.dart';
import 'package:habitoapp/views/recuparSenhaUser.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificacaoService.inicializar();

  runApp(const MyApp());
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
        '/cadastro-habito': (context) => NovoHabitoPage(),
        '/metas': (context) => MetasUserHabitos(),
        '/gamificacao': (context) => GamificacaoUser(),
        '/estatisticas': (context) => EstatisticasUser(),
        '/amigos': (context) => TelaAmigos(),
        '/progresso-amigos': (context) => TelaProgressoAmigos(),
        '/config': (context) => ConfigScreen()
      },
    );
  }
}
