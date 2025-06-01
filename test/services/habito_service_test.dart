import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitoapp/firebase_options.dart';
import 'package:habitoapp/models/habito_model.dart';
import 'package:habitoapp/models/registroHabito_model.dart';
import 'package:habitoapp/services/habito_service.dart';

void main() {
  final service = HabitoService();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  test('Adicionar e buscar hábito', () async {
    final registro = RegistroHabito(
      id: 'r1',
      data: DateTime.parse('2025-05-31T10:00:00Z'),
      concluido: true,
    );

    final habito = Habito(
      id: '', 
      nome: 'Meditar',
      frequencia: 'Meditar 10 minutos',
      notificacoes: ['09:00'],
      progresso: [registro],
      categoria: 'Leitura',
      usuarioId: 'user_test',
    );

    await service.criarHabito(habito);
    final habitos = await service.obterHabitos('user_test');

    expect(habitos.any((h) => h.nome == 'Meditar'), true);
  });
}
