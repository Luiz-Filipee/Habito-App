import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitoapp/firebase_options.dart';
import 'package:habitoapp/models/usuario_model.dart';
import 'package:habitoapp/services/usuario_service.dart';

void main() {
  final service = UsuarioService();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  test('Criar e obter usuário no Firestore real', () async {
    final usuario = Usuario(
      id: 'test_user_123',
      nome: 'Teste Usuario',
      email: 'teste@email.com',
    );

    await service.criarUsuario(usuario);

    final usuarioObtido = await service.obterUsuario('test_user_123');

    expect(usuarioObtido.id, usuario.id);
    expect(usuarioObtido.nome, usuario.nome);
    expect(usuarioObtido.email, usuario.email);

    await service.removerUsuario('test_user_123');
  });
}
