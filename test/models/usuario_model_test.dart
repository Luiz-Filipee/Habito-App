import 'package:flutter_test/flutter_test.dart';
import 'package:habitoapp/models/usuario_model.dart';

void main() {
  test('Criação de usuário via Map', () {
    final map = {'nome': 'João', 'email': 'joao@email.com'};
    final usuario = Usuario.fromMap(map, '123');

    expect(usuario.id, '123');
    expect(usuario.nome, 'João');
    expect(usuario.email, 'joao@email.com');
  });

  test('Conversão de usuário para Map', () {
    final usuario = Usuario(id: '1', nome: 'Maria', email: 'maria@email.com');
    final map = usuario.toMap();

    expect(map['nome'], 'Maria');
    expect(map['email'], 'maria@email.com');
  });
}
