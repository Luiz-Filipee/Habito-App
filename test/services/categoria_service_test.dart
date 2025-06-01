import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitoapp/firebase_options.dart';
import 'package:habitoapp/models/categoria_model.dart';
import 'package:habitoapp/services/categoria_service.dart';

void main() {
  final service = CategoriaService();
  const categoriaId = 'categoria_test_001';

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  test('Criar, obter e deletar categoria no Firestore real', () async {
    final categoria = Categoria(
      id: categoriaId,
      nome: 'Produtividade',
      descricao: 'Melhoria do foco e da organização pessoal',
    );

    // Criar categoria
    await service.criarCategoria(categoria);

    // Obter categorias
    final categorias = await service.obterCategorias();
    final encontrada =
        categorias.any((c) => c.id == categoriaId && c.nome == 'Produtividade');

    expect(encontrada, true);

    // Deletar categoria
    await service.deletarCategoria(categoriaId);
  });
}
