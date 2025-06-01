import 'package:habitoapp/models/habito_model.dart';

class Notificacao {
  final String id;
  final String horario;
  final String mensagem;
  final Habito habitoRelacionado;

  Notificacao({
    required this.id,
    required this.horario,
    required this.mensagem,
    required this.habitoRelacionado,
  });

  factory Notificacao.fromMap(Map<String, dynamic> map, String id) {
    return Notificacao(
      id: id,
      horario: map['horario'] ?? '',
      mensagem: map['mensagem'] ?? '',
      habitoRelacionado: Habito.fromMap(
        Map<String, dynamic>.from(map['habitoRelacionado']),
        map['habitoRelacionado']['id'] ?? '',
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'horario': horario,
      'mensagem': mensagem,
      'habitoRelacionado': habitoRelacionado.toMap()
        ..addAll({'id': habitoRelacionado.id}),
    };
  }
}
