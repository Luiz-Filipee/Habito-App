import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habitoapp/firebase_options.dart';
import 'package:habitoapp/utils/firebase_config.dart';
import 'package:habitoapp/views/autenticacaoUser.dart';

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
      routes: {'/auth': (context) => AutenticacaoUser()},
    );
  }
}
