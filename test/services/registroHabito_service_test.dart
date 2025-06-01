import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitoapp/firebase_options.dart';
import 'package:habitoapp/models/registroHabito_model.dart';
import 'package:habitoapp/services/registroHabito_service.dart';

void main() {
  final service = RegistroHabitoService();
  const habitoId = 'teste_habito_123';
  const registroId = 'teste_registro_123';

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  test('Criar, obter e deletar registro de hábito no Firestore real', () async {
    final registro = RegistroHabito(
      id: registroId,
      data: DateTime.now(),
      concluido: true,
    );

    await service.criarRegistro(registro, habitoId);

    final registros = await service.obterRegistros(habitoId);

    expect(
        registros.any((r) => r.id == registroId && r.concluido == true), true);

    await service.removerRegistro(habitoId, registroId);
  });
}
