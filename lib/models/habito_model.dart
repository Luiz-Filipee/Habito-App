import 'package:habitoapp/models/registroHabito_model.dart';

class Habito {
  final String id;
  final String nome;
  final String frequencia;
  final List<String> notificacoes;
  final List<RegistroHabito> progresso;
  final String categoria;
  final String usuarioId;

  Habito({
    required this.id,
    required this.nome,
    required this.frequencia,
    required this.notificacoes,
    required this.progresso,
    required this.categoria,
    required this.usuarioId,
  });

  factory Habito.fromMap(Map<String, dynamic> map, String id) {
    return Habito(
      id: id,
      nome: map['nome'] ?? '',
      frequencia: map['frequencia'] ?? '',
      notificacoes: map['notificacoes'] != null
          ? List<String>.from(map['notificacoes'])
          : [],
      progresso: map['progresso'] != null
          ? List<Map<String, dynamic>>.from(map['progresso'])
              .map((item) => RegistroHabito.fromMap(item, item['id'] ?? ''))
              .toList()
          : [],
      categoria: map['categoria'] ?? '',
      usuarioId: map['usuarioId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'frequencia': frequencia,
      'notificacoes': notificacoes,
      'progresso': progresso.map((r) => r.toMap()).toList(),
      'categoria': categoria,
      'usuarioId': usuarioId,
    };
  }
}
