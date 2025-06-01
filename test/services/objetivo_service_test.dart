import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitoapp/firebase_options.dart';
import 'package:habitoapp/models/objetivo_model.dart';
import 'package:habitoapp/services/objetivo_service.dart';

void main() {
  final service = ObjetivoService();
  const objetivoId = 'objetivo_test_123';

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  test('Criar, obter e deletar objetivo no Firestore real', () async {
    final objetivo = Objetivo(
      id: objetivoId,
      nome: 'Criar App',
      descricao: 'Desenvolver app até o final do mês',
      categoria: 'Estudos',
    );

    await service.criarObjetivo(objetivo);

    final objetivos = await service.obterObjetivos();
    final encontrado =
        objetivos.any((o) => o.id == objetivoId && o.nome == 'Criar App');

    expect(encontrado, true);

    await service.deletarObjetivo(objetivoId);
  });
}
