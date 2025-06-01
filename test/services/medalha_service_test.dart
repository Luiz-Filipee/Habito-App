import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitoapp/firebase_options.dart';
import 'package:habitoapp/models/medalha_model.dart';
import 'package:habitoapp/services/medalha_service.dart';

void main() {
  final service = MedalhaService();
  const medalhaId = 'medalha_test_123';

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  test('Criar, obter e deletar medalha no Firestore real', () async {
    final medalha = Medalha(
      id: medalhaId,
      nome: 'Foco Total',
      descricao: 'Complete 30 dias seguidos de hábito',
      imagem: 'foco_total.png',
      requisitos: '30 dias consecutivos',
    );

    await service.criarMedalha(medalha);

    final medalhas = await service.obterMedalhas();
    final encontrada =
        medalhas.any((m) => m.id == medalhaId && m.nome == 'Foco Total');

    expect(encontrada, true);

    await service.deletarMedalha(medalhaId);
  });
}
